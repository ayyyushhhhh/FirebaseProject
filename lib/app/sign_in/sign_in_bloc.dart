import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course/services/auth.dart';
import 'package:flutter/cupertino.dart';

class SignInBloc {
  SignInBloc({@required this.auth, @required this.isLoading});
  final ValueNotifier<bool> isLoading;
  final AuthBase auth;
  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInWithGoogle() async {
    return await _signIn(() => auth.signInWithGoogle());
  }

  Future<User> signInAnonymously() async {
    return await _signIn(() => auth.signInAnonymously());
  }

  Future<void> signOut() async {
    return await auth.signOut();
  }
}
