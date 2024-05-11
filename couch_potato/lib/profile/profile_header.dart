import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String username = 'Username';
  String photoURL = '';

  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;

// Retrieve user details
    username = user?.displayName ?? 'Username';
    photoURL = user?.photoURL ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        CircleAvatar(
          key: UniqueKey(),
          backgroundImage: photoURL.isNotEmpty ? NetworkImage(photoURL) : null,
          radius: 25,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            username,
            style: const TextStyle(
              color: Color(0xFF434B53),
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              letterSpacing: 1.6,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
