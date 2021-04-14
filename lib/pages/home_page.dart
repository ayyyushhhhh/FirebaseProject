import 'package:firebase_course/services/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, @required this.authBase});
  final AuthBase authBase;

  Future<void> _logOut() async {
    await authBase.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        actions: [
          TextButton(
              onPressed: () {
                _logOut();
              },
              child: Text('Logout'))
        ],
      ),
    );
  }
}
