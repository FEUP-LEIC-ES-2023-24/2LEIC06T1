import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 1.5, color: Colors.black54)),
            child: Image.network(
                userCredential.value.user!.photoURL.toString()),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(userCredential.value.user!.displayName
              .toString()),
          const SizedBox(
            height: 20,
          ),
          Text(userCredential.value.user!.email.toString()),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () async {
                bool result = await signOutFromGoogle();
                if (result) userCredential.value = '';
              },
              child: const Text('Logout'))
        ],
      ),
    );
  }
}

