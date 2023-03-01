import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExam extends StatefulWidget {
  final Function addNewExamHandler;

  const NewExam({
    super.key,
    required this.addNewExamHandler,
  });

  @override
  State<NewExam> createState() => _NewExamState();
}

class _NewExamState extends State<NewExam> {
  final _subjectNameController = TextEditingController();
  DateTime? _selectedDate;

  void _submitExam() {
    if (_subjectNameController.text.isEmpty) {
      return;
    }

    final String enteredSubjectName = _subjectNameController.text;

    if (enteredSubjectName.isEmpty || _selectedDate == null) {
      return;
    }

    widget.addNewExamHandler(
      enteredSubjectName,
      _selectedDate,
    );

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
