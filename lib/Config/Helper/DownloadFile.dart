import 'dart:convert';
// import 'dart:html';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Widgets/Loader.dart';

import '../../Widgets/CommomBottomSheet.dart';
import '../Constant.dart';
import '../utils/Images.dart';

RxBool isDownloaded = true.obs;

class DownloadFile {
  String? filename;
  String? fileString;

  //BuildContext context;
  DownloadType? downloadType;
  String? url;

  DownloadFile({this.fileString, this.filename, this.url, this.downloadType = DownloadType.URL}) {
    if (downloadType == DownloadType.BASE64) {
      assert(fileString!.isNotEmpty && filename!.isNotEmpty);
      _permissionHandler(_convertBase64ToFile);
    } else if (downloadType == DownloadType.URL) {
      assert(url!.isNotEmpty);
      _permissionHandler(_downloadFile);
    }
  }

  Future<void> _convertBase64ToFile() async {
    try {
      appLoader(contextCommon);
      Directory? appDocDir;
      if (Platform.isAndroid) {
        // appDocDir = await getApplicationDocumentsDirectory();
        appDocDir = await DownloadsPathProvider.downloadsDirectory;
        // print(appDocDir!.path);
      } else if (Platform.isIOS) {
        appDocDir = await getApplicationDocumentsDirectory();
      }

      String storagePath = "${appDocDir!.path}/$filename";
      File file = File("$storagePath");
      var bytes = Base64Decoder().convert(fileString!.replaceAll("\n", ""));
      await file.writeAsBytes(bytes.buffer.asUint8List()).then((value) {});
      removeAppLoader(contextCommon);
      //OpenDownloadPdfDialog(file.path);

    } catch (e) {
      removeAppLoader(contextCommon);
      OpenAlertDilaogBox("Something Wrong");
      //RemoveAppLoader(context);
    }
  }

  Future<bool> _downloadFile() async {
    appLoader(contextCommon);
    downloadValue.value = 0;
    Directory? appDocDir;
    if (Platform.isAndroid) {
      // appDocDir = await getApplicationDocumentsDirectory();
      appDocDir = await DownloadsPathProvider.downloadsDirectory;

      print(appDocDir!.path);
    } else if (Platform.isIOS) {
      appDocDir = await getApplicationDocumentsDirectory();
    }
    String appDocPath = appDocDir!.path;
    final extension = p.extension(url!);
    final name = p.basename(url!);

    String path = "$appDocPath/$name";
    print("path=====$path");
    if (await File(path).exists()) {
      print("File exists");
      isDownloaded.value = true;
      downloadValue.refresh();

      OpenDownloadPdfDialog(path);

      return true;
    } else {
      print("File don't exists");
      Dio dio = Dio();
      cancelToken = CancelToken();
      var response = await dio.download(url!, path, onReceiveProgress: (int sent, int total) {
        downloadValue.value = ((sent / total) * 100).round();
        downloadValue.refresh();
      }, cancelToken: cancelToken);

      print(isDownloaded.value);
      print("response.statusCode=======${response.statusCode}");
      if (response.statusCode == 200) {
        isDownloaded.value = true;
        isDownloaded.refresh();
        downloadValue.value = 100;
        downloadValue.refresh();

        OpenDownloadPdfDialog(path);

        return true;
      } else {
        print(response.statusCode);
        print(response.statusMessage);
        downloadValue.value = 0;
        downloadValue.refresh();
        validationMsg(response.statusMessage!);
      }
      removeAppLoader(contextCommon);
    }

    return false;
  }

  Future<void> _permissionHandler(Future<void> function()) async {
    bool status = await Permission.storage.isGranted;

    if (status) {
      // further process
      function();
    } else if (await Permission.storage.isDenied) {
      await Permission.storage.request().then((value) {
        if (value == PermissionStatus.granted) {
          // further process
          function();
        } else if (value == PermissionStatus.denied) {
          // dialog

          OpenAlertDilaogBox("You can not download files");
        }
      });
    }
  }

  Future<void> Openfile(String path) async {
    print("path * * $path");
    Get.back();
    // final _result = await OpenFile.open("/sdcard/Download/1646309175_images.jpg");
    final _result = await OpenFile.open(path);
    print(_result.message);
  }

  OpenAlertDilaogBox(String message) {
    // OpenDialogBox(
    //     child: AlertDialogBox.messageShoeDialogWithCloseButton(
    //         message: message, status: Status.Successful,minHeight: 170));
    // Get.dialog(AlertDialogBox(
    //     message: message,
    //     onTap: () => Get.back(),
    //     textStyle: TextStyles.textStyleDark14(AppColors.WHITE),
    //     buttonName: "OK"));
  }

  OpenDownloadPdfDialog(String path) {
    print("yaa received signal");
    LoginDialoge(
        dialogtext:"Do you want to open file?",
        // stackicon: Icon(Icons.exit_to_app,size: 40.0,color:Colors.white,),
        stackicon:
            SvgPicture.asset(IMG_DOWNLOAD_SVG_NEW,color: white,height: 35,),
        // Icon(Icons.arrow_circle_down,size: 40.0,color:Colors.white,),
        firstbuttontap: () {
          removeAppLoader(contextCommon);
          Get.back();
        },
        secondbuttontap: () {
          removeAppLoader(contextCommon);
           Openfile(path);
        },
        secondbuttontext: "Yes",
        firstbuttontext: "No"
    );
     // CommonBottomSheet(
     //      fullsheetbackgroundColor: Colors.transparent,
     //      title: "open file",
     //      description: "Do you want to open file?",
     //      context: Get.context!,
     //      button2_text: "Yes",
     //      button2_tap:
     //          () {
     //       // Get.back();
     //        Get.back(); Openfile(path);
     //        //Get.to(ReferaFriendPage());
     //        //Get.to(MyCarPage());
     //      },
     //      showclosebutton: true,
     //      sheetbackgroundcolor: Theme.of(Get.context!).cardColor,
     //      boxshadow: true,
     //      cancel_text: "Cancel",
     //      canceltext_tap: (){
     //        Get.back();
     //      },
     //      closeicon: Icon(Icons.clear),
     //      closebuttontap: (){
     //        Get.back();
     //      }
     //
     //  );
    }
    // BottomSheetDialog(
    //     backgroundColor: AppColors.YELLOW,
    //     child: AlertDialogButton(
    //         "do you want to open file?",
    //         TotalButton.TWO,
    //         "yes",
    //         "no",
    //             () => {Get.back(), Openfile(path)},
    //             () => {
    //           Get.back(),
    //         },
    //         AppColors.BLACK,
    //         AppColors.ALERT_BUTTON_COLOR,
    //         semiBoldTextStyle(
    //             txtColor: AppColors.BLACK,
    //             fontSize: 12),
    //         semiBoldTextStyle(
    //             txtColor: AppColors.BLACK,
    //             fontSize: 12)
    //         // TextStyles.textStyleDark14(AppColors.WHITE),
    //         // TextStyles.textStyleDark14(AppColors.BLACK)
    // ),
    //     // context: context,
    //     message: "open file");
  // }
}

enum DownloadType { URL, BASE64 }
