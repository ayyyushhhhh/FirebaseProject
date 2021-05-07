import 'package:flutter/foundation.dart';

class Job {
  final String name;
  final int rate;

  Job({@required this.name, @required this.rate});

  factory Job.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(name: name, rate: ratePerHour);
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "ratePerHour": rate};
  }
}
