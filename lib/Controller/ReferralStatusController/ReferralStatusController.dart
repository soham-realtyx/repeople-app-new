
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Config/utils/colors.dart';
import '../../Model/ReferralModal/RefrralListModel.dart';
import '../BottomNavigator/BottomNavigatorController.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class ReferralStatusController extends GetxController {
  late TabController tabController;
  late TabController categoryTabController;

  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalReedemkey = GlobalKey<ScaffoldState>();

  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');

  //RX list Declaration
  RxList<RefrralMainListModel> arrRefferalList = RxList([]);

  //Future List Declaration
  Rx<Future<List<RefrralMainListModel>>> futureRefferallist =
      Future.value(<RefrralMainListModel>[]).obs;

  //rx variable declaration
  RxString message = ''.obs;
  RxInt Indexselected = 0.obs;
  RxString TotalPoints = "".obs;

  Future<void> onRefresh() async {
    Indexselected.value = 0;
    Indexselected.refresh();
    futureRefferallist.value = RetrieveReffralListData();
    update();
  }

  @override
  void onInit() {
    futureRefferallist.value = RetrieveReffralListData();
    TotalRedeemablePoints();
    super.onInit();
  }

  ClosePageCallback() {
    var getPageStringList = Get.currentRoute.split(" ");
    String pageName = getPageStringList.last;
    BottomNavigatorController cntBottom = Get.put(BottomNavigatorController());
    if (pageName == "ProjectListPage" || pageName == "FavoritePage") {
      cntBottom.SelectIndex(0);
    } else {
      Get.back();
    }
  }



  TotalRedeemablePoints() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    TotalPoints.value = sp.getString(SESSION_TOTALREDEEM_POINT) ?? "0";
  }



  Future<List<RefrralMainListModel>> RetrieveReffralListData() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      arrRefferalList = RxList([]);
      var data = {'action': 'listreferral'};

      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
      };

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_REFFRAL,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );

      Map<String, dynamic>? responseData = await response.getResponse();
      print(responseData.toString() + " this is arrery list");
      if (responseData!['status'] == 1) {
        if (responseData['referred'] != null &&
            responseData['referred'] != "") {
          dynamic reffered =
          RefrralMainListModel.fromJson(responseData['referred']);
          arrRefferalList.add(reffered);
        }
        if (responseData['completed'] != null &&
            responseData['completed'] != "") {
          dynamic reffered =
          RefrralMainListModel.fromJson(responseData['completed']);
          arrRefferalList.add(reffered);
        }
        if (responseData['accepted'] != null &&
            responseData['accepted'] != "") {
          dynamic reffered =
          RefrralMainListModel.fromJson(responseData['accepted']);
          arrRefferalList.add(reffered);
        }
        if (responseData['rejected'] != null &&
            responseData['rejected'] != "") {
          dynamic reffered =
          RefrralMainListModel.fromJson(responseData['rejected']);
          arrRefferalList.add(reffered);
        }
        arrRefferalList.refresh();
      } else {
        message.value = responseData['message'] ?? "Something Went Wrong";
      }
    } catch (e) {
      message.value = "Something Went Wrong";
      print("Something Went Wrong");
    }

    return arrRefferalList;
  }
//</editor-fold>
}
