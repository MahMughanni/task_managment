import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:task_mangment/screens/main_layer/screens/add_task_screen/controller/add_task_cubit.dart';
import 'package:task_mangment/screens/main_layer/screens/add_task_screen/controller/add_task_state.dart';
import 'package:task_mangment/screens/main_layer/screens/add_task_screen/widgets/custom_drop_down.dart';
import 'package:task_mangment/screens/main_layer/screens/add_task_screen/widgets/create_task_body_widget.dart';
import 'package:task_mangment/shared_widgets/custom_button.dart';
import 'package:task_mangment/shared_widgets/custom_form_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late AddTaskCubit addTaskCubit;

  @override
  void initState() {
    super.initState();
    addTaskCubit = BlocProvider.of<AddTaskCubit>(context);
    addTaskCubit.init();
  }

  @override
  void dispose() {
    super.dispose();
    addTaskCubit.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var addTaskCubit = context.read<AddTaskCubit>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white54,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Create Task',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: ListView(children: [
        Form(
          key: _formKey,
          child: BlocBuilder<AddTaskCubit, AddTaskState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    8.verticalSpace,
                    CustomTextFormField(
                      focus: (_) => FocusScope.of(context).nearestScope,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'enter valid title';
                        }
                        return null;
                      },
                      labelText: 'Task Title',
                      hintText: '',
                      controller: addTaskCubit.titleController,
                    ),
                    4.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomDropDown(
                        onChanged: (value) => setState(
                            () => addTaskCubit.selectedDropdownValue = value!),
                        dropDownValue: addTaskCubit.selectedDropdownValue,
                        items: const [
                          DropdownMenuItem(
                              value: 'Upcoming', child: Text('Upcoming')),
                          DropdownMenuItem(
                              value: 'Today', child: Text('Today')),
                          // DropdownMenuItem(
                          //     value: 'Completed', child: Text('Completed') ,
                          // ),
                        ],
                      ),
                    ),
                    8.verticalSpace,
                    CreateTaskBody(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'enter valid text';
                        }
                        return null;
                      },
                      descriptionController: addTaskCubit.descriptionController,
                      onTap: addTaskCubit.pickImages,
                      startTimeController: addTaskCubit.startTimeController,
                      endTimeController: addTaskCubit.endTimeController,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await addTaskCubit.pickImages();
                      },
                      child: CustomTextFormField(
                        focus: (_) => FocusScope.of(context).nearestScope,
                        suffixIcon: const Icon(Icons.link_sharp),
                        enabled: false,
                        hintText: '',
                        labelText: 'Attach files',
                      ),
                    ),
                    4.verticalSpace,
                    if (addTaskCubit.imageFiles.isNotEmpty)
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 4,
                        clipBehavior: Clip.antiAlias,
                        children: [
                          ...addTaskCubit.imageFiles.map(
                            (imageFile) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0).r,
                                  child: Image.file(
                                    imageFile,
                                    fit: BoxFit.cover,
                                    width: 150.r,
                                    height: 150.r,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      addTaskCubit.removeImage(imageFile);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    8.verticalSpace,
                    Stack(
                      children: [
                        CustomButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              addTaskCubit.uploadTask(
                                title: addTaskCubit.titleController.text
                                    .toString()
                                    .trim(),
                                description: addTaskCubit
                                    .descriptionController.text
                                    .toString()
                                    .trim(),
                                startTime: addTaskCubit.startTimeController.text
                                    .toString()
                                    .trim(),
                                endTime: addTaskCubit.endTimeController.text
                                    .toString()
                                    .trim(),
                              );
                            }
                          },
                          title: 'Upload',
                          width: double.infinity,
                          height: 42.h,
                        ),
                        if (addTaskCubit.isUploading)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
