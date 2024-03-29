import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/logic/firebase_controller.dart';
import 'package:task_management/core/routes/app_router.dart';
import 'package:task_management/core/routes/named_router.dart';
import 'package:task_management/user/main_layer/screens/setting_screen/pages/widgets/profile_body.dart';
import 'package:task_management/shared_widgets/custom_appbar.dart';
import 'package:task_management/shared_widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(
      {Key? key, required this.path, required this.userRole})
      : super(key: key);
  final String path, userRole;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final bool isEnabled = false;
  late File? _newImage;

  late TextEditingController userNameController;
  late TextEditingController phoneController;
  late TextEditingController positionController;
  late String? urlImage;

  @override
  void initState() {
    userNameController = TextEditingController();
    phoneController = TextEditingController();
    positionController = TextEditingController();
    _newImage = null;
    urlImage = widget.path;

    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    phoneController.dispose();
    positionController.dispose();
    super.dispose();
  }

  var formKey = GlobalKey<FormState>();

  Future<File?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final path = result.files.single.path!;
      return File(path);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppbar(
          title: 'Edit Profile',
          action: [],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ProfileBodyScreen(
                onTap: () async {
                  final newImage = await pickImage();
                  if (newImage != null) {
                    setState(() {
                      _newImage = newImage;
                      urlImage = null;
                    });
                  }
                },
                initialData: const ['', ''],
                isEnabled: true,
                screen: 'edit',
                userNameController: userNameController,
                phoneController: phoneController,
                positionController: positionController,
                newImage: _newImage ?? File(widget.path),
                imageUrl: urlImage,
              ),
              24.verticalSpace,
              CustomButton(
                onPressed: () async {
                  if (userNameController.text.isEmpty &&
                      phoneController.text.isEmpty &&
                      positionController.text.isEmpty) {
                    try {
                      await FireBaseRepository.editProfileImage(_newImage);
                      AppRouter.goToAndRemove(
                        routeName: NamedRouter.mainScreen,
                        arguments: widget.userRole,
                      );
                      debugPrint(_newImage?.path.toString() ?? '');
                    } catch (error) {
                      debugPrint(error.toString());
                    }
                  } else if (formKey.currentState!.validate()) {
                    try {
                      await FireBaseRepository.editUserInfo(
                          userName: userNameController.text.trim(),
                          phone: phoneController.text.trim(),
                          position: positionController.text.trim(),
                          newImage: _newImage);

                      debugPrint('Edit Success');
                      AppRouter.goToAndRemove(
                        routeName: NamedRouter.mainScreen,
                        arguments: widget.userRole,
                      );
                    } catch (error) {
                      debugPrint("Edit error $error");
                      // handle error
                    }
                  }
                },
                title: 'Save',
                width: screenSize.width * .8,
                height: screenSize.height * .06,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
