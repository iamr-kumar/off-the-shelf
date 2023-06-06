// Guest Routes
import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/features/user/view/landing_screen.dart';
import 'package:off_the_shelf/src/features/user/view/login_screen.dart';
import 'package:off_the_shelf/src/features/user/view/singup_screen.dart';
import 'package:off_the_shelf/src/features/home/view/home_screen.dart';
import 'package:off_the_shelf/src/features/onboarding/view/book_select_screen.dart';
import 'package:off_the_shelf/src/features/onboarding/view/finish_screen.dart';
import 'package:off_the_shelf/src/features/onboarding/view/set_reminder_screen.dart';
import 'package:off_the_shelf/src/features/onboarding/view/set_target_screen.dart';
import 'package:off_the_shelf/src/features/onboarding/view/start_screen.dart';
import 'package:routemaster/routemaster.dart';

final guestRoutes = RouteMap(routes: {
  LandingScreen.route: (_) => const MaterialPage(child: LandingScreen()),
  LoginScreen.route: (_) => const MaterialPage(child: LoginScreen()),
  SignupScreen.route: (_) => const MaterialPage(child: SignupScreen()),
});

// Authenticated Routes
final authenticatedRoutes =
    RouteMap(onUnknownRoute: (_) => const Redirect(HomeScreen.route), routes: {
  HomeScreen.route: (_) => const MaterialPage(child: HomeScreen()),
});

final onboardingRoutes =
    RouteMap(onUnknownRoute: (_) => const Redirect('/'), routes: {
  OnboardingStartScreen.route: (_) =>
      const MaterialPage(child: OnboardingStartScreen()),
  OnboardingBookSelectScreen.route: (_) =>
      const MaterialPage(child: OnboardingBookSelectScreen()),
  OnboardingSetTargetScreen.route: (_) =>
      const MaterialPage(child: OnboardingSetTargetScreen()),
  OnboardingSetReminderScreen.route: (_) =>
      const MaterialPage(child: OnboardingSetReminderScreen()),
  OnboardingFinishScreen.route: (_) =>
      const MaterialPage(child: OnboardingFinishScreen()),
});
