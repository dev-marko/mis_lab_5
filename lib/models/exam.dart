import 'package:flutter/material.dart';
import 'package:mis_lab_4/models/location.dart';

class Exam with ChangeNotifier {
  final String? id;
  final String subjectName;
  final DateTime date;
  final Location? location;

  Exam({
    this.id,
    required this.subjectName,
    required this.date,
    this.location,
  });

  @override
  String toString() {
    return subjectName;
  }
}
