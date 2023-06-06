import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/constants/local_constants.dart';
import 'package:off_the_shelf/src/core/routes.dart';
import 'package:off_the_shelf/src/core/widgets/error_text.dart';
import 'package:off_the_shelf/src/core/widgets/loader.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/models/user.model.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? user;

  void getUserData(WidgetRef ref, User data) async {
    user = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => user);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
        data: (data) => MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: Constants.appName,
              theme: Pallete.lightModeAppTheme,
              routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
                if (data != null) {
                  getUserData(ref, data);
                  if (user != null) {
                    if (user!.onboardingComplete) {
                      return authenticatedRoutes;
                    } else {
                      return onboardingRoutes;
                    }
                  }
                }
                return guestRoutes;
              }),
              routeInformationParser: const RoutemasterParser(),
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
