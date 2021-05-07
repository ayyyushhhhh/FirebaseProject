import 'package:firebase_course/app/home/models/jobs.dart';
import 'package:firebase_course/services/api_path.dart';
import 'package:firebase_course/services/firestore_services.dart';
import 'package:flutter/foundation.dart';

abstract class DataBase {
  Future<void> createJobs(Job job);
  Stream<List<Job>> jobsStream();
}

class FireStoreDatabase implements DataBase {
  final String uid;
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  FireStoreServices _fireStoreServices = FireStoreServices.instance;

  Future<void> createJobs(Job job) async {
    final String path = APIpath.job(uid: uid, jobID: "job_abc");
    _fireStoreServices.setData(path, job.toMap());
  }

  Stream<List<Job>> jobsStream() {
    final path = APIpath.jobPath(uid);
    return _fireStoreServices.collectStream(
        path: path, builder: (data) => Job.fromMap(data));
  }
}
