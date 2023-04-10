import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/screens/main_layer/screens/setting_screen/pages/widgets/profile_body.dart';
import 'package:task_mangment/shared_widgets/custom_appbar.dart';
import 'package:task_mangment/shared_widgets/custom_button.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key, required this.path}) : super(key: key);
  final String path;

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
    _newImage = File('');
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
    debugPrint(widget.path);
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
                initialData: [],
                isEnabled: true,
                screen: 'edit',
                userNameController: userNameController,
                phoneController: phoneController,
                positionController: positionController,
                newImage: _newImage,
                imageUrl: urlImage,
              ),
              24.ph,
              CustomButton(
                  onPressed: () async {
                    debugPrint(userNameController.text.toString());
                    debugPrint(phoneController.text.toString());
                    debugPrint(positionController.text.toString());

                    if (formKey.currentState!.validate()) {
                      try {
                        await FireBaseController.editUserInfo(
                          userName: userNameController.text.trim(),
                          phone: phoneController.text.trim(),
                          position: positionController.text.trim(),
                          newImage: _newImage,
                        );

                        debugPrint('Edit Success');
                        AppRouter.goToAndRemove(
                            screenName: NamedRouter.mainScreen);
                      } catch (error) {
                        debugPrint("Edit error $error");
                        // handle error
                      }
                    }
                  },
                  title: 'Save',
                  width: screenSize.width * .8,
                  height: screenSize.height * .06),
            ],
          ),
        ),
      ),
    );
  }
}
