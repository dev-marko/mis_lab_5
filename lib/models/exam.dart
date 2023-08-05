import 'package:flutter/material.dart';

class Exam with ChangeNotifier {
  final String? id;
  final String subjectName;
  final DateTime date;

  Exam({
    this.id,
    required this.subjectName,
    required this.date,
  });

  @override
  String toString() {
    return subjectName;
  }
}
