#!/bin/sh
# Packs the Linux release bundle into a .deb for the app described by
# devops/apps/<app>.env: the bundle goes to /opt/<name>, a <name> command to
# /usr/bin, and the menu entry and icons to /usr/share.
# Usage: devops/linux/build-deb.sh <version> <output.deb> [app]
set -eu

version="$1"
output="$2"
. "devops/apps/${3:-deberc}.env"
name="$APP_FILE_NAME"
id="$APP_PACKAGE_ID"
bundle=build/linux/x64/release/bundle
root=$(mktemp -d)
trap 'rm -rf "$root"' EXIT
# mktemp makes a private folder; the package root must be world-readable.
chmod 755 "$root"

mkdir -p "$root/opt/$name" "$root/usr/bin" "$root/usr/share/applications" "$root/DEBIAN"
cp -r "$bundle"/. "$root/opt/$name/"
ln -s "/opt/$name/$name" "$root/usr/bin/$name"

cat > "$root/usr/share/applications/$id.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Version=1.0
Name=$APP_NAME
Name[uk]=$APP_NAME_UK
GenericName=Score counter
GenericName[uk]=Лічильник очок
Comment=$APP_COMMENT
Comment[uk]=$APP_COMMENT_UK
Exec=$name
Icon=$id
Terminal=false
Categories=Game;CardGame;
Keywords=$APP_KEYWORDS
Keywords[uk]=$APP_KEYWORDS_UK
StartupWMClass=$id
DESKTOP

# The menu icon in every size the desktop may ask for.
for icon in devops/linux/icons/*.png; do
  size=$(basename "$icon" .png)
  dir="$root/usr/share/icons/hicolor/${size}x${size}/apps"
  mkdir -p "$dir"
  cp "$icon" "$dir/$id.png"
done

# Ubuntu 24.04 renamed the GTK library package, so either name satisfies it.
cat > "$root/DEBIAN/control" <<CONTROL
Package: $name
Version: $version
Section: games
Priority: optional
Architecture: amd64
Maintainer: Roman Lytvyn <litvin.roma@gmail.com>
Depends: libgtk-3-0 | libgtk-3-0t64, libc6
Installed-Size: $(du -sk "$root/opt" "$root/usr" | awk '{s += $1} END {print s}')
Homepage: $APP_WEBSITE
Description: $APP_SUMMARY
 $APP_DESCRIPTION
CONTROL

# Files in a package are owned by root whoever builds it.
dpkg-deb --build --root-owner-group "$root" "$output"
dpkg-deb --info "$output"