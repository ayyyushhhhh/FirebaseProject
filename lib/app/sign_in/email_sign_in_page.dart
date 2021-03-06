import 'package:firebase_course/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:flutter/material.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInFormStateful(),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
