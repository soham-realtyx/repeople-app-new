import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/Dashbord/ProjectListClass.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../../Model/UpdateModelClass/UpdateModelClass.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class UpdatesController extends GetxController {


  //controller of another class instance created
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());

  //GLOBAL Key Declaration
  var GlobalUpdatesPagekey = GlobalKey<ScaffoldState>();

  //RxList Declaration
  RxList<UpdateModelClass> arrUpdateList = RxList([]);
  RxList<WidgetThemeListClass> arrNoFoundListTheme = RxList<WidgetThemeListClass>();
  RxList<ProjectListClass> arrProjectDataList = RxList<ProjectListClass>();

  // FUTURE Declaration
  Rx<Future<List<UpdateModelClass>>> futurearrupdatetdatalist = Future.value(<UpdateModelClass>[]).obs;

  // Rx Variable Declaration
  RxInt _loadMore = 0.obs;
  RxInt _pageCount = 1.obs;
  RxString isFaqsEmptyMsg = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    futurearrupdatetdatalist.value=RetrieveUpdateListData();

  }


  //<editor-fold desc = "Api Calles ">

  Future<List<UpdateModelClass>> RetrieveUpdateListData() async {

    try{
      SharedPreferences sp = await SharedPreferences.getInstance();
      arrUpdateList = RxList([]);
      var data = {'action': 'listsocietyupdates',
        'nextpage':_pageCount.value,
        'perpage':"10"
      };

      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??""
      };

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_UPDATES,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();

      if (_pageCount.value == 1) {
        arrUpdateList.clear();
      }


      if (responseData!['status'] == 1) {
        List result = responseData['result'];


        List<UpdateModelClass> arrTempList = [];
        arrTempList = List<UpdateModelClass>.from(result.map((e) => UpdateModelClass.fromJson(e)));
        arrUpdateList.addAll(arrTempList);
        arrUpdateList.refresh();

        _loadMore.value = responseData['loadmore'] ?? 0;

      }
      else{
        isFaqsEmptyMsg.value = responseData['message'];
        futurearrupdatetdatalist.refresh();
      }

    }catch(e){
      print("update screen issue"+e.toString());
    }


    return arrUpdateList;
  }

//</editor-fold>

  String setImage(String extension) {
    if (extension == "txt") {
      return IMG_FILEICON;
    } else if (extension == "pdf") {
      return IMG_PDFICON;
    } else if (extension == "xls" || extension == "xlsx") {
      return IMG_XLSICON;
    } else if (extension == "doc" || extension == "docx") {
      return IMG_DOCICON;
    } else if (extension == "ppt" || extension == "pptx") {
      return IMG_PPTICON;
    } else {
      return IMG_FILEICON;
    }
  }

  scrollUpdate(ScrollController scrollController) {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;
    print(currentPosition);
    if (maxScroll == currentPosition) {
      if (_loadMore.value == 1) {
        print(_pageCount);
        _pageCount.value++;
        RetrieveUpdateListData();
      }
    }
  }




}
