import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/shared_widgets/custom_circle_image.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

import '../../../../../shared_widgets/custom_appbar.dart';
import '../controller /setting_cubit.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingCubit()..getAllUsers(),
      child: const Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppbar(
          title: 'All Employee',
          action: [],
        ),
        body: EmployeeListBody(),
      ),
    );
  }
}

class EmployeeListBody extends StatelessWidget {
  const EmployeeListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      builder: (BuildContext context, state) {
        if (state is EmployeeLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is EmployeeLoadedState) {
          final users = state.users;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final userData = users[index].data()! as Map<String, dynamic>;
              final userName = userData['username'] as String;
              final userPosition = userData['position'] ?? '';
              final userImage = userData['profileImageUrl'] ?? '';

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12)
                        .r,
                child: Container(
                  padding: const EdgeInsets.all(16).r,
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
                          width: 55.r,
                          height: 55.r,
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
                            Text(userName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.black)),
                            Text(userPosition,
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is EmployeeErrorState) {
          return Center(
            child: Text(state.error.toString()),
          );
        } else {
          return Text('Nothing ');
        }
      },
    );
  }
}
