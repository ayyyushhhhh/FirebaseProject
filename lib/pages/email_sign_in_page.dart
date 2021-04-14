import 'package:firebase_course/services/auth.dart';
import 'package:flutter/material.dart';

enum EmailSignInFormType { SignIn, Register }

class EmailSignInPage extends StatefulWidget {
  final AuthBase auth;

  const EmailSignInPage({Key key, @required this.auth}) : super(key: key);

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String emailError;
  String passwordError;

  EmailSignInFormType _formType = EmailSignInFormType.SignIn;
  //final FocusNode _emailfocusNode = FocusNode();
  final FocusNode _passwordfocusNode = FocusNode();

  void submitForm() async {
    try {
      if (_formType == EmailSignInFormType.SignIn) {
        await widget.auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      } else if (_formType == EmailSignInFormType.Register) {
        await widget.auth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      }
      Navigator.pop(context);
    } catch (e) {}
  }

  void onTypingComplete() {
    FocusScope.of(context).requestFocus(_passwordfocusNode);
  }

  void _toggle() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      if (_formType == EmailSignInFormType.SignIn) {
        _formType = EmailSignInFormType.Register;
      } else if (_formType == EmailSignInFormType.Register) {
        _formType = EmailSignInFormType.SignIn;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String primaryText =
        _formType == EmailSignInFormType.SignIn ? 'Sign In' : 'Register';
    String secondaryText = _formType == EmailSignInFormType.SignIn
        ? 'Don\'t have an Account? Register Here'
        : 'Already Have An Account?Log In ';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'name@example.com',
                        labelText: 'Email Address',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onEditingComplete: onTypingComplete,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _passwordController,
                      focusNode: _passwordfocusNode,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: _emailController.text != null &&
                              _passwordController.text != null
                          ? submitForm
                          : null,
                      child: Text(primaryText),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextButton(
                      onPressed: () {
                        _toggle();
                      },
                      child: Text(secondaryText),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
