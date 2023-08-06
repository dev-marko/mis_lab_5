import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mis_lab_4/models/exceptions/http_exception.dart';

import '../models/exam.dart';

class ExamsProvider with ChangeNotifier {
  List<Exam> _exams = [];
  Map<DateTime, List<Exam>> _examsMap = {};
  final String authToken;
  final String? userId;
  final db = FirebaseDatabase.instance;

  ExamsProvider(
      [this.authToken = "", this.userId = "", this._exams = const []]);

  List<Exam> get exams {
    return [..._exams];
  }

  Map<DateTime, List<Exam>> get examsMap {
    return {}..addAll(_examsMap);
  }

  Future<void> fetchExamsSdk() async {
    try {
      var userExamsSnapshot = await db.ref('userExams/$userId').get();
      if (userExamsSnapshot.exists) {
        for (var examSnapshot in userExamsSnapshot.children) {
          var exam = examSnapshot.value as Map<Object?, Object?>;
          _exams.add(
            Exam(
              id: examSnapshot.key,
              subjectName: exam['subjectName'] as String,
              date: DateTime.parse(exam['date'] as String),
            ),
          );
        }
      }
    } catch (err) {
      rethrow;
    }
  }

  Map<DateTime, List<Exam>> generateEventMap() {
    Map<DateTime, List<Exam>> mapOfExams = {};
    for (var element in exams) {
      var key = DateFormat('yyyy-MM-dd').parse(element.date.toIso8601String());
      mapOfExams.putIfAbsent(key, () => []);
      mapOfExams[key]?.add(element);
    }
    return mapOfExams;
  }

  Future<void> fetchExams() async {
    final Uri url = Uri.https(
      'finki-mis-default-rtdb.europe-west1.firebasedatabase.app',
      '/userExams/$userId.json',
      {
        "auth": authToken,
      },
    );

    try {
      final examsResponse = await http.get(url);
      final examsData = json.decode(examsResponse.body);
      final List<Exam> loadedExams = [];

      if (examsData != null) {
        final examsMap = examsData as Map<String, dynamic>;
        examsMap.forEach((examId, examData) {
          loadedExams.add(
            Exam(
              id: examId,
              subjectName: examData['subjectName'],
              date: DateTime.parse(examData['date']),
            ),
          );
        });
      }

      _exams = loadedExams;
      _examsMap = generateEventMap();
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> addExam(Exam exam) async {
    final Uri url = Uri.https(
      'finki-mis-default-rtdb.europe-west1.firebasedatabase.app',
      '/userExams/$userId.json',
      {
        "auth": authToken,
      },
    );

    try {
      final examResponse = await http.post(
        url,
        body: json.encode({
          'subjectName': exam.subjectName,
          'date': exam.date.toIso8601String(),
        }),
      );

      var examData = json.decode(examResponse.body);

      final newExam = Exam(
        id: examData['name'],
        subjectName: exam.subjectName,
        date: exam.date,
      );

      _exams.add(newExam);
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> updateExam(String id, Exam editedExam) async {
    final int examIndex = _exams.indexWhere((exam) => exam.id == id);
    if (examIndex < 0) {
      throw HttpException('Exam index not found');
    }

    try {
      final Uri url = Uri.https(
        'finki-mis-default-rtdb.europe-west1.firebasedatabase.app',
        '/userExams/$userId.json/$id.json',
        {
          "auth": authToken,
        },
      );

      await http.patch(
        url,
        body: json.encode({
          'subjectName': editedExam.subjectName,
          'date': editedExam.date,
        }),
      );

      _exams[examIndex] = editedExam;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<Exam> deleteExam(String id) async {
    final existingExamIndex = _exams.indexWhere((exam) => exam.id == id);
    var existingExam = _exams[existingExamIndex];

    _exams.removeAt(existingExamIndex);
    notifyListeners();

    try {
      await FirebaseDatabase.instance
          .ref()
          .child('userExams')
          .child('$userId')
          .child(id)
          .remove();
    } catch (err) {
      HttpException("An exception occured");
    }

    return existingExam;
  }

  Exam findById(String id) {
    return _exams.firstWhere((exam) => exam.id == id);
  }
}
