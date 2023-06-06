import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:off_the_shelf/src/core/constants/local_constants.dart';
import 'package:off_the_shelf/src/core/widgets/custom_button.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class LandingScreen extends StatelessWidget {
  static const route = "/";

  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devHeight = MediaQuery.of(context).size.height;

    void showSingupScreen() {
      Routemaster.of(context).push('/signup');
    }

    final Widget welcomeIllustration = SvgPicture.asset(
        Constants.welcomeIllustration,
        height: devHeight * 0.6);

    return Scaffold(
      backgroundColor: Pallete.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            welcomeIllustration,
            SizedBox(height: devHeight * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(Constants.appName,
                      textAlign: TextAlign.left,
                      style: AppStyles.headingOne
                          .copyWith(color: Pallete.primaryBlue)),
                ),
                SizedBox(
                  height: devHeight * 0.02,
                ),
                Text(Constants.welcomeMessage,
                    textAlign: TextAlign.left,
                    style: AppStyles.subtext.copyWith(color: Pallete.textGrey)),
                SizedBox(height: devHeight * 0.04),
                CustomButton(
                  text: 'Get Started',
                  onPressed: showSingupScreen,
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
