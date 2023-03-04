import 'package:flutter/material.dart';
import 'package:mis_lab_4/providers/exams_provider.dart';
import 'package:mis_lab_4/widgets/exam_list.dart';
import 'package:mis_lab_4/widgets/new_exam.dart';
import 'package:provider/provider.dart';

class ExamsScreen extends StatefulWidget {
  static const String routeName = '/exams';

  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ExamsProvider>(context).fetchExams().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Exams & Midterms'),
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  ExamList(),
                ],
              ),
            ),
    );
  }
}
