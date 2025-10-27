# 🔧 Error Handling Implementation Guide

## 📋 Overview
دليل عملي لتطبيق الـ Error Handling في الـ app بشكل موحد.

---

## 🎯 الفكرة العامة

### **قبل:**
```dart
// Error تقني يظهر للمستخدم
emit(NetworkState.providersError("SocketException: Failed host lookup"));
```

### **بعد:**
```dart
// Error واضح وسهل الفهم
emit(NetworkState.providersError(error));
// في الـ UI
AppErrorHandler.getUserFriendlyMessage(error)
// Output: "No internet connection. Please check your network."
```

---

## 📁 الملفات المطلوبة

### 1. **Error Handler** ✅ (تم إنشاؤه)
```
lib/core/error/app_error_handler.dart
```

**Functions:**
- `getUserFriendlyMessage(String error)` - تحويل error تقني لـ user-friendly
- `showErrorSnackBar(context, error, {onRetry})` - عرض SnackBar
- `showErrorDialog(context, error, {onRetry})` - عرض Dialog
- `logError(error, {stackTrace})` - تسجيل الـ error

---

## 🔨 طرق الاستخدام

### **Method 1: في الـ Error State (Recommended)**

#### مثال: Home Screen
```dart
// في الـ BlocBuilder
failed: (message) => Center(
  child: Column(
    children: [
      Icon(Icons.error_outline),
      Text('An error occurred'),
      // استخدم AppErrorHandler هنا
      Text(
        AppErrorHandler.getUserFriendlyMessage(message),
        style: AppTextStyles.font14GreyRegular,
      ),
      ElevatedButton(
        onPressed: () => context.read<HomeCubit>().retry('en'),
        child: Text('Retry'),
      ),
    ],
  ),
),
```

### **Method 2: SnackBar للـ Errors البسيطة**

#### مثال: Network Screen
```dart
// في الـ BlocListener
BlocListener<NetworkCubit, NetworkState>(
  listener: (context, state) {
    state.maybeWhen(
      providersError: (message) {
        AppErrorHandler.showErrorSnackBar(
          context,
          message,
          onRetry: () {
            context.read<NetworkCubit>().searchProviders(resetPage: true);
          },
        );
      },
      orElse: () {},
    );
  },
  child: YourWidget(),
)
```

### **Method 3: Dialog للـ Critical Errors**

#### مثال: Login Screen
```dart
BlocListener<LoginCubit, LoginState>(
  listener: (context, state) {
    state.maybeWhen(
      error: (message) {
        AppErrorHandler.showErrorDialog(
          context,
          message,
          onRetry: () {
            // Retry login
          },
        );
      },
      orElse: () {},
    );
  },
  child: LoginForm(),
)
```

---

## 📝 أمثلة عملية

### **Example 1: Update Home Screen** ✅ (تم التطبيق)

```dart
// Before
Text(message) // "SocketException: Failed host lookup"

// After
Text(AppErrorHandler.getUserFriendlyMessage(message))
// "No internet connection. Please check your network."
```

### **Example 2: Update Network Screen**

```dart
// في network_screen.dart
import 'package:mediconsult/core/error/app_error_handler.dart';

// Add BlocListener
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: BlocListener<NetworkCubit, NetworkState>(
      listener: (context, state) {
        state.maybeWhen(
          providersError: (message) {
            // Log error for debugging
            AppErrorHandler.logError(message);
            
            // Show user-friendly message
            AppErrorHandler.showErrorSnackBar(
              context,
              message,
              onRetry: () {
                context.read<NetworkCubit>().searchProviders(resetPage: true);
              },
            );
          },
          orElse: () {},
        );
      },
      child: BlocBuilder<NetworkCubit, NetworkState>(
        // ... existing builder code
      ),
    ),
  );
}
```

### **Example 3: Update Policy Screen**

```dart
// في policy_details_screen.dart
// لو في API call في المستقبل

BlocListener<PolicyCubit, PolicyState>(
  listener: (context, state) {
    if (state is PolicyError) {
      AppErrorHandler.showErrorSnackBar(
        context,
        state.message,
        onRetry: () {
          context.read<PolicyCubit>().loadPolicyDetails();
        },
      );
    }
  },
  child: PolicyDetailsContent(),
)
```

---

## 🎨 Error Types & Messages

### **Network Errors:**
```dart
"SocketException" → "No internet connection. Please check your network."
"TimeoutException" → "Request timed out. Please try again."
```

### **HTTP Errors:**
```dart
"401" → "Session expired. Please login again."
"403" → "Access denied. You don't have permission."
"404" → "Resource not found."
"500/502/503" → "Server error. Please try again later."
```

### **Generic:**
```dart
Any other error → "Something went wrong. Please try again."
```

---

## 🔄 Migration Plan

### **Phase 1: Core Screens (Week 1)**
- [x] Create AppErrorHandler
- [x] Update HomeScreen ✅
- [ ] Update NetworkScreen
- [ ] Update ProfileScreen

### **Phase 2: Auth Screens (Week 2)**
- [ ] Update LoginScreen
- [ ] Update SignupScreen
- [ ] Update ResetPasswordScreen

### **Phase 3: Feature Screens (Week 3)**
- [ ] Update PolicyScreen
- [ ] Update NotificationsScreen
- [ ] Update ApprovalRequestScreen
- [ ] Update FamilyMembersScreen

---

## 🧪 Testing Error Handling

### **Test Cases:**

#### 1. No Internet
```dart
// Simulate no internet
// Expected: "No internet connection. Please check your network."
```

#### 2. Timeout
```dart
// Simulate timeout (slow network)
// Expected: "Request timed out. Please try again."
```

#### 3. Server Error
```dart
// Simulate 500 error
// Expected: "Server error. Please try again later."
```

#### 4. Unauthorized
```dart
// Simulate 401 error
// Expected: "Session expired. Please login again."
```

---

## 📊 Before & After Comparison

### **Before:**
```dart
// User sees technical error
failed: (message) => Text(message)
// Output: "SocketException: Failed host lookup: 'api.example.com'"
```

### **After:**
```dart
// User sees friendly message
failed: (message) => Text(
  AppErrorHandler.getUserFriendlyMessage(message)
)
// Output: "No internet connection. Please check your network."
```

---

## 🎯 Best Practices

### 1. **Always Log Errors**
```dart
AppErrorHandler.logError(error, stackTrace: stackTrace);
```

### 2. **Provide Retry Option**
```dart
AppErrorHandler.showErrorSnackBar(
  context,
  error,
  onRetry: () {
    // Retry logic
  },
);
```

### 3. **Use Appropriate UI**
```dart
// Minor errors → SnackBar
AppErrorHandler.showErrorSnackBar(context, error);

// Critical errors → Dialog
AppErrorHandler.showErrorDialog(context, error);

// Full screen errors → Error Widget
Text(AppErrorHandler.getUserFriendlyMessage(error))
```

### 4. **Don't Show Technical Details to Users**
```dart
❌ Text(error) // "SocketException: Failed host lookup"
✅ Text(AppErrorHandler.getUserFriendlyMessage(error)) // "No internet connection"
```

---

## 🚀 Quick Implementation Steps

### **For Any Screen:**

1. **Import the handler:**
```dart
import 'package:mediconsult/core/error/app_error_handler.dart';
```

2. **Update error display:**
```dart
// Replace
Text(message)

// With
Text(AppErrorHandler.getUserFriendlyMessage(message))
```

3. **Add retry option (optional):**
```dart
ElevatedButton(
  onPressed: () {
    // Your retry logic
  },
  child: Text('Retry'),
)
```

---

## 📈 Progress Tracking

### Screens Updated:
- [x] HomeScreen ✅
- [ ] NetworkScreen
- [ ] ProfileScreen
- [ ] PolicyScreen
- [ ] LoginScreen
- [ ] SignupScreen
- [ ] NotificationsScreen
- [ ] ApprovalRequestScreen

### Target: 100% coverage by end of Week 3

---

## 🔮 Future Enhancements

### 1. **Add Localization**
```dart
// After implementing localization
static String getUserFriendlyMessage(String error) {
  if (error.contains('SocketException')) {
    return 'errors.no_internet'.tr();
  }
  // ...
}
```

### 2. **Add Analytics**
```dart
static void logError(String error, {StackTrace? stackTrace}) {
  debugPrint('Error: $error');
  
  // Send to Firebase Analytics
  FirebaseAnalytics.instance.logEvent(
    name: 'error_occurred',
    parameters: {'error_message': error},
  );
  
  // Send to Crashlytics
  FirebaseCrashlytics.instance.recordError(error, stackTrace);
}
```

### 3. **Add Error Categories**
```dart
enum ErrorCategory {
  network,
  authentication,
  server,
  validation,
  unknown,
}

static ErrorCategory getErrorCategory(String error) {
  // Categorize errors
}
```

---

**Next Step:** Update NetworkScreen to use AppErrorHandler!
