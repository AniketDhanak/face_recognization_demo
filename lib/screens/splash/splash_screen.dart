import 'package:face_recognization_demo/constants/app_colors.dart';
import 'package:face_recognization_demo/constants/controller_constants.dart';
import 'package:face_recognization_demo/constants/string_constants.dart';
import 'package:face_recognization_demo/screens/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SplashController controller = Get.find(tag: ControllerTagConstants.splashControllerTag);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColors.white,
        child: const Text(StringConstants.title,
        style: TextStyle(color: AppColors.primaryColor,
        fontSize: 24),),
      ),
    );
  }
}
