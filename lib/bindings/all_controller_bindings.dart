import 'package:face_recognization_demo/constants/controller_constants.dart';
import 'package:face_recognization_demo/screens/home/home_controller.dart';
import 'package:face_recognization_demo/screens/splash/splash_controller.dart';
import 'package:get/get.dart';

class AllControllerBindings extends Bindings{
  @override
  void dependencies() {

    Get.lazyPut<SplashController>(() => SplashController(),
        tag: ControllerTagConstants.splashControllerTag, fenix: true);

    Get.lazyPut<HomeController>(() => HomeController(),
        tag: ControllerTagConstants.homeController, fenix: true);

  }

}