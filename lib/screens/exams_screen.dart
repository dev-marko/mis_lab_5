import 'package:flutter/material.dart';
import 'package:mis_lab_4/widgets/exam_list.dart';
import 'package:mis_lab_4/widgets/new_exam.dart';
import 'package:uuid/uuid.dart';

import 'package:mis_lab_4/models/exam.dart';

class ExamsScreen extends StatefulWidget {
  static const String routeName = '/exams';

  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
final List<Exam> _exams = [
    // Exam(
    //   id: const Uuid().v4(),
    //   subjectName: 'Mobile Informatic Systems',
    //   date: DateTime.now(),
    // ),
    // Exam(
    //   id: const Uuid().v4(),
    //   subjectName: 'Intro to Robotics',
    //   date: DateTime.now(),
    // ),
  ];

  void _addNewExam(String subjectName, DateTime date) {
    final newExam = Exam(
      id: const Uuid().v4(),
      subjectName: subjectName,
      date: date,
    );

    setState(() {
      _exams.add(newExam);
    });
  }

  void _showAddExam(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return NewExam(
          addNewExamHandler: _addNewExam,
        );
      },
    );
  }

  void _deleteExam(String id) {
    setState(() {
      _exams.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Exams & Midterms'),
        actions: [
          IconButton(
            onPressed: () => _showAddExam(context),
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExamList(
              exams: _exams,
              deleteExamHandler: _deleteExam,
            ),
          ],
        ),
      ),
    );
  }
}