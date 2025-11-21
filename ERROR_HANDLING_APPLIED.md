# ✅ Error Handling Applied to All Screens

## 📊 Progress Summary

### ✅ Completed:
1. **HomeScreen** - Using `AppErrorHandler.getUserFriendlyMessage()` in error widget
2. **NetworkScreen** - Using `AppErrorHandler.showErrorSnackBar()` with BlocListener

### 🔄 Remaining Screens:

---

## 📝 Implementation Pattern

### **Pattern 1: Full Screen Error (like HomeScreen)**
```dart
failed: (message) => Center(
  child: Column(
    children: [
      Icon(Icons.error_outline),
      Text('Error occurred'),
      Text(AppErrorHandler.getUserFriendlyMessage(message)),
      ElevatedButton(
        onPressed: () => retry(),
        child: Text('Retry'),
      ),
    ],
  ),
)
```

### **Pattern 2: SnackBar Error (like NetworkScreen)**
```dart
BlocListener<YourCubit, YourState>(
  listener: (context, state) {
    if (state is ErrorState) {
      AppErrorHandler.showErrorSnackBar(
        context,
        state.error, // or state.message depending on state definition
        onRetry: () => context.read<YourCubit>().retry(),
      );
    }
  },
  child: YourWidget(),
)
```

---

## 🎯 Screens to Update

### 1. **Profile Screen** ⏳
**File:** `lib/features/profile/presentation/profile_screen.dart`
**Current:** Shows technical error in failed state
**Action:** Use `AppErrorHandler.getUserFriendlyMessage(message)`

### 2. **Notifications Screen** ⏳
**File:** `lib/features/notifications/presentation/notifications_screen.dart`
**State:** `NotificationsState.failed(String message)`
**Action:** Add BlocListener with `showErrorSnackBar`

### 3. **Approval Request Screen** ⏳
**File:** `lib/features/approval_request/presentation/screens/approval_request_screen.dart`
**Action:** Add error handling

### 4. **Refunds Screen** ⏳
**File:** `lib/features/refund/presentation/screens/refunds_history_screen.dart`
**Current:** Line 87-90 shows raw message
**Action:** Use `AppErrorHandler.getUserFriendlyMessage(message)`

### 5. **Login Screen** ⏳
**File:** `lib/features/auth/login/presentation/screens/login_screen.dart`
**Action:** Add BlocListener with error dialog

### 6. **Signup Screen** ⏳
**File:** `lib/features/auth/signup/presentation/screens/signup_screen.dart`
**Action:** Add BlocListener with error dialog

### 7. **Family Members Screen** ⏳
**File:** `lib/features/family_members/presentation/screens/family_members_screen.dart`
**Action:** Add error handling

---

## 🚀 Quick Update Commands

### For each screen, follow these steps:

#### Step 1: Add Import
```dart
import 'package:mediconsult/core/error/app_error_handler.dart';
```

#### Step 2: Update Error Display
Replace raw error text with:
```dart
AppErrorHandler.getUserFriendlyMessage(message)
```

#### Step 3: Add Retry (if not exists)
```dart
ElevatedButton(
  onPressed: () => cubit.retry(),
  child: Text('Retry'),
)
```

---

## 📋 Detailed Updates

### **Profile Screen Update:**
```dart
// In lib/features/profile/presentation/profile_screen.dart

// Add import
import 'package:mediconsult/core/error/app_error_handler.dart';

// Update failed state (around line 128)
failed: (message) {
  return Row(
    children: [
      Container(
        // ... existing shimmer code
      ),
      // Update error text
      Text(
        AppErrorHandler.getUserFriendlyMessage(message),
        style: AppTextStyles.font14GreyRegular,
      ),
    ],
  );
}
```

### **Refunds Screen Update:**
```dart
// In lib/features/refund/presentation/screens/refunds_history_screen.dart

// Add import
import 'package:mediconsult/core/error/app_error_handler.dart';

// Update failed state (around line 87)
failed: (message) => Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.error_outline, size: 64, color: AppColors.errorClr),
      SizedBox(height: 16),
      Text(
        AppErrorHandler.getUserFriendlyMessage(message),
        style: AppTextStyles.font14GreyRegular,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 16),
      ElevatedButton(
        onPressed: () {
          // Add retry logic
          context.read<RefundsCubit>().getRefunds();
        },
        child: Text('Retry'),
      ),
    ],
  ),
)
```

### **Notifications Screen Update:**
```dart
// In lib/features/notifications/presentation/notifications_screen.dart

// Add import
import 'package:mediconsult/core/error/app_error_handler.dart';

// Wrap body with BlocListener
body: BlocListener<NotificationsCubit, NotificationsState>(
  listener: (context, state) {
    if (state is Failed) {
      AppErrorHandler.showErrorSnackBar(
        context,
        state.message,
        onRetry: () {
          context.read<NotificationsCubit>().getNotifications();
        },
      );
    }
  },
  child: SafeArea(
    // ... existing body code
  ),
)
```

### **Login Screen Update:**
```dart
// In lib/features/auth/login/presentation/screens/login_screen.dart

// Add import
import 'package:mediconsult/core/error/app_error_handler.dart';

// Add BlocListener
BlocListener<LoginCubit, LoginState>(
  listener: (context, state) {
    state.maybeWhen(
      error: (message) {
        AppErrorHandler.showErrorDialog(
          context,
          message,
          onRetry: () {
            // Retry login with saved credentials
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

## 🧪 Testing Checklist

After updating each screen, test:

- [ ] No internet error → Shows "No internet connection"
- [ ] Timeout error → Shows "Request timed out"
- [ ] 401 error → Shows "Session expired"
- [ ] 500 error → Shows "Server error"
- [ ] Retry button works
- [ ] Error disappears after successful retry

---

## 📈 Implementation Progress

| Screen | Status | Pattern | Notes |
|--------|--------|---------|-------|
| HomeScreen | ✅ Done | Full Screen | Using getUserFriendlyMessage |
| NetworkScreen | ✅ Done | SnackBar | Using showErrorSnackBar |
| ProfileScreen | ⏳ Pending | Full Screen | Line 128 |
| RefundsScreen | ⏳ Pending | Full Screen | Line 87 |
| NotificationsScreen | ⏳ Pending | SnackBar | Add BlocListener |
| LoginScreen | ⏳ Pending | Dialog | Add BlocListener |
| SignupScreen | ⏳ Pending | Dialog | Add BlocListener |
| ApprovalRequestScreen | ⏳ Pending | SnackBar | Add BlocListener |
| FamilyMembersScreen | ⏳ Pending | SnackBar | Add BlocListener |

---

## 🎯 Next Steps

1. Update Profile Screen (5 min)
2. Update Refunds Screen (5 min)
3. Update Notifications Screen (10 min)
4. Update Auth Screens (15 min)
5. Update remaining screens (20 min)

**Total Estimated Time:** ~1 hour

---

## ✅ Benefits After Implementation

1. **User-Friendly** - Clear error messages
2. **Consistent** - Same error handling everywhere
3. **Actionable** - Retry buttons for all errors
4. **Maintainable** - Centralized error logic
5. **Debuggable** - Errors logged for debugging

---

**Status:** 2/9 screens completed (22%)
**Target:** 100% by end of day
