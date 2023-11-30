import 'package:face_recognization_demo/constants/routes_constants.dart';
import 'package:face_recognization_demo/screens/home/home_screen.dart';
import 'package:face_recognization_demo/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: RouteConstants.initialRoute, page: ()=> const SplashScreen()),
    GetPage(name: RouteConstants.homeRoute, page: ()=> const HomeScreen())
  ];
}