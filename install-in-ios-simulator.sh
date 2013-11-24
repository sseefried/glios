#!/bin/bash

export IOSSIMDIR="$HOME/Library/Application Support/iPhone Simulator/7.0.3/Applications"

if [ $# -lt 1 ]; then
  echo "Usage: $(basename $0) <executable>"
  exit 1
fi

EXEC=$(basename $1)

FILE=$(find "$IOSSIMDIR" -name $EXEC)

if [ "$FILE" = "" ]; then
  INSTALLDIR="$IOSSIMDIR/$(uuidgen)/$EXEC.app"
else
 INSTALLDIR=$(dirname "$FILE")
fi

echo $INSTALLDIR
mkdir -p "$INSTALLDIR"
cp $EXEC "$INSTALLDIR"
cat <<END > "$INSTALLDIR/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>English</string>
	<key>CFBundleDisplayName</key>
	<string>$EXEC</string>
	<key>CFBundleExecutable</key>
	<string>$EXEC</string>
	<key>CFBundleIdentifier</key>
	<string>com.app.$EXEC</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>$EXEC</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleSupportedPlatforms</key>
	<array>
		<string>iPhoneSimulator</string>
	</array>
	<key>CFBundleVersion</key>
	<string>1.0</string>
	<key>DTPlatformName</key>
	<string>iphonesimulator</string>
	<key>DTSDKName</key>
	<string>iphonesimulator7.0</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>UIDeviceFamily</key>
	<array>
		<integer>1</integer>
	</array>
	<key>UIStatusBarHidden</key>
	<true/>
</dict>
</plist>

END

echo
echo "To view in iPhone Simulator:"
echo "  open -a \"iPhone Simulator\""
echo 
echo "Logs are in:"
echo "  tail -f ~/Library/Logs/iOS\ Simulator/7.0.3/system.log"

