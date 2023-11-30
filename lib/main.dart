import 'package:face_recognization_demo/bindings/all_controller_bindings.dart';
import 'package:face_recognization_demo/constants/app_colors.dart';
import 'package:face_recognization_demo/constants/font_constants.dart';
import 'package:face_recognization_demo/constants/routes_constants.dart';
import 'package:face_recognization_demo/constants/string_constants.dart';
import 'package:face_recognization_demo/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: StringConstants.title,
      theme: ThemeData(
          primarySwatch: AppColors.primaryColor.toMaterialColor(),
          fontFamily: FontConstants.poppins
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteConstants.initialRoute,
      initialBinding: AllControllerBindings(),
      getPages: AppRoutes.routes,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}

