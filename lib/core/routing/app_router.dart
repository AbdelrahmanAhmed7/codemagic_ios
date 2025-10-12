import 'package:go_router/go_router.dart';
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
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final phoneNumber = state.extra as String;
          return OtpScreen(phoneNumber: phoneNumber);
        },
      ),
    ],
  );
}