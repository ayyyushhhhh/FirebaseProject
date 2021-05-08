import 'package:flutter/foundation.dart';

class Job {
  final String name;
  final int rate;
  final String documentId;

  Job({@required this.name, @required this.rate, @required this.documentId});

  factory Job.fromMap(Map<String, dynamic> data, String id) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(name: name, rate: ratePerHour, documentId: id);
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "ratePerHour": rate};
  }
}
