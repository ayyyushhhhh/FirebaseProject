import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course/app/sign_in/email_sign_in_bloc.dart';
import 'package:firebase_course/app/sign_in/enail_sign_in_model.dart';
import 'package:firebase_course/common_widgets/form_submit_button.dart';
import 'package:firebase_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_course/services/auth.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({this.bloc});
  final EmailSignInBloc bloc;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider(
      create: (_) {
        return EmailSignInBloc(auth: auth);
      },
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) {
          return EmailSignInFormBlocBased(
            bloc: bloc,
          );
        },
      ),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();

    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    bool submitEnabled = model.emailValidator.isValid(model.email) &&
        model.passwordValidator.isValid(model.password) &&
        !model.isLoading;

    return [
      _buildEmailTextField(model),
      SizedBox(height: 8.0),
      _buildPasswordTextField(model),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: widget.bloc.primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0),
      TextButton(
        child: Text(widget.bloc.secondaryText),
        onPressed: !model.isLoading ? () => _toggleFormType() : null,
      ),
    ];
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    bool showErrorText =
        model.isSubmitted && !model.passwordValidator.isValid(model.password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? model.invalidPasswordErrorText : null,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => widget.bloc.updatePassword(password),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    bool showErrorText =
        model.isSubmitted && !model.emailValidator.isValid(model.email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? model.invalidEmailErrorText : null,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => widget.bloc.updateEmail(email),
      onEditingComplete: () => _emailEditingComplete(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.bloc.modelStream,
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model),
            ),
          );
        });
  }
}
