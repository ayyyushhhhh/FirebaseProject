import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course/app/app_sign_in/sing_in_page.dart';
import 'package:firebase_course/pages/home_page.dart';
import 'package:firebase_course/services/auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final AuthBase auth;

  const LandingPage({Key key, @required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.authStateChages(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return SignInPage(authBase: auth);
          } else if (user != null) {
            return HomePage(authBase: auth);
          }
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
