import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_mangment/logic/calender_controller.dart';
import 'package:task_mangment/model/task_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Stream<List<TaskModel>> _tasksStream;
  List<TaskModel> _selectedTasks = [];
  DateTime _selectedDay = DateTime.now();

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void initState() {
    super.initState();
    _selectedTasks = [];
    _selectedDay = DateTime.now();
    _tasksStream =
        CalenderController.getUserTasksByDateToCalender(userId: widget.userId);
  }


  Map<DateTime, List<TaskModel>> groupTasks(List<TaskModel> tasks) {
    final Map<DateTime, List<TaskModel>> groupedTasks = {};
    for (final task in tasks) {
      final key = DateTime(
        task.createdAt.toDate().year,
        task.createdAt.toDate().month,
        task.createdAt.toDate().day,
      );
      if (groupedTasks[key] == null) {
        groupedTasks[key] = [];
      }
      groupedTasks[key]!.add(task);
    }
    return groupedTasks;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<TaskModel>>(
            stream: _tasksStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tasks = snapshot.data!;
                final groupedTasks = CalenderController.groupTasks(tasks);
                final selectedTasks = _selectedDay == null
                    ? []
                    : groupedTasks[_selectedDay] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TableCalendar(
                      daysOfWeekHeight: 50,
                      firstDay: DateTime.utc(2022, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _selectedDay,
                      calendarFormat: CalendarFormat.month,
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          setState(() {
                            _selectedDay = focusedDay;
                            // _selectedDay = selectedDay;
                            // _tasksStream = CalenderController.getTasksForDay(
                            //     selectedDay, widget.userId);
                          });
                        }
                      },
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      selectedDayPredicate: (day) {
                        // Retrieve the events for the selected day
                        final eventsForDay = groupedTasks[day];
                        // Return true if there are events for the selected day
                        return eventsForDay != null && eventsForDay.isNotEmpty;
                      },
                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey,
                        child: ListView.builder(
                          itemCount: selectedTasks.length,
                          itemBuilder: (context, index) {
                            final task = selectedTasks[index];
                            return ListTile(
                              title: Text(
                                task.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                task.description,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
