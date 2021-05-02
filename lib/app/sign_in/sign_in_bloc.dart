import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course/services/auth.dart';
import 'package:flutter/cupertino.dart';

class SignInBloc {
  final AuthBase auth;

  final StreamController<bool> _isLoadingController = StreamController<bool>();

  SignInBloc({@required this.auth});

  Stream<bool> get isLoadingStream {
    return _isLoadingController.stream;
  }

  void _setIsLoading(bool isLoading) {
    return _isLoadingController.add(isLoading);
  }

  void dispose() {
    _isLoadingController.close();
  }

  Future<User> _signIn(Future<User> Function() signInFunction) async {
    try {
      _setIsLoading(true);
      return await signInFunction();
    } catch (e) {
      _setIsLoading(false);
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
