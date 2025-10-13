import 'package:go_router/go_router.dart';
import 'package:mediconsult/features/auth/login/presentation/forget_password_screen.dart';
import 'package:mediconsult/features/auth/login/presentation/login_screen.dart';
import 'package:mediconsult/features/auth/login/presentation/password_otp.dart';
import 'package:mediconsult/features/auth/login/presentation/reset_password_screen.dart';
import 'package:mediconsult/features/auth/signup/presentation/account_verified_screen.dart';
import 'package:mediconsult/features/auth/signup/presentation/otp_screen.dart';
import 'package:mediconsult/features/auth/signup/presentation/sign_up_screen.dart';
import 'package:mediconsult/features/onboarding/onboarding_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const OnboardingScreen();
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          return const SignUpScreen();
        },
      ),
      GoRoute(path: '/login', builder: (context, state) {
        return const LoginScreen();
      }),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final phoneNumber = state.extra as String;
          return OtpScreen(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: '/account-verified',
        builder: (context, state) {
          return const AccountVerifiedScreen();
        },
      ),
      GoRoute(
        path: '/forget-password',
        builder: (context, state) {
          return const ForgetPasswordScreen();
        },
      ),
      GoRoute(
        path: '/otp-password',
        builder: (context, state) {
          final phoneNumber = state.extra as String;
          return PasswordOtpScreen(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          return const ResetPasswordScreen();
        },
      ),
    ],
  );
}