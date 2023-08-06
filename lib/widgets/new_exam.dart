import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mis_lab_4/services/notification_service.dart';
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

    NotificationService().showNotification(
      title: "New Exam!",
      body: "$enteredSubjectName has been added to your calendar!",
    );

    NotificationService().scheduleNotification(
      title: "Reminder!",
      body: "$enteredSubjectName is happening in 30 minutes!",
      seconds: ((_selectedDate?.millisecondsSinceEpoch)! ~/
              Duration.millisecondsPerSecond) +
          1800,
    );

    Navigator.of(context).pop();
  }

  Future<void> _presentDateTimePicker() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selectedDate == null) return;

    if (!context.mounted) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    setState(() {
      selectedTime == null
          ? _selectedDate = selectedDate
          : _selectedDate = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
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
                        ? 'No Date & Time Chosen!'
                        : 'Picked Date: ${DateFormat.yMMMd().add_jm().format(_selectedDate!)}',
                  ),
                  TextButton(
                    onPressed: _presentDateTimePicker,
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
