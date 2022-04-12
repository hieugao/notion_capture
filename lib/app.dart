import 'package:flutter/material.dart';

import 'package:device_preview/device_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import './common/constants.dart' show Routes;
import './common/theme.dart';
import 'features/onboarding/providers.dart';
import 'screens/dashboard_screen.dart';
import 'screens/onboarding_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isOnBoarded = ref.watch(onBoardingProvider);

        return MaterialApp(
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: (context, widget) {
            final responsive = ResponsiveWrapper.builder(
              ClampingScrollWrapper.builder(context, widget!),
              breakpoints: const [
                ResponsiveBreakpoint.resize(350, name: MOBILE),
                ResponsiveBreakpoint.autoScale(600, name: TABLET),
                ResponsiveBreakpoint.resize(840, name: DESKTOP),
                ResponsiveBreakpoint.autoScale(1600, name: 'XL'),
              ],
            );
            return DevicePreview.appBuilder(context, responsive);
          },
          debugShowCheckedModeBanner: false,
          title: 'Notion Capture',
          theme: themeData,
          initialRoute: isOnBoarded ? Routes.home : Routes.onboarding,
          routes: {
            Routes.home: (context) => const DashboardScreen(),
            Routes.onboarding: (context) => const OnboardingScreen(),
          },
        );
      },
    );
  }
}
