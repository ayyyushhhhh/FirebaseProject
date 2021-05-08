import 'package:firebase_course/app/home/models/jobs.dart';
import 'package:flutter/material.dart';

class JobListTile extends StatelessWidget {
  final Job job;

  JobListTile({Key key, @required this.job, @required this.onTap})
      : super(key: key);
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
