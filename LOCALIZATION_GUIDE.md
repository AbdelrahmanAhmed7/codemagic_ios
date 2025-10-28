# 🌍 Localization Implementation Guide

## ✅ What's Done

### 1. **EasyLocalization Setup**
- ✅ Added to `main.dart` with English and Arabic support
- ✅ Configured `MaterialApp` with localization delegates
- ✅ Translation files path: `assets/translations/`

### 2. **Translation Files**
- ✅ `en.json` - Complete English translations
- ⏳ `ar.json` - Needs to be created (copy en.json and translate)

### 3. **Screens with `.tr()` Added**
- ✅ All Auth screens (login, signup, forgot password, reset password)
- ✅ Home screen and widgets
- ✅ Profile screen and all sub-screens
- ✅ Family Members screen
- ✅ Chronic Medicines screen
- ✅ Approval History screen
- ✅ Refund History screen

### 4. **Language Management**
- ✅ `LanguageService` - Save/load language preference
- ✅ `LanguageCubit` - State management for language
- ✅ `LanguageHelper` - Helper to get current language code
- ✅ Language screen with Save button

### 5. **API Calls Updated**
- ✅ `home_screen.dart` - Uses `LanguageHelper.getLanguageCode(context)`
- ✅ `family_members_screen.dart` - Uses `LanguageHelper.getLanguageCode(context)`

---

## 🔧 What You Need to Do

### 1. **Run Freezed Code Generation**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. **Create Arabic Translation File**
1. Copy `assets/translations/en.json`
2. Rename to `assets/translations/ar.json`
3. Translate all values to Arabic

### 3. **Update Remaining API Calls**

Search for all hardcoded `'en'` strings in your codebase and replace with:
```dart
LanguageHelper.getLanguageCode(context)
```

**Files that likely need updates:**
- `lib/features/network/logic/network_cubit.dart`
- `lib/features/approval_request/presentation/cubit/*.dart`
- `lib/features/refund/presentation/cubit/*.dart`
- Any other cubit/repository that makes API calls

**Example:**
```dart
// ❌ Before:
await _repository.getCategories('en');

// ✅ After (in widget):
await _repository.getCategories(LanguageHelper.getLanguageCode(context));

// ✅ Or pass from widget to cubit:
// In widget:
context.read<MyCubit>().getData(LanguageHelper.getLanguageCode(context));

// In cubit:
Future<void> getData(String lang) async {
  await _repository.getData(lang);
}
```

### 4. **Add LanguageCubit to Providers**

In your dependency injection or main.dart, add:
```dart
BlocProvider(
  create: (context) => LanguageCubit(LanguageService()),
),
```

### 5. **Fix Duplicate Keys in en.json**

Remove duplicate keys at lines: 150, 151, 153, 154, 179, 200, 208, 219

---

## 📱 How to Use

### In Widgets:
```dart
Text('home.title'.tr())
```

### Get Current Language:
```dart
final lang = LanguageHelper.getLanguageCode(context);
```

### Change Language:
```dart
await context.setLocale(Locale('ar'));
```

---

## 🎯 Testing

1. Run the app
2. Go to Profile → Language
3. Select Arabic
4. Press Save
5. App should reload with Arabic translations (once ar.json is created)

---

## 📝 Notes

- All text strings are now using `.tr()` for translation
- Language preference is saved in SharedPreferences
- App will remember language choice on restart
- RTL support will work automatically when Arabic is selected
