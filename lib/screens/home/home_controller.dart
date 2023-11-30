import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  var image1 = regula.MatchFacesImage();
  var image2 = regula.MatchFacesImage();
  var similarity = "".obs;
  var liveNess = "".obs;

  Uint8List? img1, img2;
  var isFirstImgPicked = false.obs;
  var isSecondImgPicked = false.obs;

  @override
  void onInit() {
    super.onInit();
    getImgLink();
    initPlatformState();
    const EventChannel('flutter_face_api/event/video_encoder_completion')
        .receiveBroadcastStream()
        .listen((event) {
      var response = jsonDecode(event);
      String transactionId = response["transactionId"];
      bool success = response["success"];
      log("video_encoder_completion:");
      log("    success: $success");
      log("    transactionId: $transactionId");
    });
  }

  var base64 = "".obs;
  var imgUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Rohit_Sharma_during_the_India_vs_Australia_4th_Test_match_at_Narendra_Modi_Stadium.jpg/640px-Rohit_Sharma_during_the_India_vs_Australia_4th_Test_match_at_Narendra_Modi_Stadium.jpg";

  getImgLink() async {
    http.Response response = await http.get(
      Uri.parse(imgUrl),
    );
    img1 = response.bodyBytes;
    base64.value = base64Encode(response.bodyBytes);
    log("base64: ${base64.value}");
    image1.bitmap = base64.value;
    image1.imageType = regula.ImageType.LIVE;

    log(image1.bitmap.toString());
    liveNess.value = "";
  }

  Future<void> initPlatformState() async {
    regula.FaceSDK.init().then((json) {
      var response = jsonDecode(json);
      if (!response["success"]) {
        log("Init failed: ");
        log(json);
      }
    });
  }

  //get image from camera
  getImgFromCamera(bool flag) {
    regula.FaceSDK.presentFaceCaptureActivity().then((result) => setImage(
        flag,
        base64Decode(regula.FaceCaptureResponse.fromJson(json.decode(result))!
            .image!
            .bitmap!
            .replaceAll("\n", "")),
        regula.ImageType.LIVE));
    Get.back();
  }

  //get image from gallery
  getImageFromGallery(bool flag) {
    Get.back();
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) => {
          setImage(flag, io.File(value!.path).readAsBytesSync(),
              regula.ImageType.PRINTED)
        });
  }

  //set image
  setImage(bool first, Uint8List? imageFile, int type) {
    if (imageFile == null) return;
    similarity.value = "";
    log("type: $type");
    if (first) {
      isFirstImgPicked.value = true;
      getImgLink();
      // img1 = imageFile;
      // image1.bitmap = base64Encode(imageFile);
      log("base64: ${base64.value}");
      image1.bitmap = base64.value;
      image1.imageType = type;

      log(image1.bitmap.toString());
      liveNess.value = "";
    } else {
      isSecondImgPicked.value = true;
      img2 = imageFile;
      image2.bitmap = base64Encode(imageFile);
      image2.imageType = type;
      log(image2.bitmap.toString());
    }
  }

  //match both faces
  matchFaces() {
    if (image1.bitmap == null ||
        image1.bitmap == "" ||
        image2.bitmap == null ||
        image2.bitmap == "") {
      log("if${image1.bitmap}\n new line ${image2.bitmap}");
    } else {
      similarity.value = "Processing...";
      log("processing");
      var request = regula.MatchFacesRequest();
      request.images = [image1, image2];
      regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
        var response = regula.MatchFacesResponse.fromJson(json.decode(value));
        regula.FaceSDK.matchFacesSimilarityThresholdSplit(
                jsonEncode(response!.results), 0.75)
            .then((str) {
          var split = regula.MatchFacesSimilarityThresholdSplit.fromJson(
              json.decode(str));
          for (int i = 0; i<split!.matchedFaces.length; i++){
            log("log: ${split.matchedFaces[i]!.first!.image!.identifier}");
          }
          if (split.matchedFaces.isNotEmpty) {
            similarity.value =
                ("${(split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)}% Matched");
          } else {
            similarity.value = "Not Matched";
          }
        });
      });
    }
  }

  // detect face
  detectFace() {
    if (image1.bitmap == null ||
        image1.bitmap == "" ||
        image2.bitmap == null ||
        image2.bitmap == "") {
      log("if${image1.bitmap}\n new line ${image2.bitmap}");
    } else {
      similarity.value = "Processing...";
      log("processing");
      var request = regula.MatchFacesRequest();
      request.images = [image1, image2];
      regula.FaceSDK.detectFaces(jsonEncode(request)).then((value) {
        var response = regula.DetectFacesResponse.fromJson(json.decode(value));
        log(response!.allDetections.toString());
      });
    }
  }

  //check liveNess
  checkLiveNess() => regula.FaceSDK.startLiveness().then((value) {
        var result = regula.LivenessResponse.fromJson(json.decode(value));
        setImage(true, base64Decode(result!.bitmap!.replaceAll("\n", "")),
            regula.ImageType.LIVE);
        liveNess.value = result.liveness == regula.LivenessStatus.PASSED
            ? "passed"
            : "unknown";
      });

  //clear results
  clearResults() {
    img1 = null;
    img2 = null;
    isFirstImgPicked(false);
    isSecondImgPicked(false);
    similarity.value = "";
    liveNess.value = "";
    image1 = regula.MatchFacesImage();
    image2 = regula.MatchFacesImage();
  }

  //show picker dialog
  showDialog(bool isFirst) {
    Get.bottomSheet(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Camera"),
              leading: const Icon(Icons.camera_alt),
              onTap: () {
                getImgFromCamera(isFirst);
              },
            ),
            ListTile(
              title: const Text("Gallery"),
              leading: const Icon(Icons.image),
              onTap: () {
                getImageFromGallery(isFirst);
              },
            )
          ],
        ),
        backgroundColor: Colors.white);
  }
}
