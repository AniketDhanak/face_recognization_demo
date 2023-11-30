import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PickImage {
  static pickImageFromGallery() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      return imageFile;
    } else {
      log("Error");
    }
  }

  static captureImageFromCamera() async {
    final XFile? photo =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (photo != null) {
      File imageFile = File(photo.path);
      return imageFile;
    } else {
      log("Error");
    }
  }


  static pickMultipleImageFromGallery() async {
    final List<XFile> image =
    await ImagePicker().pickMultiImage();
    if (image != null) {
      List<File> imageFile = [];
      for(int i = 0 ; i <image.length ; i ++){
        imageFile.add(File(image[i].path));
      }
      return imageFile;
    } else {
      log("Error");
    }
  }


}
