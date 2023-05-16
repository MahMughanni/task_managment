import 'package:flutter/material.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/user/main_layer/screens/setting_screen/pages/edit_profile.dart';
import 'package:task_mangment/user/main_layer/screens/setting_screen/pages/widgets/profile_body.dart';
import 'package:task_mangment/shared_widgets/custom_appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FireBaseRepository.getUserInfo2(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Scaffold(
                body: Text("An error occurred: ${snapshot.error}"),
              );
            }
            var userData = snapshot.data;

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: CustomAppbar(
                title: 'My Profile',
                action: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return EditProfileScreen(
                              path: userData.profileImageUrl,
                            );
                          },
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 25,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              body: ProfileBodyScreen(
                initialData: [
                  userData.userName,
                  userData.email,
                  userData.password,
                  userData.phone,
                  userData.position,
                ],
                screen: 'profile',
                imageUrl: userData.profileImageUrl,
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
