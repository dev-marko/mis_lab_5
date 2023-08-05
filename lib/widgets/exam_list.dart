import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/exam.dart';
import '../providers/exams_provider.dart';
import 'exam_card.dart';

class ExamList extends StatelessWidget {
  const ExamList({super.key});

  @override
  Widget build(BuildContext context) {
    final examsProvider = Provider.of<ExamsProvider>(context);
    final List<Exam> exams = examsProvider.exams;

    return SizedBox(
      height: 650,
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
              itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                value: exams[index],
                child: const ExamCard(),
              ),
              itemCount: exams.length,
            ),
    );
  }
}
