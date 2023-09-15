import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as Get;
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiResponse {
  Map<String, dynamic> data;
  Map<String, String> headerdata;
  String base_url;
  String apiKey, platform = "";
  ApiHeaderType apiHeaderType;

  ApiResponse
      ({
    required this.data,
    required this.base_url,
    this.headerdata = const {},
    this.apiKey = API_KEY,
    required this.apiHeaderType
      });



  Future<Map<String, String>> _Header() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    Map<String, String> header = {};
    if (Platform.isAndroid) {
      platform = "1";
    } else if (Platform.isIOS) {
      platform = "2";
    }

    if (apiHeaderType == ApiHeaderType.Login) {
      header = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'platform': "7",
        'key': API_CONSTKEY,
        'cmpid': APP_CMPID,
        'iss': APP_ISS,
        'os': platform,
      };
    } else if (apiHeaderType == ApiHeaderType.Content) {
      header = {
        'Content-Type': 'application/x-www-form-urlencoded',
        if(sp.getString(SESSION_KEY)!=null)
        'key': sp.getString(SESSION_KEY)!,
        if(sp.getString(SESSION_UNQKEY)!=null)
        'unqkey': sp.getString(SESSION_UNQKEY)!,
        'iss': sp.getString(SESSION_ISS)??APP_ISS,
        if(sp.getString(SESSION_UID)!=null)
        'uid': sp.getString(SESSION_UID)!,
        'platform': "7",
        'masterlisting': "false",
        'os': platform,
        'responsetype': "JSON",
        'cmpid': sp.getString(SESSION_CMPID)??APP_CMPID,
        /* for my listing api call*/
        // 'Content-Type': 'application/x-www-form-urlencoded',
        // 'key': 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE2NjMzMTIxNDgsImlzcyI6ImJyaWtraW4tYXBwIiwibmJmIjoxNjYzMzEyMTQ4LCJleHAiOjE2NjMzMjI5NDgsInVpZCI6IjYyYjJlNWZjNjIyNjE0NDIxZjc1MjhiYyIsInVucWtleSI6IjBiZDIwZmZlLWVhMzktNDc5Yy1hMjFmLTFlYTBiZmQ3MDliZSIsInVzZXJhZ2VudCI6IlBvc3RtYW5SdW50aW1lXC83LjI5LjIifQ.UV0mGo6w6fnnhhvIVB8vCO_rJNF9gpSODwMgE6cYmkbBhOlmimT5Kt8BR5d_DojdQWeGt-pTV3r1ctqhDfqsjswEsaoy7b_NB-AtqW_Q42_VHoQtonz3smwstvo-BbyaVTxhpzDlhr0E_D6kaxBEXKbT0NwC_3zXUXZzeY1nGm0kIaqtuomo7sb26nw2BWC7t-9MWuR8uiRappHcOq-YCB55XR7ALBRciuXije-VGPPWONRcPa5iaiFTjojR9slDpyOEihoagBmydlXK9OF3n-Aa-u4uYFBJhnU6i-udvKTAKEWitWA8pmsN-AZOWW8OIIibuqmwVAqKcticKCtr1A',
        // 'unqkey': '0bd20ffe-ea39-479c-a21f-1ea0bfd709be',
        // 'iss': sp.getString(SESSION_ISS)!,
        // 'uid': "631c6b8b02b9e91aa12cb489",
        // 'platform': "6",
        // 'os': platform,
        // 'responsetype': "JSON",
        // 'cmpid': '631c6b8b02b9e91aa12cb48a',
      };

    }
    header.addAll(headerdata);

    print("header $header");
    return header;
  }

  Future<Map<String, dynamic>> _AddDeviceData() async {
    Map<String, dynamic> device = await deviceData.getDeviceData();
    device.addAll(data);

    // print("_AddDeviceData $device");
    return device;
  }

  Future<Map<String, dynamic>?> getResponse() async {

    Map<String, String> headers = await _Header();
    Map<String, dynamic> datas = await _AddDeviceData();

    Dio dio = Dio();
    Response response= await dio.post(base_url,
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return status! <= 500; // Validate status codes less than 500 as success
          },
        ), data: FormData.fromMap(datas)).catchError(onError);

    try {
      // print(response.toString());
      if (response.statusCode == 200) {
        if (response.data['status'] == -1) {
         // LogoutServie(Get.Get.context!);
        }
        return response.data;
      } else {
        final error = response.data.errors[0] ?? "Error";
        print("Server Not Responding \n" + error.toString());

        throw Exception(error);
      }
    } catch (e) {
      if (e is DioError) {

        if (DioErrorType.receiveTimeout == e.type ||
            DioErrorType.connectTimeout == e.type) {
          Commonmessage =
          "Oops! No Internet!\nServer is not reachable. Please verify your internet connection and try again";
        } else if (DioErrorType.response == e.type) {
          Commonmessage = "Something Went Wrong";
        } else if (DioErrorType.other == e.type) {
          if (e.message!.contains('SocketException')) {
            Commonmessage = "Make sure your network connection is on";
          }
        } else {
          Commonmessage = "Problem connecting to the server. Please try again.";
        }
      }
    }
    return null;
  }

  void onError(dynamic e) {
    debugPrint(e.toString(), wrapWidth: 1024);

    print('close onError');
      removeAppLoader(Get.Get.context!);

    if (DioErrorType.receiveTimeout == e.type ||
        DioErrorType.connectTimeout == e.type) {
      Commonmessage =
      "Oops! No Internet!\nServer is not reachable. Please verify your internet connection and try again";
    } else if (DioErrorType.response == e.type) {
      Commonmessage = "Someting Went Wrong";
    } else if (DioErrorType.other == e.type) {
      if (e.message.contains('SocketException')) {
        Commonmessage =
        "Oops! No Internet!\nMake sure your network connection is on";
        // if (!isValidationMsgShow) {
        //   ValidationMsg(Commonmessage);
        //   isValidationMsgShow = true;
        // }
      } else if (e.message.contains('FormatException')) {
        Commonmessage = "Alert!!!\n" + e.message;
      }
    } else {
      Commonmessage =
      "Server Problem!!!\nProblem connecting to the server. Please try again.";
    }
  }
}
class GetApiResponse{
  String base_url;
  GetApiResponse({required this.base_url});

  Future<Map<String, dynamic>?> getResponse() async {
    Dio dio = Dio();
    try {
      Response response = await dio.get(base_url);
      if (response.statusCode == 200) {
        return response.data;
      }
      else if(response.statusCode==404){
      }
      else {
        final error = response.data.errors[0] ?? "Error";
        print("Server Not Responding \n" + error.toString());

        throw Exception(error);
      }
    } catch (e) {
      if (e is DioError) {
        if (DioErrorType.receiveTimeout == e.type ||
            DioErrorType.connectTimeout == e.type) {
          Commonmessage =
          "Oops! No Internet!\nServer is not reachable. Please verify your internet connection and try again";
        } else if (DioErrorType.response == e.type) {
          if(e.response?.statusCode==404){
            print("404 to tha");
            validationMsg("invalide ifsc code");
          }
          Commonmessage = "Something Went Wrong";
        } else if (DioErrorType.other == e.type) {
          if (e.message.contains('SocketException')) {
            Commonmessage = "Make sure your network connection is on";
          }
        } else {
          Commonmessage = "Problem connecting to the server. Please try again.";
        }
      }
    }
    return null;
  }

}
// ErrorDialog(String message) {
//   OpenDialogBox(
//       child: AlertDialogBox.messageShoeDialogWithCloseButton(
//           message: message, status: Status.Error,minHeight: 135.w));
// }

enum ApiHeaderType { Login, Content , NONE }

enum RequestType { GET, POST }
