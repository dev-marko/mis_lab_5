import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/exam.dart';
import '../providers/exams_provider.dart';
import 'exam_card.dart';
import 'new_exam.dart';

class ExamList extends StatelessWidget {
  const ExamList({super.key});

  void _showAddExam(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return const NewExam();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final examsProvider = Provider.of<ExamsProvider>(context);
    final List<Exam> exams = examsProvider.exams;

    return Column(
      children: [
        SizedBox(
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
        ),
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () => _showAddExam(context),
            child: const Text('Add New Exam'),
          ),
        ),
      ],
    );
  }
}
