import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/screens/main_layer/screens/setting_screen/pages/edit_profile.dart';
import 'package:task_mangment/screens/main_layer/screens/setting_screen/pages/widgets/profile_body.dart';
import 'package:task_mangment/shared_widgets/custom_appbar.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

import '../../../../../shared_widgets/custom_circle_image.dart';
import '../../../../../shared_widgets/custom_form_field.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  final bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: 'My Profile',
        action: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const EditProfileScreen();
              }));
            },
            icon: const Icon(
              Icons.edit,
              size: 25,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FireBaseController.getUserInfo(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text("An error occurred: ${snapshot.error}");
                }
                var userData = snapshot.data;
                return ProfileBodyScreen(
                  initialData: [
                    userData.email,
                    userData.password,
                    userData.phone,
                    userData.position,
                  ],
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
