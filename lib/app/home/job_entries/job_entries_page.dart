import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_course/app/home/Jobs/edit_job_page.dart';
import 'package:firebase_course/app/home/Jobs/list_item_builder.dart';
import 'package:firebase_course/app/home/job_entries/entry_list_item.dart';
import 'package:firebase_course/app/home/job_entries/entry_page.dart';
import 'package:firebase_course/app/home/models/entry.dart';
import 'package:firebase_course/app/home/models/jobs.dart';
import 'package:firebase_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:firebase_course/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.jobEntry});
  final DataBase database;
  final Job jobEntry;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<DataBase>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, jobEntry: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(jobID: jobEntry.documentId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final job = snapshot.data;
            final jobName = job?.name ?? "";
            return Scaffold(
              appBar: AppBar(
                elevation: 2.0,
                title: Text(jobName),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        EntryPage.show(
                            context: context, database: database, job: job);
                      }),
                  TextButton(
                    child: Text(
                      'Edit',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    onPressed: () =>
                        EditJobPage.show(context, database: database, job: job),
                  ),
                ],
              ),
              body: _buildContent(context, job),
            );
          }
          return CircularProgressIndicator();
        });
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
