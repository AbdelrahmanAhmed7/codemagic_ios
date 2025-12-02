#!/bin/bash

# App Store Readiness Check Script
# هذا السكريبت يتحقق من جاهزية التطبيق للرفع على App Store

echo "🔍 Checking App Store Readiness..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track errors
ERRORS=0
WARNINGS=0

# Function to check file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅${NC} $2"
        return 0
    else
        echo -e "${RED}❌${NC} $2 - File not found: $1"
        ((ERRORS++))
        return 1
    fi
}

# Function to check directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✅${NC} $2"
        return 0
    else
        echo -e "${RED}❌${NC} $2 - Directory not found: $1"
        ((ERRORS++))
        return 1
    fi
}

# Function to check value in file
check_value() {
    if grep -q "$2" "$1" 2>/dev/null; then
        echo -e "${GREEN}✅${NC} $3"
        return 0
    else
        echo -e "${RED}❌${NC} $3 - Not found in $1"
        ((ERRORS++))
        return 1
    fi
}

# Function to check value NOT in file (checking actual keys, not comments)
check_not_value() {
    # Check for actual key tags, not comments
    if ! grep -E "<key>$2</key>" "$1" 2>/dev/null | grep -v "<!--" > /dev/null; then
        echo -e "${GREEN}✅${NC} $3"
        return 0
    else
        echo -e "${RED}❌${NC} $3 - Found in $1 (should be removed)"
        ((ERRORS++))
        return 1
    fi
}

echo "📱 1. Checking Basic Files..."
check_file "pubspec.yaml" "pubspec.yaml exists"
check_file "ios/Runner/Info.plist" "Info.plist exists"
check_file "ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json" "AppIcon Contents.json exists"
check_file "ios/Runner/Base.lproj/LaunchScreen.storyboard" "LaunchScreen.storyboard exists"

echo ""
echo "🔐 2. Checking Info.plist Security..."
if ! grep -E "<key>NSAllowsArbitraryLoads</key>" "ios/Runner/Info.plist" 2>/dev/null | grep -v "<!--" > /dev/null; then
    echo -e "${GREEN}✅${NC} NSAllowsArbitraryLoads removed (critical!)"
else
    echo -e "${RED}❌${NC} NSAllowsArbitraryLoads found (should be removed!)"
    ((ERRORS++))
fi
check_value "ios/Runner/Info.plist" "ITSAppUsesNonExemptEncryption" "ITSAppUsesNonExemptEncryption set"

echo ""
echo "📸 3. Checking Permissions..."
check_value "ios/Runner/Info.plist" "NSCameraUsageDescription" "Camera permission description"
check_value "ios/Runner/Info.plist" "NSPhotoLibraryUsageDescription" "Photo library permission description"
check_value "ios/Runner/Info.plist" "NSLocationWhenInUseUsageDescription" "Location permission description"
# Check for actual key tags, not comments
if ! grep -E "<key>NSMicrophoneUsageDescription</key>" "ios/Runner/Info.plist" 2>/dev/null | grep -v "<!--" > /dev/null; then
    echo -e "${GREEN}✅${NC} Microphone permission removed (not used)"
else
    echo -e "${RED}❌${NC} Microphone permission found (should be removed)"
    ((ERRORS++))
fi
if ! grep -E "<key>NSContactsUsageDescription</key>" "ios/Runner/Info.plist" 2>/dev/null | grep -v "<!--" > /dev/null; then
    echo -e "${GREEN}✅${NC} Contacts permission removed (not used)"
else
    echo -e "${RED}❌${NC} Contacts permission found (should be removed)"
    ((ERRORS++))
fi
if ! grep -E "<key>NSCalendarsUsageDescription</key>" "ios/Runner/Info.plist" 2>/dev/null | grep -v "<!--" > /dev/null; then
    echo -e "${GREEN}✅${NC} Calendar permission removed (not used)"
else
    echo -e "${RED}❌${NC} Calendar permission found (should be removed)"
    ((ERRORS++))
fi
if ! grep -E "<key>NSRemindersUsageDescription</key>" "ios/Runner/Info.plist" 2>/dev/null | grep -v "<!--" > /dev/null; then
    echo -e "${GREEN}✅${NC} Reminders permission removed (not used)"
else
    echo -e "${RED}❌${NC} Reminders permission found (should be removed)"
    ((ERRORS++))
fi

echo ""
echo "🆔 4. Checking Bundle Identifier..."
check_value "ios/Runner.xcodeproj/project.pbxproj" "PRODUCT_BUNDLE_IDENTIFIER = com.mediconsult.app" "Bundle ID is com.mediconsult.app"

echo ""
echo "📦 5. Checking App Icons..."
check_file "ios/Runner/Assets.xcassets/AppIcon.appiconset/AppIcon~ios-marketing.png" "1024x1024 Marketing Icon"
check_file "ios/Runner/Assets.xcassets/AppIcon.appiconset/AppIcon@2x.png" "iPhone App Icon @2x"
check_file "ios/Runner/Assets.xcassets/AppIcon.appiconset/AppIcon@3x.png" "iPhone App Icon @3x"

# Check icon sizes
if [ -f "ios/Runner/Assets.xcassets/AppIcon.appiconset/AppIcon~ios-marketing.png" ]; then
    SIZE=$(sips -g pixelWidth -g pixelHeight "ios/Runner/Assets.xcassets/AppIcon.appiconset/AppIcon~ios-marketing.png" 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | head -1)
    if [ "$SIZE" = "1024" ]; then
        echo -e "${GREEN}✅${NC} Marketing icon is 1024x1024"
    else
        echo -e "${YELLOW}⚠️${NC} Marketing icon size: ${SIZE}x${SIZE} (should be 1024x1024)"
        ((WARNINGS++))
    fi
fi

echo ""
echo "📋 6. Checking Version Info..."
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
BUILD=$(grep "^version:" pubspec.yaml | sed 's/.*+//')
echo -e "${GREEN}✅${NC} Version: $VERSION"
echo -e "${GREEN}✅${NC} Build: $BUILD"

echo ""
echo "🔧 7. Checking Flutter Setup..."
if command -v flutter &> /dev/null; then
    echo -e "${GREEN}✅${NC} Flutter is installed"
    FLUTTER_VERSION=$(flutter --version | head -1)
    echo "   $FLUTTER_VERSION"
else
    echo -e "${RED}❌${NC} Flutter is not installed or not in PATH"
    ((ERRORS++))
fi

echo ""
echo "📊 Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All critical checks passed!${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠️  $WARNINGS warning(s) found${NC}"
    fi
    echo ""
    echo "🚀 Your app is ready for App Store submission!"
    echo ""
    echo "Next steps:"
    echo "1. Build the app: flutter build ipa --release"
    echo "2. Open Xcode: open ios/Runner.xcworkspace"
    echo "3. Archive: Product → Archive"
    echo "4. Distribute: Window → Organizer → Distribute App"
    exit 0
else
    echo -e "${RED}❌ $ERRORS error(s) found${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠️  $WARNINGS warning(s) found${NC}"
    fi
    echo ""
    echo "Please fix the errors before submitting to App Store."
    exit 1
fi

