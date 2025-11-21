# 🌍 Localization Implementation Plan

## 📋 Overview
خطة شاملة لإضافة الـ Localization للـ app لدعم اللغة العربية والإنجليزية.

## 🎯 Goals
- ✅ دعم العربية والإنجليزية
- ✅ RTL/LTR support
- ✅ Easy switching between languages
- ✅ Persistent language preference

## 📦 Required Packages

### Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
  easy_localization: ^3.0.7
```

## 🗂️ Project Structure

```
lib/
├── core/
│   └── localization/
│       ├── app_localizations.dart
│       └── locale_keys.dart (generated)
├── assets/
│   └── translations/
│       ├── ar.json
│       └── en.json
```

## 📝 Step-by-Step Implementation

### Step 1: Install Package
```bash
flutter pub add easy_localization
flutter pub add intl
```

### Step 2: Create Translation Files

#### `assets/translations/en.json`
```json
{
  "app_name": "MediConsult",
  "home": {
    "title": "Home",
    "welcome": "Welcome",
    "quick_access": "Quick Access",
    "ongoing_requests": "Ongoing Requests",
    "health_tips": "Health Tips",
    "explore": "Explore"
  },
  "network": {
    "title": "Providers Network",
    "search_placeholder": "Search providers...",
    "categories": "Categories",
    "no_results": "No providers found",
    "load_more": "Loading more..."
  },
  "policy": {
    "title": "Policy",
    "services": "Services",
    "policy_details": "Policy Details",
    "coverage": "Coverage",
    "providers": "Providers",
    "see_all": "See all",
    "search": "Search"
  },
  "profile": {
    "title": "Profile",
    "member_id": "Member ID",
    "edit_profile": "Edit Profile",
    "change_password": "Change Password",
    "language": "Language",
    "logout": "Logout"
  },
  "common": {
    "loading": "Loading...",
    "error": "An error occurred",
    "retry": "Retry",
    "cancel": "Cancel",
    "save": "Save",
    "ok": "OK",
    "yes": "Yes",
    "no": "No"
  },
  "errors": {
    "network_error": "Network connection error",
    "server_error": "Server error, please try again",
    "no_internet": "No internet connection",
    "unknown_error": "Unknown error occurred"
  }
}
```

#### `assets/translations/ar.json`
```json
{
  "app_name": "ميديكونسلت",
  "home": {
    "title": "الرئيسية",
    "welcome": "مرحباً",
    "quick_access": "الوصول السريع",
    "ongoing_requests": "الطلبات الجارية",
    "health_tips": "نصائح صحية",
    "explore": "استكشف"
  },
  "network": {
    "title": "شبكة مقدمي الخدمة",
    "search_placeholder": "ابحث عن مقدمي الخدمة...",
    "categories": "الفئات",
    "no_results": "لم يتم العثور على مقدمي خدمة",
    "load_more": "جاري التحميل..."
  },
  "policy": {
    "title": "البوليصة",
    "services": "الخدمات",
    "policy_details": "تفاصيل البوليصة",
    "coverage": "التغطية",
    "providers": "مقدمو الخدمة",
    "see_all": "عرض الكل",
    "search": "بحث"
  },
  "profile": {
    "title": "الملف الشخصي",
    "member_id": "رقم العضوية",
    "edit_profile": "تعديل الملف الشخصي",
    "change_password": "تغيير كلمة المرور",
    "language": "اللغة",
    "logout": "تسجيل الخروج"
  },
  "common": {
    "loading": "جاري التحميل...",
    "error": "حدث خطأ",
    "retry": "إعادة المحاولة",
    "cancel": "إلغاء",
    "save": "حفظ",
    "ok": "موافق",
    "yes": "نعم",
    "no": "لا"
  },
  "errors": {
    "network_error": "خطأ في الاتصال بالشبكة",
    "server_error": "خطأ في الخادم، يرجى المحاولة مرة أخرى",
    "no_internet": "لا يوجد اتصال بالإنترنت",
    "unknown_error": "حدث خطأ غير معروف"
  }
}
```

### Step 3: Update `pubspec.yaml`
```yaml
flutter:
  assets:
    - assets/logo/
    - assets/translations/  # Add this
```

### Step 4: Update `main.dart`
```dart
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar'), // Default to Arabic
      child: const MediConsultApp(),
    ),
  );
}
```

### Step 5: Update `MediConsultApp`
```dart
class MediConsultApp extends StatelessWidget {
  const MediConsultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp.router(
        title: 'app_name'.tr(), // Use translation
        debugShowCheckedModeBanner: false,
        
        // Localization delegates
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        
        theme: ThemeData(
          primaryColor: AppColors.primaryClr,
          scaffoldBackgroundColor: AppColors.lightGreyClr,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
```

### Step 6: Create Language Switcher Widget
```dart
// lib/shared/widgets/language_switcher.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: context.locale,
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: Locale('ar'),
          child: Text('العربية'),
        ),
      ],
      onChanged: (locale) {
        if (locale != null) {
          context.setLocale(locale);
        }
      },
    );
  }
}
```

### Step 7: Update Existing Screens

#### Before:
```dart
Text('Providers Network')
```

#### After:
```dart
Text('network.title'.tr())
```

#### Example for PageHeader:
```dart
// Before
const PageHeader(title: 'Policy', backPath: '/home')

// After
PageHeader(title: 'policy.title'.tr(), backPath: '/home')
```

## 🔄 Migration Strategy

### Phase 1: Core Strings (Week 1)
- [ ] Common strings (loading, error, retry, etc.)
- [ ] Navigation labels
- [ ] Button texts

### Phase 2: Feature Screens (Week 2)
- [ ] Home screen
- [ ] Profile screen
- [ ] Network screen
- [ ] Policy screen

### Phase 3: Forms & Validation (Week 3)
- [ ] Login/Signup forms
- [ ] Validation messages
- [ ] Error messages

### Phase 4: API Integration (Week 4)
- [ ] Update API calls to use locale parameter
- [ ] Handle server-side translations
- [ ] Fallback to client-side translations

## 📱 RTL Support

### Update Theme:
```dart
MaterialApp.router(
  // ... other properties
  builder: (context, child) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar' 
        ? TextDirection.rtl 
        : TextDirection.ltr,
      child: child!,
    );
  },
)
```

### Update Widgets for RTL:
```dart
// Use EdgeInsetsDirectional instead of EdgeInsets
EdgeInsetsDirectional.only(start: 16.w, end: 16.w)

// Use Alignment.centerStart instead of Alignment.centerLeft
Alignment.centerStart
```

## 🧪 Testing Localization

### Test Cases:
```dart
testWidgets('should display Arabic text', (tester) async {
  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: [Locale('ar')],
      path: 'assets/translations',
      child: MyApp(),
    ),
  );
  
  expect(find.text('الرئيسية'), findsOneWidget);
});
```

## 📊 Progress Tracking

### Screens to Update:
- [ ] OnboardingScreen
- [ ] LoginScreen
- [ ] SignupScreen
- [ ] HomeScreen
- [ ] ProfileScreen
- [ ] NetworkScreen
- [ ] PolicyScreen
- [ ] PolicyDetailsScreen
- [ ] NotificationsScreen
- [ ] ApprovalRequestScreen
- [ ] FamilyMembersScreen
- [ ] RefundsScreen

### Widgets to Update:
- [ ] PageHeader
- [ ] BottomNavigationBar
- [ ] ServiceCard
- [ ] PharmacyCard
- [ ] ProviderCard
- [ ] QuickAccessWidget
- [ ] ExploreWidget

## 🎯 Best Practices

1. **Use Translation Keys**: Always use keys, never hardcoded strings
   ```dart
   ✅ 'home.title'.tr()
   ❌ 'Home'
   ```

2. **Organize Keys Hierarchically**: Group related translations
   ```json
   {
     "home": {
       "title": "Home",
       "subtitle": "Welcome"
     }
   }
   ```

3. **Handle Plurals**:
   ```dart
   'items_count'.plural(count)
   ```

4. **Handle Parameters**:
   ```dart
   'welcome_message'.tr(args: [userName])
   ```

5. **Persist Language Choice**:
   ```dart
   await SharedPreferences.getInstance()
     .then((prefs) => prefs.setString('locale', locale.languageCode));
   ```

## 🚀 Quick Start Commands

```bash
# 1. Add packages
flutter pub add easy_localization intl

# 2. Create translation files
mkdir -p assets/translations
touch assets/translations/en.json
touch assets/translations/ar.json

# 3. Update pubspec.yaml
# Add assets/translations/ to assets

# 4. Run app
flutter run
```

## 📚 Resources

- [Easy Localization Docs](https://pub.dev/packages/easy_localization)
- [Flutter Internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [RTL Support Guide](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#rtl-support)

---

**Estimated Time:** 2-3 weeks for full implementation
**Priority:** High
**Complexity:** Medium
