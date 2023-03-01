import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mis_lab_4/models/exam.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  final Function deleteExamHandler;

  const ExamCard({
    super.key,
    required this.exam,
    required this.deleteExamHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        title: Text(
          exam.subjectName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(exam.date),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () => deleteExamHandler(exam.id),
        ),
      ),
    );
  }
}
