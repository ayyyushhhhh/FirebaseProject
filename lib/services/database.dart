import 'package:firebase_course/app/home/models/entry.dart';
import 'package:firebase_course/app/home/models/jobs.dart';
import 'package:firebase_course/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_course/services/api_path.dart';

abstract class DataBase {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobsStream();
  Stream<Job> jobStream({@required String jobID});
  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job job});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FireStoreDatabase implements DataBase {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) => _service.setData(
        path: APIpath.job(uid: uid, jobID: job.documentId),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.documentId) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(
        path: APIpath.job(uid: uid, jobID: job.documentId));
  }

  @override
  Stream<Job> jobStream({@required String jobID}) => _service.documentStream(
      path: APIpath.job(uid: uid, jobID: jobID),
      builder: (data, documentID) => Job.fromMap(data, documentID));

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream<Job>(
        path: APIpath.jobPath(uid: uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Future<void> setEntry(Entry entry) => _service.setData(
        path: APIpath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) => _service.deleteData(
        path: APIpath.entry(uid, entry.id),
      );

  @override
  Stream<List<Entry>> entriesStream({Job job}) =>
      _service.collectionStream<Entry>(
        path: APIpath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.documentId)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
