import 'package:firebase_course/app/home/job_entries/format.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  group('hours', () {
    test('Positive', () {
      expect(Format.hours(10), '10h');
    });
    test('negative', () {
      expect(Format.hours(-10), '0h');
    });
    test('zero', () {
      expect(Format.hours(0), '0h');
    });
    test('decimal', () {
      expect(Format.hours(4.5), '4.5h');
    });
  });

  group('date-GB Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('2019-08-12', () {
      expect(Format.date(DateTime(2019, 08, 12)), '12 Aug 2019');
    });
  });
  group('Day Of the week-GB Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('Monday', () {
      expect(Format.dayOfWeek(DateTime(2019, 08, 12)), 'Mon');
    });
  });
  group('Currency', () {
    setUp(() async {
      Intl.defaultLocale = 'en_GB';
    });
    test('Positive', () {
      expect(Format.currency(10), '\$10');
    });
    test('negative', () {
      expect(Format.currency(-10), '\$10');
    });
    test('zero', () {
      expect(Format.currency(0), '');
    });
    test('decimal', () {
      expect(Format.currency(4.5), '\$5');
    });
  });
}
