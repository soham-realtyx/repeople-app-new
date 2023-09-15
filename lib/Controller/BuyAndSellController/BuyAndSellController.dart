
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Config/Constant.dart';
import '../../Config/Function.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Config/utils/Strings.dart';
import '../../Model/BuyAndSellModel/BuyAndSellModel.dart';
import '../../Model/CommonModal/CommonModal.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/CustomDecoration.dart';
import '../../Widgets/select_dailog.dart';

class BuyAndSellController extends GetxController{

  //GlobalKey
  GlobalKey<ScaffoldState> GlobalBuyAndSellkey = GlobalKey<ScaffoldState>();

  //Controller


  //TabController Declaration
  late TabController tabController;

  //ScrollController
  ScrollController scrollController = ScrollController();

  //RxList Declaration
  RxList<CommonModal> arrProjectList = RxList([]);
  RxList<BuyAndSellModel> arrPropertyList = RxList<BuyAndSellModel>([]);

  //Future Value Declaration
  Rx<Future<List<dynamic>>> futuretablist = Future.value(<dynamic>[]).obs;
  Rx<Future<List<BuyAndSellModel>>> futurepropertylist = Future.value(<BuyAndSellModel>[]).obs;

  //RxVariable Declaration
  RxInt SubIndex=0.obs;
  RxInt Pagecount=1.obs;
  RxInt loadMore=0.obs;
  RxString Message="".obs;

  //Rxn Object Declaration
  Rx<CommonModal> obj_project = CommonModal().obs;


  //TextEditingController
  TextEditingController txtProject = TextEditingController();

  @override
  void onInit(){
    // Todo: your code implements here
    super.onInit();
    getPropertyData();

  }

  Future<void> onRefresh() async {
    Restart();
    update();
  }

  Restart(){

  }

  getPropertyData()async{
  arrProjectList=RxList([]);
  arrProjectList.add( CommonModal(name: "All", id:  ""));
  arrProjectList.add( CommonModal(name: "Sell",id:  "1"));
  arrProjectList.add( CommonModal(name: "Buy", id:  "2"));
  arrProjectList.add( CommonModal(name: "Rent",id:  "3"));

    obj_project.value=arrProjectList[0];
    txtProject.text=obj_project.value.name.toString();
  }







  scrollUpdate(ScrollController scrollController) {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;

    if (maxScroll == currentPosition) {
      if (loadMore.value == 1) {
        Pagecount.value++;
        RetrievePropertyListData();
      }
    }
  }


  Future<void> makePhoneCall(String url) async {    try{
    if (await canLaunch('tel:'+url)) {
      await launch('tel:'+url);
    } else {
      throw 'Could not launch $url';
    }
  }catch(ex){
    Fluttertoast.showToast(msg: 'error in call');
    print(ex.toString());
  }

  }


  //<editor-fold desc="TabBar Screens">


  //</editor-fold>

  //<editor-fold desc="Select Property Dialouge">

  SelectProject() {
    SelectProjectDialog((value) {
      obj_project.value=value;
      txtProject.text = obj_project.value.name??"";
    });
  }

  Future<dynamic> SelectProjectDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal<CommonModal>(

      Get.context!,
      label: "Select Property Type",
      items: arrProjectList,
      showSearchBox: true,
      onChange: onChange,
      searchBoxDecoration: const InputDecoration(
          prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }

  //<editor-fold desc=" Api Calls">

  Future<List<BuyAndSellModel>> RetrievePropertyListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(Pagecount.value==1){
      arrPropertyList = RxList([]);
    }

    var data = {
      'action': 'listproperty',
      'nextpage' : Pagecount.value,
      'perpage' : '10',
      'ordby' : '1',
      'ordbycolumnname' : 'id',
      // '':'',
      // '':''
    };

    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_BUY_AND_SELL,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      arrPropertyList.value =
          List.from(result.map((e) => BuyAndSellModel.fromJson(e)));
      arrPropertyList.refresh();
      loadMore.value=responseData['loadmore'] ?? 0;
    }else{
      Message.value=responseData['message'];
    }
    return arrPropertyList;
  }

  //</editor-fold >

  //<editor-fold desc="BottomSheet Details">
  Details_About_Unit_Bottom_sheet(String Header,String label,) {

    bottomSheetDialog(
      child: Details_About_Unit_Description(label),
      message: Header,
      backgroundColor: APP_THEME_COLOR,
      isCloseMenuShow: true,
    );

  }

  Widget Details_About_Unit_Description(String label) {
    return SingleChildScrollView(
      child: Container(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(contextCommon).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                0.0, 20.0, 0.0, 0.0), // content padding
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(data:label ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: AddButton(140)),

                ),
              ],
            ),

          )),
    );
  }

  Widget AddButton([double? width]) {
    return OnTapButton(
        onTap: () {
          Navigator.pop(Get.context!);

        },
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Close",
        width: width,
        height: 45,
        style:
        TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w600)
      // TextStyle(color: WHITE)
    );
  }

//</editor-fold>


}