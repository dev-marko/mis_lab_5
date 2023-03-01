import 'package:flutter/material.dart';
import 'package:mis_lab_4/widgets/new_exam.dart';
import 'package:uuid/uuid.dart';

import 'package:mis_lab_4/models/exam.dart';
import 'package:mis_lab_4/widgets/exam_list.dart';

/// ### Laboratory Exercise 4 ###
/// Author: Marko Spasenovski
/// Index number: 191128
/// Subject: Mobile Informatic Systems
/// Mentor: Petre Lameski pHd.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Scheduler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Exam Scheduler'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        title: Text(widget.title),
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
