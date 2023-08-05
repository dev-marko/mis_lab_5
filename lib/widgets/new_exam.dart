import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/exam.dart';
import '../providers/exams_provider.dart';

class NewExam extends StatefulWidget {
  const NewExam({super.key});

  @override
  State<NewExam> createState() => _NewExamState();
}

class _NewExamState extends State<NewExam> {
  final _subjectNameController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _submitExam() async {
    if (_subjectNameController.text.isEmpty) {
      return;
    }

    final String enteredSubjectName = _subjectNameController.text;

    if (enteredSubjectName.isEmpty || _selectedDate == null) {
      return;
    }

    await Provider.of<ExamsProvider>(context, listen: false)
        .addExam(Exam(subjectName: enteredSubjectName, date: _selectedDate!));

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((value) => {
          if (value != null)
            {
              setState(() {
                _selectedDate = value;
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Subject Name'),
              controller: _subjectNameController,
              onSubmitted: (_) => _submitExam(),
            ),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'No Date Chosen!'
                        : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate!)}',
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: _submitExam,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: const Text('Add Exam'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
