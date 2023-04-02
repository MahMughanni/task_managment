import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/widgets/custom_sliver_appbar.dart';

import '../../../../shared_widgets/list_item_body.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        bottom: true,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverPersistentHeader(
                      delegate: MySliverAppBar(expandedHeight: 300))
                ];
              },
              body: TabBarView(
                children: [
                  ListView.builder(
                    itemCount: 50,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return const ListViewItemBody();
                    },
                  ),
                  ListView.builder(
                    itemCount: 2,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return const ListViewItemBody();
                    },
                  ),
                  ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return const ListViewItemBody();
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
