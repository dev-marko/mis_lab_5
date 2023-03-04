import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mis_lab_4/providers/exams_provider.dart';
import 'package:provider/provider.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Exam exam = Provider.of<Exam>(context, listen: false);
    final examsProvider = Provider.of<ExamsProvider>(context, listen: false);

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
          color: Theme.of(context).colorScheme.error,
          onPressed: () => examsProvider.deleteExam(exam.id!),
        ),
      ),
    );
  }
}
