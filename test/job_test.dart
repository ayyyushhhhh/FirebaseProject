import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_course/app/home/models/jobs.dart';

void main() {
  group('from map', () {
    test('null body', () {
      final job = Job.fromMap(null, 'abc');
      expect(job, null);
    });
  });

  test('with all propertis', () {
    final job = Job.fromMap({
      'name': 'blogging',
      'ratePerHour': 30,
    }, 'abc');
    expect(job.name, 'blogging');
    expect(job.rate, 30);
    expect(job.documentId, 'abc');
  });
}
