import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String message;
  EmptyContent(
      {this.title = "Nothing To Show", this.message = "Please Add new job"});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('images/empty.png'),
        Text(
          title,
          style: TextStyle(fontSize: 32),
        ),
        Text(
          message,
          style: TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}
