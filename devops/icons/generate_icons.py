"""Builds every platform's app icon of an app from its logo in this folder.

Each app of the family has a logo here, devops/icons/<app>_logo.jpg. Deberc's
icons are the ones in the platform folders; every other app's go under
devops/apps/<app>/, which lays them over the checkout when it is switched to
that app.

The logo is two cards on a light backdrop. The cards are cut out of the
backdrop, keeping their soft shadow, and laid out the way each platform wants:

- Android: a legacy launcher icon per density, and an adaptive icon whose
  foreground keeps the cards inside the circle every launcher mask leaves.
- iOS: opaque icons on the backdrop colour, in every size the asset catalog
  lists.
- macOS: a rounded square on the backdrop colour, in every size the
  asset catalog lists.
- Windows: a multi-size .ico for the executable and installer, and a large
  PNG the MSIX package builds its tiles from.
- Linux: menu icons in the hicolor sizes the .deb installs.
- Web: the tab icon, the icons the web app installs to a home screen with,
  maskable ones that keep the cards inside the shape a launcher cuts, and an
  opaque one for iOS.

Run from the repository root: python devops/icons/generate_icons.py [app]
"""

import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[2]

# The light grey of the logo's backdrop, used wherever an icon must be opaque.
BACKDROP = (225, 229, 230)
# Pixels darker than this belong to a card; the backdrop and shadow are lighter.
CARD_EDGE = 90


def cut_out_cards(logo: Image.Image) -> Image.Image:
    """The cards on a transparent background, cropped to their shadow."""
    rgb = np.asarray(logo.convert("RGB")).astype(np.float32)
    lum = rgb @ np.array([0.299, 0.587, 0.114], dtype=np.float32)
    h, w = lum.shape

    # Everything light that can be reached from the border is backdrop or
    # shadow; the cards' dark outline encloses their gold marks.
    # Copied, as an image wrapping a NumPy array is read-only to flood fill.
    light = Image.fromarray(np.where(lum > CARD_EDGE, 255, 0).astype(np.uint8)).copy()
    for x, y in ((0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1)):
        if light.getpixel((x, y)) == 255:
            ImageDraw.floodfill(light, (x, y), 128)
    outside = np.asarray(light) == 128

    # The backdrop darkens from top to bottom; a shadow or a card's soft edge
    # is how far a pixel is from the backdrop towards the card colour.
    row_bg = np.array([np.median(lum[y][outside[y]]) if outside[y].any() else 220.0 for y in range(h)],
                      dtype=np.float32)[:, None]
    card = np.median(rgb[~outside], axis=0)
    card_lum = float(card @ np.array([0.299, 0.587, 0.114]))
    edge_alpha = np.clip((row_bg - lum) / (row_bg - card_lum), 0, 1)
    # The backdrop's own grain is not shadow.
    edge_alpha[edge_alpha < 0.05] = 0

    alpha = np.where(outside, edge_alpha, 1.0)
    out = rgb.copy()
    out[outside] = card
    rgba = np.dstack([out, alpha * 255]).round().astype(np.uint8)
    cut = Image.fromarray(rgba, "RGBA")
    # Cropped to what is clearly visible, so a faint shadow at the edge does
    # not shift or shrink the cards.
    return cut.crop(cut.getchannel("A").point(lambda v: 255 if v > 40 else 0).getbbox())


def fitted(cards: Image.Image, size: int, *, radius: float | None = None, box: float | None = None,
           background: tuple[int, int, int] | None = None) -> Image.Image:
    """The cards centred on a square canvas of [size] pixels.

    [box] fits the cards' bounding box into that share of the side; [radius]
    instead keeps every visible pixel within that share of the side from the
    centre, which is what a launcher's round mask needs.
    """
    a = np.asarray(cards)[:, :, 3]
    if radius is not None:
        ys, xs = np.nonzero(a > 40)
        cy, cx = (cards.height - 1) / 2, (cards.width - 1) / 2
        reach = np.sqrt((xs - cx) ** 2 + (ys - cy) ** 2).max()
        scale = radius * size / reach
    else:
        scale = (box or 1.0) * size / max(cards.size)
    w, h = max(1, round(cards.width * scale)), max(1, round(cards.height * scale))
    # Large steps first with a cheap filter, then the last step with Lanczos,
    # keeps the thin gold lines crisp at small sizes.
    small = cards
    while small.width > 2 * w:
        small = small.resize((small.width // 2, small.height // 2), Image.Resampling.BOX)
    small = small.resize((w, h), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (size, size), (*background, 255) if background else (0, 0, 0, 0))
    canvas.alpha_composite(small, ((size - w) // 2, (size - h) // 2))
    return canvas.convert("RGB") if background else canvas


def android(cards: Image.Image, out: Path) -> None:
    res = out / "android/app/src/main/res"
    densities = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}
    for name, k in densities.items():
        # Legacy icons are 48dp with the art inside a 44dp keyline circle.
        (res / f"mipmap-{name}").mkdir(parents=True, exist_ok=True)
        fitted(cards, round(48 * k), radius=0.46).save(res / f"mipmap-{name}/ic_launcher.png", optimize=True)
        # Adaptive foregrounds are 108dp, of which only a 66dp circle is
        # guaranteed to stay visible under any mask.
        fitted(cards, round(108 * k), radius=0.30).save(
            res / f"mipmap-{name}/ic_launcher_foreground.png", optimize=True)

    (res / "mipmap-anydpi-v26").mkdir(exist_ok=True)
    (res / "values").mkdir(exist_ok=True)
    (res / "mipmap-anydpi-v26/ic_launcher.xml").write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
        '    <background android:drawable="@color/ic_launcher_background"/>\n'
        '    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n'
        '</adaptive-icon>\n', encoding="utf-8")
    (res / "values/ic_launcher_background.xml").write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<resources>\n'
        '    <color name="ic_launcher_background">#{:02X}{:02X}{:02X}</color>\n'
        '</resources>\n'.format(*BACKDROP), encoding="utf-8")


def ios(cards: Image.Image, out: Path) -> None:
    catalog = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    images = json.loads((ROOT / catalog / "Contents.json").read_text(encoding="utf-8"))["images"]
    folder = out / catalog
    folder.mkdir(parents=True, exist_ok=True)
    for image in images:
        base = float(image["size"].split("x")[0])
        scale = int(image["scale"].rstrip("x"))
        size = round(base * scale)
        # iOS rounds the corners itself and rejects transparency.
        fitted(cards, size, box=0.82, background=BACKDROP).save(folder / image["filename"], optimize=True)


def macos(cards: Image.Image, out: Path) -> None:
    catalog = "macos/Runner/Assets.xcassets/AppIcon.appiconset"
    images = json.loads((ROOT / catalog / "Contents.json").read_text(encoding="utf-8"))["images"]
    folder = out / catalog
    folder.mkdir(parents=True, exist_ok=True)
    for size in sorted({int(i["filename"].rsplit("_", 1)[1].split(".")[0]) for i in images}):
        # macOS draws the icon as it is: a rounded square on the backdrop
        # colour, inset the way Apple's icon grid lays out every app icon.
        side = round(size * 824 / 1024)
        tile = Image.new("L", (side * 4, side * 4), 0)
        ImageDraw.Draw(tile).rounded_rectangle((0, 0, side * 4 - 1, side * 4 - 1), radius=round(side * 4 * 0.225),
                                               fill=255)
        mask = tile.resize((side, side), Image.Resampling.LANCZOS)
        icon = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        offset = (size - side) // 2
        icon.paste(Image.new("RGBA", (side, side), (*BACKDROP, 255)), (offset, offset), mask)
        art = fitted(cards, side, box=0.82)
        icon.alpha_composite(Image.composite(art, Image.new("RGBA", art.size, (0, 0, 0, 0)), mask), (offset, offset))
        icon.save(folder / f"app_icon_{size}.png", optimize=True)


def windows(cards: Image.Image, out: Path) -> None:
    resources = out / "windows/runner/resources"
    resources.mkdir(parents=True, exist_ok=True)
    sizes = [16, 20, 24, 32, 40, 48, 64, 96, 128, 256]
    # Each size is drawn on its own so small ones are resampled from the
    # full-size art rather than from a blurred larger icon.
    frames = [fitted(cards, s, box=0.96) for s in sizes]
    frames[-1].save(resources / "app_icon.ico", format="ICO", sizes=[(s, s) for s in sizes],
                    append_images=frames[:-1])
    fitted(cards, 1024, box=0.92).save(resources / "app_logo.png", optimize=True)


def linux(cards: Image.Image, out: Path) -> None:
    folder = out / "devops/linux/icons"
    folder.mkdir(parents=True, exist_ok=True)
    for size in (16, 24, 32, 48, 64, 128, 256, 512):
        fitted(cards, size, box=0.94).save(folder / f"{size}.png", optimize=True)


def web(cards: Image.Image, out: Path) -> None:
    folder = out / "web/icons"
    folder.mkdir(parents=True, exist_ok=True)
    fitted(cards, 32, box=0.96).save(out / "web/favicon.png", optimize=True)
    for size in (192, 512):
        fitted(cards, size, box=0.94).save(folder / f"Icon-{size}.png", optimize=True)
        # A maskable icon is cut to any shape, of which a circle of 40% of the
        # side around the centre always stays visible.
        fitted(cards, size, radius=0.36, background=BACKDROP).save(folder / f"Icon-maskable-{size}.png", optimize=True)
    # iOS rounds the corners itself and shows transparency as black.
    fitted(cards, 180, box=0.82, background=BACKDROP).save(folder / "apple-touch-icon.png", optimize=True)


def main() -> None:
    app = sys.argv[1] if len(sys.argv) > 1 else "deberc"
    out = ROOT if app == "deberc" else ROOT / "devops/apps" / app
    cards = cut_out_cards(Image.open(Path(__file__).with_name(f"{app}_logo.jpg")))
    android(cards, out)
    ios(cards, out)
    macos(cards, out)
    windows(cards, out)
    linux(cards, out)
    web(cards, out)


if __name__ == "__main__":
    main()
