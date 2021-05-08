import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FireStoreServices {
  FireStoreServices._();

  static final instance = FireStoreServices._();

  Future<void> setData(
      {@required String path, @required Map<String, dynamic> job}) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.doc(path);
    await documentReference.set(job);
  }

  Future<void> delete({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print("delete+$path");
    reference.delete();
  }

  Stream<List<T>> collectStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }
}
