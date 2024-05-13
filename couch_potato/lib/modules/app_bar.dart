import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final int? currentIndex;
  final String title;

  const MyAppBar({
    super.key,
    this.showBackButton = false,
    this.currentIndex,
    this.title = 'COUCH POTATO',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF444444)),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF444444),
          fontSize: 20,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          letterSpacing: 2.20,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
