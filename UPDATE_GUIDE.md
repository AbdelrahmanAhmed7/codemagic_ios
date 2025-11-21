# 🔄 دليل التحديثات - MediConsult App

## 📱 كيفية إصدار تحديث جديد

### الخطوة 1: تحديث رقم الإصدار

افتح ملف `pubspec.yaml` وحدّث رقم الإصدار:

```yaml
version: 1.0.1+2  # الصيغة: version_name+version_code
```

**ملاحظات:**
- **Version Code** (الرقم بعد +): يجب أن يزيد بمقدار 1 في كل تحديث (1, 2, 3, 4...)
- **Version Name** (قبل +): يمكنك تغييره حسب نوع التحديث:
  - `1.0.1` - تحديث بسيط (bug fixes)
  - `1.1.0` - ميزات جديدة صغيرة
  - `2.0.0` - تحديث كبير

### الخطوة 2: تنظيف المشروع

```bash
flutter clean
```

### الخطوة 3: بناء النسخة الجديدة

**لبناء AAB (للرفع على Google Play):**
```bash
flutter build appbundle --release
```

**لبناء APK (للتوزيع المباشر):**
```bash
flutter build apk --release
```

### الخطوة 4: اختبار النسخة

قبل الرفع، تأكد من:
- ✅ التطبيق يعمل بدون أخطاء
- ✅ جميع الميزات الجديدة تعمل
- ✅ لا توجد مشاكل في الأداء

### الخطوة 5: رفع التحديث على Google Play

1. افتح [Google Play Console](https://play.google.com/console)
2. اختر تطبيق MediConsult
3. اذهب إلى **Production** → **Create new release**
4. ارفع ملف `build/app/outputs/bundle/release/app-release.aab`
5. أضف **Release notes** (ما الجديد):
   ```
   مثال:
   - إصلاح مشكلة في تسجيل الدخول
   - تحسين سرعة التطبيق
   - إضافة ميزة جديدة للإشعارات
   ```
6. اضغط **Review release**
7. اضغط **Start rollout to Production**

---

## 🏗️ أوامر Build مفيدة

### بناء للأجهزة المختلفة
```bash
# AAB - يدعم جميع الأجهزة (مستحسن)
flutter build appbundle --release

# APK - لجميع الأجهزة
flutter build apk --release

# APK - منفصل لكل معمارية (حجم أصغر)
flutter build apk --release --split-per-abi
```

### بناء مع معلومات إضافية
```bash
# مع verbose للمعلومات التفصيلية
flutter build appbundle --release --verbose

# مع obfuscation (حماية الكود)
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
```

---

## 📊 تتبع الإصدارات

| Version Code | Version Name | تاريخ الإصدار | الملاحظات |
|--------------|--------------|---------------|-----------|
| 1 | 1.0.0 | 2025-11-20 | الإصدار الأول |
| 2 | 1.0.1 | - | - |
| 3 | 1.0.2 | - | - |

---

## ⚠️ تحذيرات مهمة

### 🔐 الأمان
- ❌ **لا ترفع** ملف `upload-keystore.jks` على Git
- ❌ **لا ترفع** ملف `key.properties` على Git
- ✅ **احتفظ** بنسخة احتياطية من keystore في مكان آمن
- ✅ **استخدم** نفس keystore دائماً للتحديثات

### 📝 قبل كل تحديث
- [ ] تحديث version code
- [ ] اختبار التطبيق
- [ ] كتابة release notes
- [ ] مراجعة التغييرات

---

## 🐛 حل المشاكل الشائعة

### مشكلة: "Version code must be greater than previous version"
**الحل:** زود version code في `pubspec.yaml`

### مشكلة: "Upload failed: APK signature verification failed"
**الحل:** تأكد من استخدام نفس keystore المستخدم في الإصدار الأول

### مشكلة: Build failed
**الحل:**
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

---

## 📞 معلومات مهمة

**Keystore Info:**
- Location: `android/app/upload-keystore.jks`
- Alias: `upload`
- Password: `mediconsultUpload`

**App Info:**
- Package: `com.mediconsulteg.mciapp`
- Min SDK: 21 (Android 5.0)
- Target SDK: Latest

---

## 🎯 Checklist للتحديث

قبل رفع أي تحديث، تأكد من:

- [ ] تحديث version code في pubspec.yaml
- [ ] تشغيل `flutter clean`
- [ ] بناء AAB جديد
- [ ] اختبار التطبيق
- [ ] كتابة release notes بالعربية والإنجليزية
- [ ] رفع على Google Play Console
- [ ] تحديث جدول الإصدارات في هذا الملف

---

**آخر تحديث**: 2025-11-20
