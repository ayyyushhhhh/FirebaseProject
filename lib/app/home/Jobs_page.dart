import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_course/app/home/models/jobs.dart';
import 'package:firebase_course/common_widgets/show_alert_dialog.dart';
import 'package:firebase_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:firebase_course/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_course/services/auth.dart';

class JobsPage extends StatelessWidget {
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

  StreamBuilder<List<Job>> _buildContents(BuildContext context) {
    final database = Provider.of<DataBase>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final List<Widget> children =
              jobs.map<Widget>((job) => Text(job.name)).toList();
          return ListView(
            children: children,
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error occucred'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createJobs(context);
        },
        child: Icon(Icons.add),
      ),
      body: _buildContents(context),
    );
  }

  Future<void> _createJobs(BuildContext context) async {
    try {
      final database = Provider.of<DataBase>(context, listen: false);
      await database.createJobs(Job(name: "blogging", rate: 10));
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: "Operation Failed", exception: e);
    }
  }
}
