import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_course/app/home/Jobs/edit_job_page.dart';
import 'package:firebase_course/app/home/Jobs/list_item_builder.dart';
import 'package:firebase_course/app/home/job_entries/job_entries_page.dart';
import 'package:firebase_course/app/home/models/jobs.dart';
import 'package:firebase_course/common_widgets/job_list_tile.dart';
import 'package:firebase_course/common_widgets/show_alert_dialog.dart';
import 'package:firebase_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:firebase_course/services/database.dart';
import 'package:flutter/cupertino.dart';
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

  Future<void> _deleteJob(BuildContext context, Job job) async {
    try {
      final database = Provider.of<DataBase>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text("Operation Failed"),
          content: new Text("ops! Something Went Wrong"),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              isDefaultAction: true,
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  StreamBuilder<List<Job>> _buildContents(BuildContext context) {
    final database = Provider.of<DataBase>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListItemsBuilder(
          snapshot: snapshot,
          itemBuilder: (context, job) {
            return Dismissible(
              key: Key('job-${job.documentId}'),
              background: Container(
                color: Colors.red,
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                _deleteJob(context, job);
              },
              child: JobListTile(
                job: job,
                onTap: () {
                  JobEntriesPage.show(context, job);
                },
              ),
            );
          },
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
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                EditJobPage.show(
                  context,
                  database: Provider.of<DataBase>(context, listen: false),
                );
              }),
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
      body: _buildContents(context),
    );
  }

  Future<void> _createJobs(BuildContext context) async {
    try {
      final database = Provider.of<DataBase>(context, listen: false);
      await database
          .setJob(Job(name: "blogging", rate: 10, documentId: "dgssd"));
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: "Operation Failed", exception: e);
    }
  }
}
