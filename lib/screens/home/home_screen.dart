import 'package:face_recognization_demo/constants/app_colors.dart';
import 'package:face_recognization_demo/constants/controller_constants.dart';
import 'package:face_recognization_demo/screens/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController controller =
        Get.find(tag: ControllerTagConstants.homeController);
    return Obx(() => Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  // !controller.isFirstImgPicked.value ?
                  // imgPickerWidget(true, controller),
                  Image.network(controller.imgUrl, height: 200, width: 200,),
                  const SizedBox(
                    height: 30,
                  ),
                  !controller.isSecondImgPicked.value?
                  imgPickerWidget(false, controller):
                  Image.memory(controller.img2!, height: 200,width: 200,),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            controller.getImgLink();
                            controller.matchFaces();
                            // controller.detectFace();

                          },
                          child: const Text(
                            "Match",
                            style: TextStyle(fontSize: 18),
                          ))),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            controller.clearResults();
                          },
                          child: const Text(
                            "Clear",
                            style: TextStyle(fontSize: 18),
                          ))),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Result: ${controller.similarity.value}",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )),
    ));
  }

  Widget imgPickerWidget(bool isFirst, HomeController controller) {
    return GestureDetector(
      onTap: (){
        controller.showDialog(isFirst);
      },
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: const Icon(
          Icons.camera_alt,
          color: Colors.grey,
          size: 84,
        ),
      ),
    );
  }
}
