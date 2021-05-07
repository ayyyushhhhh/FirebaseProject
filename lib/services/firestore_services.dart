import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FireStoreServices {
  FireStoreServices._();

  static final instance = FireStoreServices._();

  Future<void> setData(String path, Map<String, dynamic> job) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.doc(path);
    await documentReference.set(job);
  }

  Stream<List<T>> collectStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map((snapshot) => builder(snapshot.data())).toList());
  }
}
