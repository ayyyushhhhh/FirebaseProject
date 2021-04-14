import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_course/pages/landing_page.dart';
import 'package:firebase_course/services/auth.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: LandingPage(
        auth: Auth(),
      ),
    );
  }
}
