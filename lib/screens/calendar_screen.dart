import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:mis_lab_4/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';

import '../providers/exams_provider.dart';
import '../widgets/exam_card.dart';
import '../widgets/new_exam.dart';
import '../models/exam.dart';

class CalendarScreen extends StatefulWidget {
  static const String routeName = '/calendar';
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  late final ValueNotifier<List<Exam>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final DateTime _firstDay = DateTime(2020);
  final DateTime _lastDay = DateTime(2030);

  Map<DateTime, List<Exam>>? _examsMap;

  void _showAddExam(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return const NewExam();
      },
    );
  }

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

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Exam> _getEventsForDay(DateTime day) {
    return _examsMap?[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = [];
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _refresh() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ExamsProvider>(context, listen: false).fetchExams().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final examsProvider = Provider.of<ExamsProvider>(context);
    _examsMap = LinkedHashMap<DateTime, List<Exam>>(
      equals: isSameDay,
      hashCode: (DateTime key) =>
          key.day * 1000000 + key.month * 10000 + key.year,
    )..addAll(examsProvider.examsMap);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Exams & Midterms'),
        actions: [
          IconButton(
              onPressed: _refresh,
              icon: Icon(Icons.refresh,
                  color: Theme.of(context).colorScheme.secondary)),
          IconButton(
            onPressed: () => _showAddExam(context),
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          TableCalendar<Exam>(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(
            height: 8.0,
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ValueListenableBuilder<List<Exam>>(
                    valueListenable: _selectedEvents,
                    builder: (context, exams, _) {
                      return ListView.builder(
                        key: UniqueKey(),
                        itemBuilder: (context, index) =>
                            ChangeNotifierProvider.value(
                          key: UniqueKey(),
                          value: exams[index],
                          child: const ExamCard(),
                        ),
                        itemCount: exams.length,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
