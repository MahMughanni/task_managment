import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_mangment/logic/calender_controller.dart';
import 'package:task_mangment/user/main_layer/screens/task_details_screen/task_details_screen.dart';
import 'package:task_mangment/shared_widgets/list_item_body.dart';
import 'controller/calendar_cubit.dart';

class CalendarScreen extends StatefulWidget {
  final String userId, userName;

  const CalendarScreen({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalenderCubit _calenderCubit;

  @override
  void initState() {
    super.initState();
    _calenderCubit = CalenderCubit(
      userId: widget.userId,
      calenderController: CalendarController(),
    )..init();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userId);
    print(widget.userName);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
        'Calendar Screen',
        style: Theme.of(context).textTheme.titleLarge,
      )),
      body: BlocBuilder<CalenderCubit, CalenderState>(
        bloc: _calenderCubit,
        builder: (context, state) {
          return state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TableCalendar(
                    daysOfWeekHeight: 50,
                    firstDay: DateTime.utc(2022, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: DateTime.now(),
                    calendarFormat: CalendarFormat.month,
                    onDaySelected: (selectedDay, focusedDay) {
                      _calenderCubit.onDaySelected(selectedDay);
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
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, day, focusedDay) {
                        bool hasTasksForSelectedDay =
                            state.groupedTasks.containsKey(day);
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: hasTasksForSelectedDay
                                ? Colors.orangeAccent
                                : Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                      defaultBuilder: (context, day, focusedDay) {
                        bool hasTasksForSelectedDay =
                            state.groupedTasks.containsKey(day);
                        return Container(
                          alignment: Alignment.center,
                          decoration: hasTasksForSelectedDay
                              ? BoxDecoration(
                                  color: Colors.orangeAccent.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                )
                              : null,
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: hasTasksForSelectedDay
                                  ? Colors.orangeAccent
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    headerStyle: const HeaderStyle(
                        titleCentered: true, formatButtonVisible: false),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tasks',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.black, fontSize: 18.sp),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: state.selectedTasks.isNotEmpty
                          ? ListView.builder(
                              itemCount: state.selectedTasks.length,
                              itemBuilder: (context, index) {
                                final task = state.selectedTasks[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskDetailsScreen(
                                          task: task,
                                          userName: widget.userName ?? '',
                                          userId: widget.userId ?? '',
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListViewItemBody(
                                    userName: task.title,
                                    taskCategory: task.state,
                                    startTime: task.startTime.toString(),
                                    title: task.description,
                                    url: task.imageUrls.isNotEmpty
                                        ? task.imageUrls.first
                                        : '',
                                    status: task.state,
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text('No Selected Day, No Tasks'),
                            ),
                    ),
                  )
                ]);
        },
      ),
    );
  }
}
