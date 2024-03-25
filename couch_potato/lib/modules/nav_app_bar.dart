import 'package:couch_potato/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavAppBar extends StatelessWidget {
  final int currentIndex;
  final PageController pageController;

  const NavAppBar({
    super.key,
    required this.currentIndex,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    NavigationDestination profilePage = const NavigationDestination(
      icon: Icon(
        Icons.person_outline,
        color: Color.fromRGBO(68, 68, 68, 1),
        size: 36,
      ),
      selectedIcon: Icon(
        Icons.water_drop_outlined,
        color: Colors.white,
        size: 36,
      ),
      label: "Recipes",
    );

    NavigationDestination homePage = const NavigationDestination(
      icon: Icon(
        Icons.add_circle_outline,
        color: Color.fromRGBO(68, 68, 68, 1),
        size: 36,
      ),
      selectedIcon: Icon(
        Icons.add_circle_outline,
        color: Colors.white,
        size: 36,
      ),
      label: "Home",
    );

    NavigationDestination settingsPage = NavigationDestination(
      icon: SvgPicture.asset(
        'assets/nav_bar_icons/settings_icon.svg',
        // ignore: deprecated_member_use
        color: const Color.fromRGBO(68, 68, 68, 1),
        height: 27,
        width: 27,
      ),
      selectedIcon: SvgPicture.asset(
        'assets/nav_bar_icons/settings_icon.svg',
        // ignore: deprecated_member_use
        color: Colors.white,
        height: 27,
        width: 27,
      ),
      label: "Settings",
    );

    return NavigationBar(
      height: 70,
      animationDuration: const Duration(seconds: 2),
      surfaceTintColor: Colors.transparent,
      indicatorColor: appColor,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        int pageDifference = (currentIndex - index).abs();
        switch (pageDifference) {
          case 1:
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
            );
            break;
          case 2:
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeInOut,
            );
            break;     
        }
      },
      destinations: [profilePage, homePage, settingsPage],
    );
  }
}
