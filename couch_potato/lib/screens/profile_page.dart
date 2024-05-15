import 'package:couch_potato/modules/card_widget.dart';
import 'package:couch_potato/profile/acquired_items.dart';
import 'package:couch_potato/profile/closed_posts.dart';
import 'package:couch_potato/profile/favorite_posts.dart';
import 'package:couch_potato/profile/open_posts.dart';
import 'package:couch_potato/profile/profile_header.dart';
import 'package:couch_potato/profile/settings_row.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ProfileHeader(),
          const SizedBox(height: 30),
          CardWidget(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            backgroundColor: const Color(0xFFFAFAFA),
            child: Column(
              children: [
                SettingsRow(
                  iconPath: 'open_in_browser',
                  text: 'Open posts',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OpenPosts(key: openPostsPageKey)),
                    );
                  },
                  padding: const EdgeInsets.only(top: 10, bottom: 3),
                ),
                const Divider(color: Color(0xFFEBEBEB), thickness: 1, indent: 54),
                SettingsRow(
                  iconPath: 'subtitles_off',
                  text: 'Closed posts',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ClosedPosts()),
                    );
                  },
                  padding: const EdgeInsets.only(top: 3, bottom: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          CardWidget(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            backgroundColor: const Color(0xFFFAFAFA),
            child: Column(
              children: [
                SettingsRow(
                  iconPath: 'star',
                  text: 'Favorite list',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritePosts()),
                    );
                  },
                  padding: const EdgeInsets.only(top: 10, bottom: 3),
                ),
                const Divider(color: Color(0xFFEBEBEB), thickness: 1, indent: 54),
                SettingsRow(
                  iconPath: 'assets/place_item.svg',
                  text: 'Acquired items',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AcquiredItems()),
                    );
                  },
                  padding: const EdgeInsets.only(top: 3, bottom: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Image.asset('assets/app_icon.png', height: 240, width: 240),
        ],
      ),
    );
  }
}
