import 'dart:async';

import 'package:face_recognization_demo/constants/routes_constants.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{


  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  startTimer()async{
    Future.delayed(const Duration(seconds: 3), () {
      Get.toNamed(RouteConstants.homeRoute);
    });
  }

}