import 'package:couch_potato/modules/app_bar.dart';
import 'package:couch_potato/modules/nav_app_bar.dart';
import 'package:couch_potato/screens/home_page.dart';
import 'package:couch_potato/screens/profile_page.dart';
import 'package:couch_potato/screens/settings_page.dart';
import 'package:flutter/material.dart';
/* import 'package:flutter/services.dart'; */

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

Color appColor = const Color(0xFFCF7000);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ); */

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COUCH POTATO',
      theme: ThemeData(
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => const PopScope(canPop: false, child: MyHome()),
        /* '/signup': (context) => const PopScope(canPop: false, child: SignUpPage()), */
      },
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _currentPageIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  final List<Widget> _pages = [
    const ProfilePage(),
    const HomePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(currentIndex: _currentPageIndex),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: NavAppBar(
        currentIndex: _currentPageIndex,
        pageController: _pageController,
      ),
    );
  }
}
