import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_mangment/shared_widgets/custom_circle_image.dart';
import 'package:task_mangment/utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  EmployeeDetailsScreen({Key? key, this.userData}) : super(key: key);
  final userData;

  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(-4, 6),
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height * .55,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: const EdgeInsets.only(top: 64).r,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0).r,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          32.verticalSpace,
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children: [
                                Text(
                                  userData['username'],
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  userData['position'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: const Color(0xffCD0404),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Contact info',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          8.verticalSpace,
                          Text(
                            'Email :',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            userData['email'] ?? ' ',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: const Color(0xff4B4B4B),
                                    ),
                          ),
                          Text(
                            'Phone number :',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            userData['phone'] ?? '',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: const Color(0xff4B4B4B),
                                    ),
                          ),
                          32.verticalSpace,
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomIconsButton(
                                  imagePath: SvgIconsConstManger.phone,
                                  onPressed: () async {
                                    final phone = userData['phone'];
                                    final url = Uri.parse('tel:$phone');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                ),
                                CustomIconsButton(
                                  imagePath: SvgIconsConstManger.whatsapp,
                                  onPressed: () async {
                                    final phone = userData['phone'];
                                    final url =
                                        Uri.encodeFull('https://wa.me/$phone');
                                    await launch(url);
                                  },
                                ),
                                CustomIconsButton(
                                  imagePath: SvgIconsConstManger.email,
                                  onPressed: () async {
                                    final recipientEmail = userData['email'];
                                    final uri = Uri.encodeFull(
                                        'mailto:$recipientEmail');

                                    final url = Uri.tryParse(uri);
                                    await launchUrl(url!);
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * .64,
                child: CustomCircleImage(
                  image: userData['profileImageUrl'],
                  width: 120.r,
                  height: 120.r,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomIconsButton extends StatelessWidget {
  const CustomIconsButton({Key? key, required this.imagePath, this.onPressed})
      : super(key: key);
  final String imagePath;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16).r,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: SvgPicture.asset(
          imagePath,
          width: 40.r,
          height: 40.r,
        ),
      ),
    );
  }
}
