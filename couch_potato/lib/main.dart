import 'package:couch_potato/modules/app_bar.dart';
import 'package:couch_potato/modules/nav_app_bar.dart';
import 'package:couch_potato/screens/home_page.dart';
import 'package:couch_potato/screens/profile_page.dart';
import 'package:couch_potato/screens/chat_page.dart';
import 'package:couch_potato/screens/chatlist_page.dart';
import 'package:couch_potato/screens/login_page.dart';
import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
/* import 'package:flutter/services.dart'; */

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  fetchLocation();

  runApp(const MyApp());
}

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
        '/': (context) => const PopScope(canPop: false, child: GoogleSignInScreen()),
        '/home': (context) => const PopScope(canPop: false, child: MyHome()),
        '/chat': (context) => const PopScope(canPop: false, child: ChatPage()),
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
    const ChatListPage(),
    const HomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    print("Current Page Index: $_currentPageIndex");
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
      bottomNavigationBar: _currentPageIndex == 3 ? null : NavAppBar(
        currentIndex: _currentPageIndex,
        pageController: _pageController,
      ),
    );
  }
}
