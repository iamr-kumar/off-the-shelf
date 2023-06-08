import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:off_the_shelf/src/features/home/view/home_tab.dart';
import 'package:off_the_shelf/src/features/library/view/library_tab.dart';
import 'package:off_the_shelf/src/features/session/view/session_tab.dart';
import 'package:off_the_shelf/src/features/streak/view/streak_tab.dart';
import 'package:off_the_shelf/src/features/user/view/profile_tab.dart';

import 'package:off_the_shelf/src/theme/pallete.dart';

class HomeScreen extends StatefulWidget {
  static const route = "/";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void switchPage(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeScreenItems = <Widget>[
      const HomeTab(),
      const StreakTab(),
      const ReadingSessionTab(),
      const LibraryTab(),
      const ProfileTab()
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Pallete.primaryBlue,
        unselectedItemColor: Pallete.textGrey,
        backgroundColor: Pallete.greyOne,
        type: BottomNavigationBarType.fixed,
        currentIndex: _page,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.home,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.barChart2,
              ),
              label: 'Track'),
          BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.clock,
              ),
              label: 'Read'),
          BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.bookOpen,
              ),
              label: 'Library'),
          BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.user,
              ),
              label: 'Profile')
        ],
        onTap: switchPage,
      ),
    );
  }
}
