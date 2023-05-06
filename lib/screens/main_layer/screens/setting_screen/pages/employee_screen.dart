import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/shared_widgets/custom_circle_image.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

import '../../../../../shared_widgets/custom_appbar.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppbar(
        title: 'All Employee',
        action: [],
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: FireBaseRepository.getAllUsers(),
        builder: (BuildContext context,
            AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final userData =
                    snapshot.data![index].data()! as Map<String, dynamic>;
                final userName = userData['username'] as String;
                final userPosition = userData['position'] ?? '';
                final userImage = userData['profileImageUrl'] ?? '';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(-4, 6),
                          color: Colors.grey.shade100,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCircleImage(
                            image: userImage,
                            width: 90,
                            height: 90,
                          ),
                          16.pw,
                          const VerticalDivider(
                            color: Colors.grey,
                            thickness: .7,
                          ),
                          16.pw,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontFamily: "Cairo",
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                userPosition,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.blueAccent),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
