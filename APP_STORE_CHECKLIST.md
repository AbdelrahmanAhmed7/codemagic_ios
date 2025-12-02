# 📱 App Store Submission Checklist

## ✅ 1. معلومات التطبيق الأساسية

### Bundle Identifier
- ✅ **Bundle ID**: `com.mediconsult.app`
- ✅ **Display Name**: `Mediconsult`
- ✅ **Version**: `1.0.0` (من pubspec.yaml)
- ✅ **Build Number**: `7` (من pubspec.yaml: version: 1.0.0+7)

### التحقق من Bundle ID في Xcode:
```bash
# في Xcode:
# Product → Scheme → Edit Scheme → Run → Build Configuration = Release
# ثم تحقق من:
# Target Runner → General → Bundle Identifier = com.mediconsult.app
```

---

## ✅ 2. App Icons (الأيقونات)

### المطلوب:
- ✅ **1024x1024** أيقونة للتسويق (AppIcon~ios-marketing.png)
- ✅ جميع الأحجام موجودة في `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- ✅ بدون شفافية (Alpha Channel)
- ✅ بدون نص أو علامات تجارية محمية

### التحقق:
```bash
# تأكد من وجود الأيقونة 1024x1024
ls -lh ios/Runner/Assets.xcassets/AppIcon.appiconset/AppIcon~ios-marketing.png
```

---

## ✅ 3. Launch Screen

- ✅ **LaunchScreen.storyboard** موجود في `ios/Runner/Base.lproj/`
- ✅ تم تكوينه في `Info.plist` → `UILaunchStoryboardName`

---

## ✅ 4. Info.plist - تم إصلاحه ✅

### الأذونات المطلوبة (موجودة):
- ✅ `NSCameraUsageDescription` - للكاميرا
- ✅ `NSPhotoLibraryUsageDescription` - للمعرض
- ✅ `NSPhotoLibraryAddUsageDescription` - لحفظ الصور
- ✅ `NSLocationWhenInUseUsageDescription` - للموقع

### الأذونات التي تم إزالتها (غير مستخدمة):
- ✅ `NSMicrophoneUsageDescription` - تمت الإزالة
- ✅ `NSContactsUsageDescription` - تمت الإزالة
- ✅ `NSCalendarsUsageDescription` - تمت الإزالة
- ✅ `NSRemindersUsageDescription` - تمت الإزالة
- ✅ `NSLocationAlwaysUsageDescription` - تمت الإزالة

### الأمان:
- ✅ `NSAllowsArbitraryLoads` - تمت الإزالة (مهم جداً!)
- ✅ `ITSAppUsesNonExemptEncryption` = `false` (HTTPS فقط)

---

## ✅ 5. Code Signing & Provisioning

### المطلوب:
1. **Apple Developer Account** (مدفوع - $99/سنة)
2. **App ID** في [developer.apple.com](https://developer.apple.com):
   - Bundle ID: `com.mediconsult.app`
   - Capabilities: Push Notifications, Background Modes
3. **Distribution Certificate**:
   - في Xcode: Xcode → Preferences → Accounts → Download Manual Profiles
   - أو من [developer.apple.com](https://developer.apple.com/account/resources/certificates/list)
4. **Provisioning Profile**:
   - App Store Distribution Profile
   - مرتبط بـ Bundle ID: `com.mediconsult.app`

### التحقق:
```bash
# في Xcode:
# Target Runner → Signing & Capabilities
# ✅ Automatically manage signing = ON
# ✅ Team = [Your Team]
# ✅ Bundle Identifier = com.mediconsult.app
```

---

## ✅ 6. Build للـ App Store

### الخطوات:

#### 1. تنظيف المشروع:
```bash
cd /Users/mac/StudioProjects/MCI-APP-Flutter
flutter clean
flutter pub get
cd ios
pod install
cd ..
```

#### 2. Build Archive:
```bash
# في Xcode:
# Product → Scheme → Edit Scheme → Archive
# ثم: Product → Archive
```

#### 3. أو باستخدام Flutter:
```bash
flutter build ipa --release
```

### التحقق من الـ Build:
- ✅ لا توجد أخطاء في الـ build
- ✅ Bundle ID صحيح
- ✅ Version & Build Number صحيحين
- ✅ Code Signing ناجح

---

## ✅ 7. App Store Connect Setup

### 1. إنشاء App Record:
- اذهب إلى [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
- My Apps → ➕ → New App
- **Platform**: iOS
- **Name**: MediConsult (أو الاسم المطلوب)
- **Primary Language**: Arabic / English
- **Bundle ID**: `com.mediconsult.app`
- **SKU**: `mediconsult-ios-001` (أي معرف فريد)

### 2. App Information:
- ✅ **Category**: Medical / Health & Fitness
- ✅ **Age Rating**: 4+ (أو حسب المحتوى)
- ✅ **Privacy Policy URL**: (مطلوب!)
- ✅ **Support URL**: (مطلوب!)

### 3. Pricing & Availability:
- ✅ حدد السعر (Free أو Paid)
- ✅ حدد البلدان المتاحة

### 4. App Store Listing:
- ✅ **App Name**: MediConsult (30 حرف كحد أقصى)
- ✅ **Subtitle**: (اختياري - 30 حرف)
- ✅ **Description**: (4000 حرف كحد أقصى)
- ✅ **Keywords**: (100 حرف كحد أقصى)
- ✅ **Promotional Text**: (اختياري - 170 حرف)
- ✅ **Support URL**: (مطلوب)
- ✅ **Marketing URL**: (اختياري)

### 5. Screenshots (مطلوب):
- ✅ **iPhone 6.7" Display** (iPhone 14 Pro Max, 15 Pro Max):
  - 1290 x 2796 pixels
  - على الأقل 1 screenshot
- ✅ **iPhone 6.5" Display** (iPhone 11 Pro Max, XS Max):
  - 1242 x 2688 pixels
  - على الأقل 1 screenshot
- ✅ **iPhone 5.5" Display** (iPhone 8 Plus):
  - 1242 x 2208 pixels
  - (اختياري)
- ✅ **iPad Pro 12.9"**:
  - 2048 x 2732 pixels
  - (إذا يدعم iPad)

### 6. App Preview (اختياري):
- فيديو قصير (15-30 ثانية) يوضح التطبيق

### 7. App Icon:
- ✅ **1024x1024** PNG بدون شفافية
- ✅ بدون نص أو علامات تجارية محمية

---

## ✅ 8. Upload إلى App Store Connect

### الطريقة 1: باستخدام Xcode (مُوصى به):
1. في Xcode: Window → Organizer
2. اختر الـ Archive
3. Distribute App
4. App Store Connect
5. Upload
6. اتبع الخطوات

### الطريقة 2: باستخدام Transporter:
1. حمّل [Transporter](https://apps.apple.com/us/app/transporter/id1450874784) من Mac App Store
2. افتح Transporter
3. اضغط ➕
4. اختر الـ `.ipa` file
5. Deliver

### الطريقة 3: باستخدام Command Line:
```bash
# بعد بناء الـ IPA:
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/mediconsult.ipa \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID
```

---

## ✅ 9. Test Information (اختياري - للـ TestFlight)

### TestFlight Beta Testing:
- ✅ **Internal Testing**: (حتى 100 tester)
- ✅ **External Testing**: (حتى 10,000 tester - يحتاج مراجعة)
- ✅ **Test Information**: 
  - What to Test
  - Feedback Email

---

## ✅ 10. Submit for Review

### قبل الرفع:
- ✅ اختبر التطبيق على أجهزة حقيقية
- ✅ تأكد من عدم وجود crashes
- ✅ تأكد من عمل جميع الميزات
- ✅ تأكد من وجود Privacy Policy URL
- ✅ تأكد من وجود Support URL

### عند الرفع:
1. في App Store Connect → App Information
2. Build: اختر الـ Build المرفوع
3. Version Information:
   - What's New in This Version
   - Screenshots
   - Description
4. Submit for Review

### معلومات إضافية للمراجعة:
- ✅ **Contact Information**: (مطلوب)
- ✅ **Demo Account**: (إذا كان التطبيق يتطلب تسجيل دخول)
- ✅ **Notes**: (أي معلومات إضافية للمراجعين)

---

## ⚠️ 11. Common Rejection Reasons (أسباب الرفض الشائعة)

### تجنب هذه المشاكل:
- ❌ **NSAllowsArbitraryLoads = true** → ✅ تمت الإزالة
- ❌ **أذونات غير مستخدمة** → ✅ تمت الإزالة
- ❌ **Privacy Policy مفقود** → ⚠️ تأكد من إضافته
- ❌ **Support URL مفقود** → ⚠️ تأكد من إضافته
- ❌ **App crashes** → ✅ اختبر قبل الرفع
- ❌ **محتوى طبي غير مرخص** → ⚠️ تأكد من المحتوى
- ❌ **أيقونة 1024x1024 مفقودة** → ✅ موجودة
- ❌ **Screenshots مفقودة** → ⚠️ أضف Screenshots

---

## 📝 12. Checklist النهائي قبل الرفع

- [ ] Bundle ID صحيح: `com.mediconsult.app`
- [ ] Version & Build Number محدثين
- [ ] App Icons موجودة (1024x1024)
- [ ] Launch Screen موجود
- [ ] Info.plist صحيح (لا NSAllowsArbitraryLoads)
- [ ] Code Signing ناجح
- [ ] Build ناجح بدون أخطاء
- [ ] Privacy Policy URL موجود
- [ ] Support URL موجود
- [ ] Screenshots مرفوعة
- [ ] App Description مكتمل
- [ ] Keywords محددة
- [ ] Age Rating محدد
- [ ] Category محدد
- [ ] Tested on real devices
- [ ] No crashes
- [ ] All features working

---

## 🚀 13. بعد الرفع

### Timeline:
- **Processing**: 1-2 ساعة
- **In Review**: 24-48 ساعة (عادة)
- **Pending Release**: بعد الموافقة
- **Released**: بعد النشر

### Monitoring:
- تابع الـ Status في App Store Connect
- تحقق من الـ Email للـ updates
- إذا تم الرفض، راجع الـ Resolution Center

---

## 📞 Support

إذا واجهت أي مشاكل:
1. راجع [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
2. راجع [App Store Connect Help](https://help.apple.com/app-store-connect/)
3. تواصل مع Apple Developer Support

---

**Good Luck! 🍀**


