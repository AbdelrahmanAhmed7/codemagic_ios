# 📱 دليل رفع تطبيق MediConsult على Google Play Console

## ✅ الملفات الجاهزة

### 1. ملف التطبيق للرفع
- **المسار**: `build/app/outputs/bundle/release/app-release.aab`
- **الحجم**: 53 MB
- **النوع**: Android App Bundle (AAB) - الصيغة المطلوبة من Google Play

### 2. معلومات التوقيع الرقمي
- **Keystore**: `android/app/upload-keystore.jks`
- **Password**: `mediconsultUpload`
- **Key Alias**: `upload`
- ⚠️ **مهم جداً**: احتفظ بنسخة احتياطية من ملف `upload-keystore.jks` في مكان آمن!

### 3. معلومات التطبيق
- **اسم التطبيق**: MediConsult
- **Package Name**: com.mediconsulteg.mciapp
- **Version Code**: 1
- **Version Name**: 1.0.0

---

## 📋 المتطلبات للرفع على Google Play Console

### أولاً: إنشاء حساب Google Play Developer
1. اذهب إلى: https://play.google.com/console
2. سجل كمطور (رسوم لمرة واحدة: $25)
3. أكمل معلومات الحساب

### ثانياً: الأصول المطلوبة (Screenshots & Graphics)

#### 📱 لقطات الشاشة (Screenshots)
**مطلوب على الأقل 2 صورة لكل فئة:**

1. **Phone Screenshots** (مطلوب)
   - الحجم: 320px - 3840px (الطول أو العرض)
   - النسبة: 16:9 أو 9:16
   - الصيغة: PNG أو JPEG (24-bit)
   - العدد: 2-8 صور

2. **7-inch Tablet Screenshots** (اختياري)
   - نفس المواصفات

3. **10-inch Tablet Screenshots** (اختياري)
   - نفس المواصفات

#### 🎨 الرسومات (Graphics Assets)

1. **App Icon** (مطلوب)
   - الحجم: 512 x 512 px
   - الصيغة: PNG (32-bit)
   - ✅ موجود: `assets/logo/Logo.png` (يحتاج تعديل للحجم المطلوب)

2. **Feature Graphic** (مطلوب)
   - الحجم: 1024 x 500 px
   - الصيغة: PNG أو JPEG
   - ❌ غير موجود - يجب إنشاؤه

3. **Promo Video** (اختياري)
   - رابط YouTube

#### 📝 النصوص المطلوبة

1. **Short Description** (وصف قصير)
   - الحد الأقصى: 80 حرف
   - مثال: "تطبيق MediConsult للتأمين الصحي - إدارة شاملة للخدمات الطبية"

2. **Full Description** (وصف كامل)
   - الحد الأقصى: 4000 حرف
   - يجب أن يشمل:
     - ميزات التطبيق
     - كيفية الاستخدام
     - الفوائد للمستخدم

3. **App Category** (فئة التطبيق)
   - اختر: Medical أو Health & Fitness

4. **Content Rating** (تصنيف المحتوى)
   - ستحتاج ملء استبيان

5. **Privacy Policy** (سياسة الخصوصية)
   - رابط URL لسياسة الخصوصية (مطلوب)

---

## 🚀 خطوات الرفع

### المرحلة 1: إنشاء التطبيق
1. افتح Google Play Console
2. اضغط "Create app"
3. أدخل اسم التطبيق واللغة الافتراضية
4. اختر نوع التطبيق (App أو Game)
5. اختر مجاني أو مدفوع

### المرحلة 2: رفع الملف
1. اذهب إلى "Production" → "Create new release"
2. ارفع ملف `app-release.aab`
3. أضف Release notes (ملاحظات الإصدار)

### المرحلة 3: إكمال Store Listing
1. أضف لقطات الشاشة
2. أضف App icon و Feature graphic
3. اكتب الوصف القصير والكامل
4. اختر الفئة

### المرحلة 4: Content Rating
1. املأ استبيان تصنيف المحتوى
2. احصل على التصنيف

### المرحلة 5: Pricing & Distribution
1. اختر الدول المستهدفة
2. حدد السعر (مجاني/مدفوع)

### المرحلة 6: المراجعة والنشر
1. راجع جميع المعلومات
2. اضغط "Submit for review"
3. انتظر الموافقة (عادة 1-3 أيام)

---

## 🔄 للتحديثات المستقبلية

### عند إصدار تحديث جديد:

1. **تحديث رقم الإصدار** في `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2  # زود الرقم الأخير (version code)
   ```

2. **بناء النسخة الجديدة**:
   ```bash
   flutter clean
   flutter build appbundle --release
   ```

3. **رفع التحديث**:
   - اذهب إلى Google Play Console
   - Production → Create new release
   - ارفع ملف AAB الجديد
   - أضف Release notes (ما الجديد في هذا الإصدار)
   - Submit for review

### ملاحظات مهمة للتحديثات:
- ✅ استخدم نفس ملف keystore دائماً
- ✅ زود version code في كل تحديث
- ✅ يمكنك تغيير version name حسب رغبتك (مثلاً: 1.0.0 → 1.0.1 → 1.1.0)
- ⚠️ لا تفقد ملف keystore أبداً! بدونه لن تستطيع تحديث التطبيق

---

## 📦 ملفات يجب الاحتفاظ بها

### احفظ نسخة احتياطية من:
1. ✅ `android/app/upload-keystore.jks`
2. ✅ `android/key.properties`
3. ✅ معلومات الـ passwords

**مكان آمن مقترح**:
- Google Drive (مشفر)
- Password Manager
- خزنة محلية

---

## ⚠️ تحذيرات مهمة

1. **لا تشارك ملف keystore مع أحد**
2. **لا ترفع keystore على Git/GitHub**
3. **احتفظ بنسخ احتياطية متعددة**
4. **إذا فقدت keystore، لن تستطيع تحديث التطبيق أبداً!**

---

## 📞 روابط مفيدة

- [Google Play Console](https://play.google.com/console)
- [دليل رفع التطبيقات](https://support.google.com/googleplay/android-developer/answer/9859152)
- [متطلبات الأصول الرسومية](https://support.google.com/googleplay/android-developer/answer/9866151)
- [سياسات Google Play](https://play.google.com/about/developer-content-policy/)

---

## ✅ Checklist قبل الرفع

- [ ] ملف AAB جاهز ومُوقّع
- [ ] App icon (512x512)
- [ ] Feature graphic (1024x500)
- [ ] 2-8 لقطات شاشة للهاتف
- [ ] وصف قصير (80 حرف)
- [ ] وصف كامل (4000 حرف)
- [ ] سياسة الخصوصية (URL)
- [ ] اختيار الفئة
- [ ] تحديد الدول المستهدفة
- [ ] Content rating questionnaire
- [ ] نسخة احتياطية من keystore

---

**تم إنشاء هذا الدليل في**: 2025-11-20
**إصدار التطبيق**: 1.0.0+1
