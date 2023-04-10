import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/screens/main_layer/screens/setting_screen/pages/edit_profile.dart';
import 'package:task_mangment/screens/main_layer/screens/setting_screen/pages/widgets/profile_body.dart';
import 'package:task_mangment/shared_widgets/custom_appbar.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  final bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppbar(
        title: 'Edit Profile',
        action: [],
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
                return ProfileBodyScreen(initialData: [
                  userData.email.toString(),
                  userData.password.toString(),
                  userData.phone.toString(),
                  userData.position.toString(),
                ]);
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
