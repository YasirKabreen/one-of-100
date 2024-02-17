import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:one_off_100/image.dart';
import 'package:one_off_100/signin.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator while checking authentication status
        } else if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, navigate to home screen
          return ImagePickerScreen();
        } else {
          // User is not logged in, navigate to login screen
          return SignIn();
        }
      },
    );
  }
}
