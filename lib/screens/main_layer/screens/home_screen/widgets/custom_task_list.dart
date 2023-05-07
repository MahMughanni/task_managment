import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/user_cubit.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/user_state.dart';
import '../../../../../model/task_model.dart';
import '../../../../../shared_widgets/list_item_body.dart';
import '../../task_details_screen/task_details_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTaskList extends StatelessWidget {
  const CustomTaskList({
    Key? key,
    required this.state,
    required this.label,
    required this.userName,
  }) : super(key: key);

  final String state;
  final String label;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, HomeState>(
      builder: (context, state) {
        if (state is UserLoadingState) {
          return Shimmer.fromColors(
              baseColor: Colors.grey[350]!,
              highlightColor: Colors.grey[200]!,
              child: const ListViewItemBody(
                title: '',
                startTime: '',
                userName: '',
                taskCategory: '',
                url: '',
              ));
        }
        if (state is UserErrorState) {
          return Center(child: Text('Error: ${state.error}'));
        }
        if (state is UserLoadedState) {
          final tasks = state.tasks;
          final stateTasks = tasks.where((task) => task.state == this.state).toList();
          return stateTasks.isNotEmpty
              ? Column(
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.blueAccent, fontSize: 14.sp),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: stateTasks.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailsScreen(
                            task: stateTasks[index],
                            userName: userName ?? '',
                          ),
                        ),
                      );
                    },
                    child: ListViewItemBody(
                        title: stateTasks[index].description,
                        startTime: stateTasks[index].startTime,
                        userName: stateTasks[index].title,
                        taskCategory: stateTasks[index].state,
                        url: stateTasks[index].imageUrls.isNotEmpty
                            ? stateTasks[index].imageUrls.first
                            : ''),
                  ),
                ),
              ),
            ],
          )
              : Container();
        }
        return Container(); // default return
      },
    );
  }
}
