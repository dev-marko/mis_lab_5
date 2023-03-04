import 'package:flutter/material.dart';

import 'package:mis_lab_4/providers/exams_provider.dart';
import 'package:mis_lab_4/widgets/exam_card.dart';
import 'package:provider/provider.dart';

class ExamList extends StatelessWidget {
  const ExamList({super.key});

  @override
  Widget build(BuildContext context) {
    final examsProvider = Provider.of<ExamsProvider>(context);
    final List<Exam> exams = examsProvider.exams;

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
              itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                value: exams[index],
                child: const ExamCard(),
              ),
              itemCount: exams.length,
            ),
    );
  }
}
