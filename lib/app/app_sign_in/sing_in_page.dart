import 'package:firebase_course/pages/email_sign_in_page.dart';
import 'package:firebase_course/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

double deviceHeight;

class SignInPage extends StatelessWidget {
  SignInPage({@required this.authBase});
  final AuthBase authBase;
  Future<void> _signInAnoymously() async {
    try {
      await authBase.signInAnoymously();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await authBase.signInWithGoogle();
    } catch (e) {
      print(e);
    }
  }

  void _signInWithEmail(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return EmailSignInPage(
          auth: authBase,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign In',
              style: TextStyle(
                fontSize: deviceHeight / 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {
                _signInWithGoogle();
              },
              child: _signInContainer(
                  logoIcon: FontAwesomeIcons.google,
                  iconName: 'Google',
                  containerColor: Colors.white),
            ),
            GestureDetector(
              onTap: () {
                print('facebook');
              },
              child: _signInContainer(
                  logoIcon: FontAwesomeIcons.facebook,
                  iconName: 'Facebook',
                  containerColor: Colors.blue),
            ),
            GestureDetector(
              onTap: () {
                print('email');
                //  _signInWithEmail(context);
              },
              child: _signInContainer(
                  logoIcon: CupertinoIcons.mail,
                  iconName: 'Sign In With Email',
                  containerColor: Colors.tealAccent),
            ),
            Text('Or'),
            GestureDetector(
              onTap: () {
                _signInAnoymously();
              },
              child: _signInContainer(
                  logoIcon: CupertinoIcons.person_crop_circle,
                  containerColor: Colors.grey,
                  iconName: 'Go Anonymous'),
            ),
          ],
        ),
      ),
    );
  }

  Container _signInContainer(
      {IconData logoIcon,
      @required String iconName,
      @required Color containerColor}) {
    return Container(
      height: deviceHeight / 15,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: deviceHeight / 30,
          ),
          Icon(
            logoIcon,
            size: deviceHeight / 20,
            color: Colors.black,
          ),
          SizedBox(
            width: deviceHeight / 25,
          ),
          Text(
            'Sign In With $iconName',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: deviceHeight / 50),
          ),
        ],
      ),
    );
  }
}
