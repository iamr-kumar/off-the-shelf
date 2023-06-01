// Guest Routes
import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/features/auth/view/landing_screen.dart';
import 'package:off_the_shelf/src/features/auth/view/login_screen.dart';
import 'package:off_the_shelf/src/features/auth/view/singup_screen.dart';

import 'package:routemaster/routemaster.dart';

final guestRoutes = RouteMap(routes: {
  LandingScreen.route: (_) => const MaterialPage(child: LandingScreen()),
  LoginScreen.route: (_) => const MaterialPage(child: LoginScreen()),
  SignupScreen.route: (_) => const MaterialPage(child: SignupScreen()),
});

// Authenticated Routes
final authenticatedRoutes =
    RouteMap(onUnknownRoute: (_) => const Redirect('/'), routes: {
  '/': (_) => const MaterialPage(child: Scaffold()),
});

final onboardingRoutes =
    RouteMap(onUnknownRoute: (_) => const Redirect('/'), routes: {
  '/': (_) => const MaterialPage(child: Scaffold()),
  // '/onboarding/select-book': (_) =>
  //     const MaterialPage(child: OnboardingBookSelectScreen()),
  // '/onboarding/set-target': (_) =>
  //     const MaterialPage(child: OnboardingSetTargetScreen()),
  // '/onboarding/select-time': (_) =>
  //     const MaterialPage(child: OnboardingTimeSelectScreen()),
  // '/onboarding/finish': (_) =>
  //     const MaterialPage(child: OnboardingFinishScreen()),
});
