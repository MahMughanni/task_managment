import 'package:flutter/material.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/screens/main_layer/screens/task_details_screen/widgets/custom_rich_text.dart';
import 'package:task_mangment/shared_widgets/custom_appbar.dart';
import 'package:task_mangment/shared_widgets/custom_form_field.dart';
import 'package:task_mangment/utils/app_constants.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

class TaskDetailsScreen extends StatelessWidget {
  TaskDetailsScreen({Key? key, required this.task, required this.userName})
      : super(key: key);

  final String userName;
  final TaskModel task;

  final user = FireBaseRepository.getUserInfo();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontWeight: AppConstFontWeight.regular,
      fontSize: 22,
    );
    // print(user.toString());
    return SafeArea(
      child: Scaffold(
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
                Text(
                  task.title.toString(),
                  style: TextStyle(
                    fontWeight: AppConstFontWeight.semiBold,
                    fontSize: 22,
                    color: ColorConstManger.primaryColor.withOpacity(.7),
                  ),
                ),
                10.ph,
                Text(
                  task.state.toString(),
                  style: style,
                ),
                10.ph,
                CustomDetailsRichText(
                  title: 'Uploaded by   ',
                  titleStyle: style,
                  subTitle: userName,
                ),
                CustomDetailsRichText(
                  title: 'Uploaded on  ',
                  titleStyle: style,
                  subTitle: task.startTime.toString(),
                  subTitleStyle: style.copyWith(
                    color: Colors.blueAccent,
                    fontSize: 18,
                    fontWeight: AppConstFontWeight.light,
                  ),
                ),
                CustomDetailsRichText(
                  title: 'Dead line  ',
                  titleStyle: style,
                  subTitle: task.endTime.toString(),
                  subTitleStyle: style.copyWith(
                    color: Colors.blueAccent,
                    fontSize: 18,
                    fontWeight: AppConstFontWeight.light,
                  ),
                ),
                16.ph,
                Text(
                  'Task Description ',
                  style: style.copyWith(
                    fontSize: 20,
                    fontWeight: AppConstFontWeight.light,
                  ),
                ),
                16.ph,
                CustomTextFormField(
                  enabled: false,
                  initialValue: task.description.toString(),
                  maxLine: 10,
                  keyboardType: TextInputType.multiline,
                  hintText: '',
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: task.imageUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 8,
                        ),
                        child: Container(
                          width: 120,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(task.imageUrls[index]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
