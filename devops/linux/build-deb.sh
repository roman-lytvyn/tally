#!/bin/sh
# Packs the Linux release bundle into a .deb: the bundle goes to /opt/deberc,
# a `deberc` command to /usr/bin, and the menu entry and icons to /usr/share.
# Usage: devops/linux/build-deb.sh <version> <output.deb>
set -eu

version="$1"
output="$2"
bundle=build/linux/x64/release/bundle
root=$(mktemp -d)
trap 'rm -rf "$root"' EXIT
# mktemp makes a private folder; the package root must be world-readable.
chmod 755 "$root"

mkdir -p "$root/opt/deberc" "$root/usr/bin" "$root/usr/share/applications" "$root/DEBIAN"
cp -r "$bundle"/. "$root/opt/deberc/"
ln -s /opt/deberc/deberc "$root/usr/bin/deberc"
cp devops/linux/com.deberc.deberc.desktop "$root/usr/share/applications/"

# The launcher icon in the sizes Android already ships it in.
for pair in mdpi:48 hdpi:72 xhdpi:96 xxxhdpi:192; do
  density=${pair%%:*}
  size=${pair##*:}
  dir="$root/usr/share/icons/hicolor/${size}x${size}/apps"
  mkdir -p "$dir"
  cp "android/app/src/main/res/mipmap-$density/ic_launcher.png" "$dir/com.deberc.deberc.png"
done

# Ubuntu 24.04 renamed the GTK library package, so either name satisfies it.
cat > "$root/DEBIAN/control" <<CONTROL
Package: deberc
Version: $version
Section: games
Priority: optional
Architecture: amd64
Maintainer: Roman Lytvyn <litvin.roma@gmail.com>
Depends: libgtk-3-0 | libgtk-3-0t64, libc6
Installed-Size: $(du -sk "$root/opt" "$root/usr" | awk '{s += $1} END {print s}')
Homepage: https://git.lytvyn.org/games/deberc
Description: Deberc score counter
 Keeps the score of a game of deberc for two sides, three players or
 2 x 2 teams: points per deal, declarations, bait and the deal order.
CONTROL

# Files in a package are owned by root whoever builds it.
dpkg-deb --build --root-owner-group "$root" "$output"
dpkg-deb --info "$output"
