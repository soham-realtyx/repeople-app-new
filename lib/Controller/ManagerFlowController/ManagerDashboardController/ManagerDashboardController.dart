import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Config/Constant.dart';
import '../../../Config/Helper/ApiResponse.dart';
import '../../../Config/utils/colors.dart';
import '../../../Config/utils/styles.dart';
import '../../../Model/ManagerModelClass/ManagerDashBoardScreen/ManagerGrievanceScreen.dart';
import '../../../Model/Theme/WidgetThemeListClass.dart';
import '../../../View/ManagerScreensFlow/ManagerGrievanceDetailsScreen/ManagerGrievanceDetails.dart';
import '../../../Widgets/CustomDecoration.dart';
import '../../../Widgets/ShimmerWidget.dart';

class ManagerDashboardController extends GetxController{

  //RxList Declaration
  RxList<WidgetThemeListClass> arrSetThemeWidget = RxList<WidgetThemeListClass>([]);
  RxList<WidgetThemeListClass> arrThemeWidget = RxList<WidgetThemeListClass>([]);
  RxList<ManagerGrievanceModel> arrGrievancelist=RxList(<ManagerGrievanceModel>[]);

  //futureValue Declaration
  Rx<Future<List<ManagerGrievanceModel>>> futuregrivieancelist = Future.value(<ManagerGrievanceModel>[]).obs;

  //RxVariable Declartion
  RxBool islogin = false.obs;
  RxString message = ''.obs;
  RxInt loadmore = 0.obs;
  RxInt pagecount = 1.obs;

  //onInit
  @override
  void onInit() async{
    // ToDo: do your own code
    islogin.value = UserSimplePreference.getbool(ISLOGIN) ?? false;
    super.onInit();
    futuregrivieancelist.value = RetrieveProjectDetails();
  }

  scrollUpdate(ScrollController scrollController) {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;
    print(currentPosition);
    if (maxScroll == currentPosition) {
      if (loadmore.value == 1) {
        pagecount.value++;
        RetrieveProjectDetails();
      }
    }
  }

  //<editor-fold desc=" API CALLES">

  Future<List<ManagerGrievanceModel>> RetrieveProjectDetails() async {
    try{
      SharedPreferences sp = await SharedPreferences.getInstance();

      var data = {
        'action': 'showmanagergrievance',
      };
      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_MANAGER,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      if(pagecount.value==1){
        arrGrievancelist = RxList([]);}

      Map<String, dynamic>? responseData = await response.getResponse();



      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        loadmore.value = responseData['loadmore'] ?? 0;

        List<ManagerGrievanceModel> arrTempList = [];
        arrTempList = List<ManagerGrievanceModel>.from(result.map((e) => ManagerGrievanceModel.fromJson(e)));
        arrGrievancelist.addAll(arrTempList);
        arrGrievancelist.refresh();

      }

      else {
        message.value = responseData['message'];
      }
    }catch(e){
      print(e.toString()+" this is error");
    }

    return arrGrievancelist;

  }

  //</editor-fold >



  HomeController() {
    arrThemeWidget = RxList<WidgetThemeListClass>([]);


      arrThemeWidget.add(WidgetThemeListClass(TITLE_1, wd_Title_1()));
      arrThemeWidget.add(WidgetThemeListClass(TITLE_1, CountGridBuiler()));



    arrSetThemeWidget = arrThemeWidget;

    // GetProjectsList();
    arrThemeWidget.refresh();
    arrSetThemeWidget.refresh();
  }

  Widget wd_Title_1() {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: RichText(
        text: TextSpan(
            text: "Hello,",
            style: regularTextStyle(fontSize: 21, txtColor: gray_color),
            children: <TextSpan>[
              !islogin.value
                  ? TextSpan(
                  text: '\nGuest User ',
                  style: boldTextStyle(txtColor: gray_color, fontSize: 24)
              )
                  : TextSpan(
                  text: '\n'+username.value,
                  style: boldTextStyle(txtColor: gray_color, fontSize: 24)
                // TextStyle(fontSize: 22,color: gray_color,fontWeight: FontWeight.w500),
                // style: darkLargeTextStyle(24),
              ),
            ] // children:
        ),
      ),
    );
  }

  Widget CountGridBuiler(){
    return  Obx(() {
      return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: FutureBuilder(
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Container(
                  child: GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _generateProjectBlock1(index);
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: arrGrievancelist.length
                  )

              );
            }
            else{
              return ShimmerEffectwidget();
            }
          },
          future: futuregrivieancelist.value,
        ),
      );
    });

  }

  Widget ShimmerEffectwidget(){

    return Container(
        child: Column(
          children: [
            SizedBox(height: 10,),
            ShimmerEffect(
            child: GridView.builder(
              padding: EdgeInsets.zero,
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(child: shimmerWidget(radius: cornarradius),);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: 10
            )

    ),
          ],
        ));
  }

  Widget _generateProjectBlock1(int index) {
    ManagerGrievanceModel obj=arrGrievancelist[index];
    return  GestureDetector(
      onTap: (){
      Get.to(ManagerGrievaceDetails(projectid: obj.id.toString(),));
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10,top: 0,bottom: 0),
        decoration: CustomDecorations().backgroundlocal(
            white, 15, 0, DARK_BLUE_WITH_OPACITY),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(obj.count.toString(),
                style: semiBoldTextStyle(txtColor: gray_color, fontSize: 18)
            ),
            SizedBox(
              height: 5,
            ),
            Text(obj.name.toString(),
                textAlign: TextAlign.center,
                style: semiBoldTextStyle(txtColor: gray_color_1, fontSize: 13,)
            )
          ],
        ),
      ),
    );
  }

  }