import 'package:firebase_course/app/home/models/jobs.dart';
import 'package:firebase_course/services/api_path.dart';
import 'package:firebase_course/services/firestore_services.dart';
import 'package:flutter/foundation.dart';

abstract class DataBase {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> deleteJob(Job job);
}

class FireStoreDatabase implements DataBase {
  final String uid;
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  FireStoreServices _fireStoreServices = FireStoreServices.instance;

  @override
  Future<void> setJob(Job job) async {
    final String path = APIpath.job(uid: uid, jobID: job.documentId);
    _fireStoreServices.setData(path: path, job: job.toMap());
  }

  @override
  Future<void> deleteJob(Job job) async {
    await _fireStoreServices.delete(
        path: APIpath.job(uid: uid, jobID: job.documentId));
  }

  @override
  Stream<List<Job>> jobsStream() {
    final path = APIpath.jobPath(uid);
    return _fireStoreServices.collectStream(
        path: path, builder: (data, id) => Job.fromMap(data, id));
  }
}
