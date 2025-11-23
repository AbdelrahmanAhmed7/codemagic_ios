# MediConsult App

تطبيق MediConsult للتأمين الصحي .

## 🚀 الميزات الرئيسية

- **نظام مصادقة كامل** مع OTP
- **إدارة البوليسي** وتفاصيل التغطية
- **طلبات الموافقة المسبقة** والاسترداد
- **شبكة مقدمي الخدمة** مع الخرائط
- **إدارة أفراد العائلة**
- **نظام الإشعارات** مع Firebase
- **دعم العربية والإنجليزية**
- **العمل بدون إنترنت** مع نظام Cache متقدم

## 🔧 التقنيات المستخدمة

- **Flutter 3.9+** مع Dart 3.0+
- **BLoC Pattern** للـ State Management
- **Clean Architecture** مع Repository Pattern
- **Firebase** (Analytics, Crashlytics, Messaging)
- **GoRouter** للـ Navigation
- **Hive** للـ Local Database
- **Retrofit** للـ API Calls

## 📱 Firebase Integration

### Firebase Analytics
- تتبع أحداث المستخدم وسلوك التطبيق
- تسجيل تسجيل الدخول والتسجيل
- تتبع طلبات الموافقة والاسترداد
- تحليل استخدام الميزات

### Firebase Crashlytics
- تتبع الأخطاء والتحطم
- تسجيل أخطاء API والشبكة
- معلومات مفصلة عن الأخطاء
- تتبع أخطاء المصادقة

### Firebase Messaging
- إشعارات Push
- إشعارات محلية
- إدارة الـ Tokens

## 🛠️ إعداد المشروع

### المتطلبات
- Flutter SDK 3.9+
- Dart SDK 3.0+
- Android Studio / VS Code
- Firebase Project

### خطوات التثبيت

1. **استنساخ المشروع**
```bash
git clone [repository-url]
cd MCI-APP-Flutter
```

2. **تثبيت Dependencies**
```bash
flutter pub get
```

3. **إعداد Firebase**
```bash
# تثبيت Firebase CLI
npm install -g firebase-tools

# تسجيل الدخول
firebase login

# إعداد Firebase للمشروع
flutterfire configure
```

4. **تشغيل Code Generation**
```bash
flutter packages pub run build_runner build
```

5. **تشغيل التطبيق**
```bash
flutter run
```

## 📁 بنية المشروع

```
lib/
├── core/                    # الوظائف الأساسية
│   ├── cache/              # نظام الـ Cache
│   ├── constants/          # الثوابت
│   ├── di/                 # Dependency Injection
│   ├── network/            # إعدادات الشبكة
│   ├── routing/            # التنقل
│   ├── services/           # الخدمات (Firebase, etc.)
│   ├── theming/            # الألوان والخطوط
│   └── utils/              # الأدوات المساعدة
├── features/               # الميزات
│   ├── auth/               # المصادقة
│   ├── home/               # الصفحة الرئيسية
│   ├── policy/             # البوليسي
│   ├── approval_request/   # طلبات الموافقة
│   ├── refund/             # الاسترداد
│   ├── network/            # شبكة مقدمي الخدمة
│   ├── profile/            # الملف الشخصي
│   └── notifications/      # الإشعارات
└── shared/                 # المكونات المشتركة
```

## 🧪 الاختبارات

```bash
# تشغيل جميع الاختبارات
flutter test

# تشغيل اختبارات محددة
flutter test test/cubits/login_cubit_test.dart

# تقرير التغطية
flutter test --coverage
```

## 🔥 Firebase Services

### Analytics Events
- `login` - تسجيل الدخول
- `sign_up` - إنشاء حساب
- `approval_request_submitted` - طلب موافقة
- `refund_request_submitted` - طلب استرداد
- `provider_search` - البحث عن مقدمي الخدمة
- `policy_view` - عرض البوليسي
- `feature_usage` - استخدام الميزات

### Crashlytics Integration
- تسجيل أخطاء API
- أخطاء المصادقة
- أخطاء الشبكة
- أخطاء الـ Cache
- أخطاء الـ Navigation
- أخطاء الـ State Management

## 📊 المراقبة والتحليل

- **Firebase Analytics Dashboard** لتتبع المستخدمين
- **Firebase Crashlytics** لمراقبة الأخطاء
- **Performance Monitoring** لتحسين الأداء

## 🚀 النشر

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 المساهمة

1. Fork المشروع
2. إنشاء branch جديد (`git checkout -b feature/AmazingFeature`)
3. Commit التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. Push للـ branch (`git push origin feature/AmazingFeature`)
5. فتح Pull Request

## 📄 الترخيص

هذا المشروع مرخص تحت [MIT License](LICENSE).

## 📞 التواصل

للاستفسارات والدعم الفني، يرجى التواصل مع فريق التطوير.
