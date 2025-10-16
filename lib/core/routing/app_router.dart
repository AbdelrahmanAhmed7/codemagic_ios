import 'package:go_router/go_router.dart';
import 'package:mediconsult/features/auth/login/presentation/forget_password_screen.dart';
import 'package:mediconsult/features/auth/login/presentation/login_screen.dart';
import 'package:mediconsult/features/auth/login/presentation/password_otp.dart';
import 'package:mediconsult/features/auth/login/presentation/reset_password_screen.dart';
import 'package:mediconsult/features/auth/signup/presentation/account_verified_screen.dart';
import 'package:mediconsult/features/auth/signup/presentation/otp_screen.dart';
import 'package:mediconsult/features/auth/signup/presentation/sign_up_screen.dart';
import 'package:mediconsult/features/chronic_medicines/screens/chronic_medicines_screen.dart';
import 'package:mediconsult/features/onboarding/onboarding_screen.dart';
import 'package:mediconsult/features/home/presentation/home_screen.dart';
import 'package:mediconsult/features/approval_request/presentation/approval_request_screen.dart';
import 'package:mediconsult/features/refund/refund_request_screen.dart';
import 'package:mediconsult/features/profile/presentation/profile_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/profile',
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
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/approval-request',
        builder: (context, state) {
          return const ApprovalRequestScreen();
        },
      ),
      GoRoute(
        path: '/approval-request/form',
        builder: (context, state) {
          return const ApprovalRequestScreen();
        },
      ),
      GoRoute(
        path: '/refund-request',
        builder: (context, state) {
          return const RefundRequestScreen();
        },
      ),
      GoRoute(
        path: '/chronic-medicines',
        builder: (context, state) {
          return const ChronicMedicinesScreen();
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),
    ],
  );
}