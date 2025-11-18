import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/constants.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approvals_cubit.dart';
import 'package:mediconsult/features/approval_request/presentation/approval_history_screen.dart';
import 'package:mediconsult/features/auth/login/presentation/forget_password_screen.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/login_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/resend_otp_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/reset_password_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/send_otp_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/verify_otp_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/login_screen.dart';
import 'package:mediconsult/features/auth/login/presentation/password_otp.dart';
import 'package:mediconsult/features/auth/login/presentation/reset_password_screen.dart';
import 'package:mediconsult/features/auth/signup/presentation/account_verified_screen.dart';
import 'package:mediconsult/features/auth/signup/presentation/logic/signup_cubit.dart';
import 'package:mediconsult/features/auth/signup/presentation/sign_up_screen.dart';
import 'package:mediconsult/features/chronic_medicines/screens/chronic_medicines_screen.dart';
import 'package:mediconsult/features/family_members/presentation/cubit/family_members_cubit.dart';
import 'package:mediconsult/features/family_members/presentation/family_members_screen.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approval_request_cubit.dart';
import 'package:mediconsult/features/onboarding/onboarding_screen.dart';
import 'package:mediconsult/features/home/presentation/home_screen.dart';
import 'package:mediconsult/features/approval_request/presentation/approval_request_screen.dart';
import 'package:mediconsult/features/profile/presentation/cubit/change_password_cubit.dart';
import 'package:mediconsult/features/profile/presentation/cubit/language_cubit.dart';
import 'package:mediconsult/features/profile/presentation/cubit/personal_info_cubit.dart';
import 'package:mediconsult/features/profile/presentation/screens/add_family_member_screen.dart';
import 'package:mediconsult/features/profile/presentation/screens/contact_us_screen.dart';
import 'package:mediconsult/features/profile/presentation/screens/faq_screen.dart';
import 'package:mediconsult/features/profile/presentation/screens/insurance_plan_screen.dart';
import 'package:mediconsult/features/profile/presentation/screens/personal_info_screen.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refund_reasons_cubit.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refund_request_cubit.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refund_types_cubit.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refunds_cubit.dart';
import 'package:mediconsult/features/refund/presentation/screens/refund_request_screen.dart';
import 'package:mediconsult/features/profile/presentation/profile_screen.dart';
import 'package:mediconsult/features/chat/presentation/screens/chat_screen.dart';
import 'package:mediconsult/features/refund/presentation/screens/refunds_history_screen.dart';
import 'package:mediconsult/features/support/presentation/cubit/contact_cubit.dart';
import 'package:mediconsult/features/support/presentation/cubit/faq_cubit.dart';
import 'package:mediconsult/features/terms_policy/presentation/cubit/terms_cubit.dart';
import 'package:mediconsult/features/terms_policy/presentation/screens/terms_policy_screen.dart';
import 'package:mediconsult/features/profile/presentation/screens/change_password_screen.dart';
import 'package:mediconsult/features/profile/presentation/screens/language_screen.dart';
import 'package:mediconsult/features/notifications/presentation/notifications_screen.dart';
import 'package:mediconsult/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:mediconsult/features/network/presentation/network_screen.dart';
import 'package:mediconsult/features/network/logic/network_cubit.dart';
import 'package:mediconsult/features/policy/presentation/policy_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: shouldShowOnboarding
        ? '/'
        : (isLoggedInUser ? '/home' : '/login'),
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
          return BlocProvider(
            create: (context) => sl<SignupCubit>(),
            child: const SignUpScreen(),
          );
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<LoginCubit>(),
            child: const LoginScreen(),
          );
        },
      ),
      // GoRoute(
      //   path: '/otp',
      //   builder: (context, state) {
      //     final phoneNumber = state.extra as String;
      //     return OtpScreen(phoneNumber: phoneNumber);
      //   },
      // ),
      GoRoute(
        path: '/account-verified',
        builder: (context, state) {
          return const AccountVerifiedScreen();
        },
      ),
      GoRoute(
        path: '/forget-password',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<SendOtpCubit>(),
            child: const ForgetPasswordScreen(),
          );
        },
      ),
      GoRoute(
        path: '/otp-password',
        builder: (context, state) {
          final phoneNumber = state.extra as String;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<VerifyOtpCubit>()),
              BlocProvider(create: (context) => sl<ResendOtpCubit>()),
            ],
            child: PasswordOtpScreen(phoneNumber: phoneNumber),
          );
        },
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final phoneNumber = state.extra as String;
          return BlocProvider(
            create: (context) => sl<ResetPasswordCubit>(),
            child: ResetPasswordScreen(phoneNumber: phoneNumber),
          );
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<HomeCubit>(),
            child: const HomeScreen(),
          );
        },
      ),
      GoRoute(
        path: '/approval-history',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<ApprovalsCubit>(),
            child: const ApprovalHistoryScreen(),
          );
        },
      ),
      GoRoute(
        path: '/approval-request',
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<FamilyMembersCubit>()),
              BlocProvider(create: (context) => sl<ApprovalRequestCubit>()),
            ],
            child: const ApprovalRequestScreen(),
          );
        },
      ),
      GoRoute(
        path: '/refund-request',
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<RefundRequestCubit>()),
              BlocProvider(create: (context) => sl<RefundTypesCubit>()),
              BlocProvider(create: (context) => sl<RefundReasonsCubit>()),
              BlocProvider(create: (context) => sl<FamilyMembersCubit>()),
            ],
            child: const RefundRequestScreen(),
          );
        },
      ),
      GoRoute(
        path: '/refund-history',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<RefundsCubit>(),
            child: const RefundHistoryScreen(),
          );
        },
      ),
      GoRoute(
        path: '/chronic-medicines',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<FamilyMembersCubit>(),
            child: const ChronicMedicinesScreen(),
          );
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<HomeCubit>(),
            child: const ProfileScreen(),
          );
        },
      ),
      GoRoute(
        path: '/personal-information',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<PersonalInfoCubit>(),
            child: const PersonalInformationScreen(),
          );
        },
      ),
      GoRoute(
        path: '/family-members',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<FamilyMembersCubit>(),
            child: const FamilyMembersScreen(),
          );
        },
      ),
      GoRoute(
        path: '/add-member',
        builder: (context, state) {
          return const AddFamilyMemberScreen();
        },
      ),
      GoRoute(
        path: '/faq',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<FaqCubit>(),
            child: const FAQScreen(),
          );
        },
      ),
      GoRoute(
        path: '/insurance-plan',
        builder: (context, state) {
          return const InsurancePlanScreen();
        },
      ),
      GoRoute(
        path: '/contact-us',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<ContactCubit>(),
            child: const ContactUsScreen(),
          );
        },
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) {
          return const ChatScreen();
        },
      ),
      GoRoute(
        path: '/terms-policy',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<TermsCubit>(),
            child: const TermsPolicyScreen(),
          );
        },
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<ChangePasswordCubit>(),
            child: const ChangePasswordScreen(),
          );
        },
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<LanguageCubit>(),
            child: const LanguageScreen(),
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<NotificationsCubit>(),
            child: const NotificationsScreen(),
          );
        },
      ),
      GoRoute(
        path: '/network',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<NetworkCubit>(),
            child: const NetworkScreen(),
          );
        },
      ),
      GoRoute(
        path: '/policy',
        builder: (context, state) {
          return const PolicyScreen();
        },
      ),
      // Deprecated specific policy detail routes removed. Use in-app navigation with categoryId.
    ],
  );
}
