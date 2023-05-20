import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_mangment/admin/screen/add_project/add_project_screen.dart';
import 'package:task_mangment/admin/screen/add_project/controller/project_cubit.dart';
import 'package:task_mangment/shared_widgets/custom_appbar.dart';
import 'package:task_mangment/utils/app_constants.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  late ProjectCubit projectCubit;

  @override
  void initState() {
    projectCubit = ProjectCubit();
    projectCubit.loadProjects(projectCubit.user!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: ('Projects'),
        action: [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'My projects',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.black),
            ),
            BlocBuilder<ProjectCubit, ProjectState>(
              builder: (context, state) {
                print('state $state');
                if (state is ProjectsLoadingState) {
                  return const CircularProgressIndicator();
                } else if (state is ProjectLoadedState) {
                  final projects = state.projects;
                  print("project length ${projects.length}");
                  return Expanded(
                    child: ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (BuildContext context, int index) {
                        final project = projects[index];
                        return ProjectListBodyItem(
                          projectTitle: project.title,
                        );
                      },
                    ),
                  );
                } else if (state is ProjectFailure) {
                  return Text('Failed to load projects: ${state.error}');
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: MediaQuery.of(context).size.height * .12,
            right: 16.0,
            child: SizedBox(
              width: 46.0.r,
              height: 46.0.r,
              child: FloatingActionButton(
                backgroundColor: Colors.blueAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddProjectScreen()),
                  );
                },
                elevation: 6,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25.0.r,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ProjectListBodyItem extends StatelessWidget {
  const ProjectListBodyItem({Key? key, required this.projectTitle})
      : super(key: key);

  final String projectTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            projectTitle,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const Icon(Icons.done),
        ],
      ),
    );
  }
}
