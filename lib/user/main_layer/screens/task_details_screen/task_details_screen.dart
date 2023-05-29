import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/model/task_model.dart';
import 'package:task_management/user/main_layer/screens/task_details_screen/widgets/custom_rich_text.dart';
import 'package:task_management/shared_widgets/custom_appbar.dart';
import 'package:task_management/shared_widgets/custom_form_field.dart';
import 'package:task_management/utils/app_constants.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({
    Key? key,
    required this.task,
    required this.userId,
    required this.completedBy,
  }) : super(key: key);

  final String userId, completedBy;

  final TaskModel task;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool isTaskCompleted = false;
  String initialTaskState = '';

  @override
  void initState() {
    super.initState();
    print(' this is UserName ${widget.task.userName}');
    initialTaskState = widget.task.state;
    isTaskCompleted = initialTaskState == 'completed';
  }

  void _updateTaskState(bool isDone) {
    final taskCollection = FirebaseFirestore.instance.collection('users');

    setState(() {
      isTaskCompleted = isDone;
    });

    String? currentUser = FirebaseAuth.instance.currentUser?.displayName;

    taskCollection.get().then((querySnapshot) {
      for (var userDoc in querySnapshot.docs) {
        userDoc.reference
            .collection('tasks')
            .doc(widget.task.id) // Assuming you have a unique ID for each task
            .update({
          'state': isDone ? 'completed' : initialTaskState,
          'completedBy': currentUser,
        }).then((value) {
          print('Task state updated for user: ${userDoc.id}');
        }).catchError((error) {
          // Error occurred while updating task state
          print(
              'Failed to update task state for user: ${userDoc.id}, Error: $error');
        });
      }
    }).catchError((error) {
      // Error occurred while fetching user documents
      print('Failed to fetch user documents: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppbar(
        title: 'Task Details',
        action: [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.task.title.toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: ColorConstManger.primaryColor,
                      )),
              4.verticalSpace,
              Text(
                widget.task.state.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black),
              ),
              CustomDetailsRichText(
                title: 'Uploaded by   ',
                titleStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black),
                subTitle: widget.task.userName,
              ),
              CustomDetailsRichText(
                title: 'Uploaded on  ',
                titleStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black),
                subTitle: widget.task.startTime.toString(),
                subTitleStyle: Theme.of(context).textTheme.bodySmall,
              ),
              CustomDetailsRichText(
                  title: 'Dead line  ',
                  titleStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.black),
                  subTitle: widget.task.endTime.toString(),
                  subTitleStyle: Theme.of(context).textTheme.bodySmall),
              Text('Task Description ',
                  style: Theme.of(context).textTheme.bodyLarge),
              CustomTextFormField(
                enabled: false,
                initialValue: widget.task.description.toString(),
                maxLine: 6,
                keyboardType: TextInputType.multiline,
                hintText: '',
              ),
              widget.task.imageUrls.isNotEmpty
                  ? SizedBox(
                      height: 170.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: widget.task.imageUrls.length,
                        itemBuilder: (context, index) {
                          final imageUrl = widget.task.imageUrls[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 8)
                                .r,
                            child: Container(
                              width: 120.w,
                              height: 150.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9).r,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(imageUrl),
                                  onError: (_, __) => const AssetImage(
                                      ImageConstManger.logoImage),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(),
              widget.task.state == 'upcoming' || widget.task.state == 'today'
                  ? CheckboxListTile(
                      contentPadding: const EdgeInsets.all(16).r,
                      value: isTaskCompleted,
                      onChanged: (val) {
                        setState(() {
                          _updateTaskState(val ?? false);
                        });
                      },
                      title: Text(
                        'Mark as Done',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.black),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
