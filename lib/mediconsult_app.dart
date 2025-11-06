import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/routing/app_router.dart';
import 'package:mediconsult/core/widgets/offline_banner.dart';

class MediConsultApp extends StatelessWidget {
  const MediConsultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        title: 'MediConsult',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        builder: (context, child) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) {
                return;
              }
              if (context.canPop()) {
                context.pop();
                return;
              }
              String? loc;
              try {
                loc = GoRouter.of(
                  context,
                ).routeInformationProvider.value.uri.toString();
              } catch (_) {}
              if (loc != null) {
                if (loc.startsWith('/profile')) {
                  context.go('/profile');
                } else if (loc.startsWith('/approval-request')) {
                  context.go('/approval-request');
                } else if (loc.startsWith('/network')) {
                  context.go('/network');
                } else {
                  context.go('/home');
                }
              } else {
                context.go('/home');
              }
            },
            child: Stack(
              children: [
                child ?? const SizedBox.shrink(),
                // Offline banner at the top
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 0,
                  right: 0,
                  child: const OfflineBanner(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
