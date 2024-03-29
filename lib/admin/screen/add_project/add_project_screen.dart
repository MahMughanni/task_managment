import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/shared_widgets/custom_button.dart';
import 'package:task_management/shared_widgets/custom_form_field.dart';
import 'package:task_management/user/main_layer/screens/add_task_screen/controller/add_task_cubit.dart';
import 'package:task_management/user/main_layer/screens/add_task_screen/controller/add_task_state.dart';
import 'package:task_management/user/main_layer/screens/add_task_screen/widgets/create_task_body_widget.dart';
import 'package:task_management/utils/utils_config.dart';

class AddProjectScreen extends StatelessWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskCubit(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white54,
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Text(
            'Create project',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: const AddProjectScreenBody(),
      ),
    );
  }
}

class AddProjectScreenBody extends StatefulWidget {
  const AddProjectScreenBody({Key? key}) : super(key: key);

  @override
  State<AddProjectScreenBody> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreenBody> {
  late AddTaskCubit addTaskCubit;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    addTaskCubit = BlocProvider.of<AddTaskCubit>(context);
    addTaskCubit.init();
    super.initState();
  }

  @override
  void dispose() {
    addTaskCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
          key: _formKey,
          child: BlocBuilder<AddTaskCubit, AddTaskState>(
            builder: (context, state) {
              final addTaskCubit = context.read<AddTaskCubit>();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    8.verticalSpace,
                    CustomTextFormField(
                      focus: (_) => FocusScope.of(context).nearestScope,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid title';
                        }
                        return null;
                      },
                      labelText: 'Project Title',
                      hintText: '',
                      controller: addTaskCubit.titleController,
                    ),
                    8.verticalSpace,
                    GestureDetector(
                      onTap: () {
                        UtilsConfig.showBottomSheet(Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(
                                height: 150.h,
                                child: ListView.builder(
                                  itemCount: addTaskCubit.projectStatus.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      title: Text(
                                        addTaskCubit.projectStatus[index]
                                            .toString()
                                            .toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(color: Colors.black),
                                      ),
                                      onTap: () {
                                        var project = addTaskCubit
                                                .selectedDropdownValueController
                                                .text =
                                            addTaskCubit.projectStatus[index];
                                        addTaskCubit
                                            .updateAdminProjectDropdownValue(
                                                project.toString());
                                        Navigator.pop(
                                            context); // Close the bottom sheet
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ));
                      },
                      child: CustomTextFormField(
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 30,
                        ),
                        enabled: false,
                        labelText: 'Select Status',
                        focus: (_) => FocusScope.of(context).nearestScope,
                        controller:
                            addTaskCubit.selectedDropdownValueController,
                        hintText: 'Select Status',
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        onChanged: (val) {},
                        validator: (value) {
                          return addTaskCubit.selectedDropdownProjectValue ==
                                  null
                              ? ""
                              : null;
                        },
                      ),
                    ),
                    8.verticalSpace,
                    CreateTaskBody(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid text';
                        }
                        return null;
                      },
                      descriptionController: addTaskCubit.descriptionController,
                      startTimeController: addTaskCubit.startTimeController,
                      endTimeController: addTaskCubit.endTimeController,
                      descriptionTitle: 'Project Description',
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
                                      child: Icon(
                                        Icons.close,
                                        size: 18.r,
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
                              addTaskCubit.createProject(
                                title: addTaskCubit.titleController.text.trim(),
                                description: addTaskCubit
                                    .descriptionController.text
                                    .trim(),
                                startTime: addTaskCubit.startTimeController.text
                                    .trim(),
                                endTime:
                                    addTaskCubit.endTimeController.text.trim(),
                              );
                            }
                          },
                          title: 'Create project',
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
      ],
    );
  }
}
