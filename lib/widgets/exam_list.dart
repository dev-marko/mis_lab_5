import 'package:flutter/material.dart';

import 'package:mis_lab_4/models/exam.dart';
import 'package:mis_lab_4/widgets/exam_card.dart';

class ExamList extends StatelessWidget {
  final List<Exam> exams;
  final Function deleteExamHandler;

  const ExamList({
    super.key,
    required this.exams,
    required this.deleteExamHandler,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: exams.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 25,
                ),
                const Icon(
                  Icons.not_listed_location_outlined,
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return ExamCard(
                  exam: exams[index],
                  deleteExamHandler: deleteExamHandler,
                );
              },
              itemCount: exams.length,
            ),
    );
  }
}
