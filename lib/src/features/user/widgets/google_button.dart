import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class GoogleSigninButton extends ConsumerWidget {
  const GoogleSigninButton({
    Key? key,
  }) : super(key: key);

  void signinWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => signinWithGoogle(context, ref),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: Pallete.greyOne, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 25.0,
                width: 30.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/googlelogo.jpg'),
                      fit: BoxFit.cover),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                "Continue with Google",
                style: TextStyle(color: Pallete.textGrey, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
