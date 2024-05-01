import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  ValueNotifier userCredential = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: null,
        body: ValueListenableBuilder(
            valueListenable: userCredential,
            builder: (context, value, child) {
              return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              userCredential.value = await signInWithGoogle();
                              if (userCredential.value != null)
                                print(userCredential.value.user!.email);
                                Navigator.pushNamed(context, '/home');  
                            },
                          
                            child: Row(
                              children: [
                                IconButton(
                                  iconSize: 40,
                                  icon: Image.asset(
                                    'assets/google_icon.png',
                                  ),
                                  onPressed: () async {
                                    userCredential.value = await signInWithGoogle();
                                    if (userCredential.value != null){
                                      print(userCredential.value.user!.email);
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Sign in with google',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                )
                              ]
                            )
                          )
                        )
                      ),
              );
            }));
  }
}

Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on Exception catch (e) {
    // TODO
    print('exception->$e');
  }
}

Future<bool> signOutFromGoogle() async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } on Exception catch (_) {
    return false;
  }
}