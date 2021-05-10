import 'package:firebase_course/common_widgets/show_alert_dialog.dart';
import 'package:firebase_course/services/auth.dart';
import 'package:firebase_course/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _signOut(BuildContext context) async {
      try {
        final auth = Provider.of<AuthBase>(context, listen: false);
        await auth.signOut();
      } catch (e) {
        print(e.toString());
      }
    }

    Future<void> _confirmSignOut(BuildContext context) async {
      final didRequestSignOut = await showAlertDialog(
        context,
        title: 'Logout',
        content: 'Are you sure that you want to logout?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Logout',
      );
      if (didRequestSignOut == true) {
        _signOut(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
