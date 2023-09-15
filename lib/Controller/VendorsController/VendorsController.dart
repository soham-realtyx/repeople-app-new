import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/Vendors/VendorsModel.dart';
import 'package:Repeople/Widgets/select_dailog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../../Model/ComitteeModel/committeeModel.dart';
import '../../Model/CommonModal/CommonModal.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/ShimmerWidget.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class VendorController extends GetxController {
  RxList<ProjectDetailsModel> arrProjectList = RxList<ProjectDetailsModel>([]);
  Rx<Future<List<ProjectDetailsModel>>> futureProjectData =
      Future.value(<ProjectDetailsModel>[]).obs;

  RxList<VendorModel> arrVendorsList = RxList<VendorModel>([]);
  Rx<Future<List<VendorModel>>> futurevendorlistData =
      Future.value(<VendorModel>[]).obs;

  RxList<VendorsModalNew> arrVendorsdataList = RxList<VendorsModalNew>([]);
  Rx<Future<List<VendorsModalNew>>> futurevendorData =
      Future.value(<VendorsModalNew>[]).obs;

  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalVendorsPagekey = GlobalKey<ScaffoldState>();
  TextEditingController txtProject = TextEditingController();
  CommonModal obj_project = CommonModal();
  TextEditingController txt_Search = new TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  RxString message = "".obs;


  Rx<VendorsModalNew> obj_vendorslist = VendorsModalNew().obs;
  Rxn<Future<VendorsModalNew>> obj_futurevendorlistDetails = Rxn<Future<VendorsModalNew>>();
  //
  // RxList<String> arrProjectList1 = RxList([
  //   'Shaligram Felicity',
  //   'The Persuit of Happiness',
  //   'Shaligram Kinaro',
  //   'Shaligram Signature'
  // ]);
  RxList<CommonModal> arrProjectList1 = RxList([]);
  void _launchWhatsapp(String numberWithCountryCode, String message) async {
    String url = "https://api.whatsapp.com/send?phone=" +
        numberWithCountryCode +
        "&text=" +
        message;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ScrollController scrollController = ScrollController();

  List<VendorPersonModel> vdlist = [
    VendorPersonModel('Jayesh Mehta', 'vender data list', '+91 8000143214'),
    VendorPersonModel('Mahavir Jani', 'vender data list', '+91 6354489767'),
    VendorPersonModel('Bhavin Shah', 'vender data list', '+91 9879876532'),
  ];

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  void onInit() {
    super.onInit();

  }

  LoadPage() {
    // RetrieveVendorListDetails();
    // futurevendorlistData.value = RetriveVendorListData();
    // futureProjectData.value = RetriveProjectData();
    RetrieveProjectListData().whenComplete(() {
      obj_futurevendorlistDetails.value=RetrieveVendorListDetails();
    });

    futureProjectData.refresh();
    futurevendorlistData.refresh();
    obj_futurevendorlistDetails.refresh();
    message.refresh();
    print(message.value);
    print("message.value");
  }


  Future<List<CommonModal>> RetrieveProjectListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    print("arrFillStateList.length");
    arrProjectList1 = RxList([]);
    var data = {'action': 'fillproject'};

    var headers = {
      // "Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6IjkxNjc4NzYwMjgiLCJleHAiOjE5MjkwOTkyMzUsImVtYWlsIjpudWxsLCJtb2JpbGVfbm8iOiI5MTY3ODc2MDI4Iiwib3JpZ19pYXQiOjE2MTM3MzkyMzUsImRldmljZV9pZCI6ImFiYyIsImJ1aWxkZXJfaWQiOiJyYXVuYWstZ3JvdXAiLCJndWVzdCI6ZmFsc2UsInVzZXJfdHlwZSI6Ik1hc3RlciBBZG1pbiIsInVzZXJfdHlwZV9pZCI6LTF9.oEqoeFWiljm6pylULqBL7IHzm1IJOHFh8xKJk1_TTKU",
      // "content-type":"application/json"
     // 'userpagename': 'master',
      //'useraction': 'viewright',
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",


      // 'cmpid': "60549434a958c62f010daa2f"
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_PROJECTLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      List result = responseData['result'];
      arrProjectList1.value =
          List.from(result.map((e) => CommonModal.fromJson(e)));
      arrProjectList1.refresh();
      obj_project = arrProjectList1[0];
      txtProject.text = obj_project.name!;
    }

    return arrProjectList1;
  }

  Future<VendorsModalNew> RetrieveVendorListDetails() async {
   obj_vendorslist.value=VendorsModalNew();
    print("inside vendors list call");
    SharedPreferences sp = await SharedPreferences.getInstance();
    // arrVendorsdataList = RxList([]);
    var data = {
      'action': 'listvendors',
      'fltprojectid':obj_project.id??"",
      // 'fltprojectid':"605499579df97e44be0fcb43",
      // 'nextpage': "1",
      // 'perpage': "10",
      // 'ordby': "1",
      // 'ordbycolumnname': "_id",
      // 'filter': "",
    };

    var headers = {
      //'userpagename': 'master',
      //'useraction': 'viewright',
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };
    print(data);
    print(headers);
    print("test1234");
    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_VENDORSLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );

    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      // List result = responseData['data'];
      obj_vendorslist.value = VendorsModalNew.fromJson(responseData['data']);
      obj_vendorslist.refresh();
      obj_futurevendorlistDetails.refresh();
      print(responseData);
      // arrVendorsdataList.value =
      //     List.from(result.map((e) => VendorsModalNew.fromJson(e)));
      // arrVendorsdataList.refresh();
      // print(result);

    } else {
      message.value = responseData['message'];

      print(responseData);
    }

    return obj_vendorslist.value;

  }

  Future<List<ProjectDetailsModel>> RetriveProjectData() async {
    arrProjectList = RxList([]);
    // arrProjectList.addAll([
    //   ProjectDetailsModel(project_name: 'Shaligram Felicity', userLevel: []),
    //   ProjectDetailsModel(
    //       project_name: 'The Persuit of Happiness', userLevel: []),
    //   ProjectDetailsModel(project_name: 'Shaligram Kinaro', userLevel: []),
    //   ProjectDetailsModel(project_name: 'Shaligram Signature', userLevel: []),
    // ]);
    arrProjectList.refresh();

    return arrProjectList;
  }


  restart() {
    arrProjectList.clear();
    arrVendorsList.refresh();
    futureProjectData.value = RetriveProjectData();
    arrProjectList.refresh();
    update();
  }

  Future<void> onRefresh() async {
    // futureData.refresh();
    restart();
    update();

  }



  searchlist(String text) {
    RxList<VendorModel> vendorslistforsearch = RxList([]);
    vendorslistforsearch.refresh();
    vendorslistforsearch.value = arrVendorsList
        .where((element) =>
            element.name!.toLowerCase().contains(text.toLowerCase()))
        .toList();
    print(vendorslistforsearch.length);
    arrVendorsList.value = vendorslistforsearch.value;
    arrVendorsList.refresh();
  }




  SelectProject() {
    SelectProjectDialog((value) {
      obj_project=value;
      txtProject.text = obj_project.name??"";
      RetrieveVendorListDetails();

    });
  }

  Future<dynamic> SelectProjectDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal<CommonModal>(
      Get.context!,
      label: "Select Project",
      items: arrProjectList1,
      onChange: onChange,
      searchBoxDecoration: const InputDecoration(
          prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }



  VendorBottomsheeet(context, index) {
    bottomSheetDialog(
      // context: Get.context,
      // child: wd_Brands3(),
      child: vendordetailsbottomsheet(index),
      // context: context,
      // message: arrVendorsList[index].name!,
      message: obj_vendorslist.value.roles?[index].name??"",
      backgroundColor: APP_THEME_COLOR,
      // mainColor: AppColors.MENUBG,
      isCloseMenuShow: true,
    );
  }

  Widget vendordetailsbottomsheet(int index) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 15),
          //   child: Text(vlist[index].vname,
          //       style: TextStyle(
          //         //fontFamily: myfont,
          //           fontWeight: FontWeight.bold,
          //           //color: kprimarycolor,
          //           fontSize: 20)),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(
          //       right: MediaQuery.of(context).size.width - 55,
          //       top: 3,
          //       left: 15,
          //       bottom: 8),
          //   child: Container(
          //     height: 3,
          //     color: Colors.blue[800],
          //   ),
          // ),
          ListView.builder(
              shrinkWrap: true,
              // itemCount: vdlist.length,
              itemCount:
              obj_vendorslist.value.roles?[index].vendors!.length
              //obj_vendorslist.value.roles?[index].vendors!.length:0
              ,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, indx) {
                return Padding(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 10),
                    child: Material(
                      elevation: 0.0,
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Container(
                                  alignment: Alignment.center,
                                  // margin: new EdgeInsets.only(left: 42.0),
                                  // alignment: Alignment.center,
                                  height: 60.0,
                                  width: 60.0,
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(60.0),
                                    color: hex("f1f1f1"),
                                  ),
                                  child: Text(
                                    // "D",
                                    // vdlist[indx].name![0],
                                    obj_vendorslist.value.roles?[index].vendors?[indx].shortname??"",
                                    style:
                                        // TextStyle(
                                        //     fontSize: 15,
                                        //     color: gray_color,
                                        //     fontWeight: FontWeight.w600,
                                        //     fontFamily: fontFamily,height: 1.5
                                        // ),
                                        TextStyle(
                                            color: gray_color,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 28),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, top: 10, bottom: 5),
                                          child: Text(
                                            obj_vendorslist.value.roles?[index].vendors?[indx].name??"",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: gray_color,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: fontFamily,
                                                height: 1.5),
                                            // TextStyle(
                                            //   fontSize: 15,
                                            //   fontWeight: FontWeight.bold,
                                            //   //fontFamily: myfont,
                                            //   //color: kprimarycolor,
                                            // ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(
                                        //       left: 15,
                                        //       top: 0,
                                        //       bottom: 0),
                                        //   child: Text(
                                        //    "",
                                        //     style: TextStyle(
                                        //       fontSize: 15,
                                        //       //fontFamily: myfont,
                                        //       color: Colors.grey,
                                        //     ),
                                        //   ),
                                        // ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 15, top: 0, bottom: 10),
                                            child: Text(
                                              obj_vendorslist.value.roles?[index].vendors?[indx].mobile?[0].mobileno??"",
                                              style: TextStyle(
                                                fontSize: 15,
                                                //fontFamily: myfont,
                                                color: Colors.grey,
                                              ),
                                            ))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            splashColor: AppColors.TRANSPARENT,
                                            hoverColor: AppColors.TRANSPARENT,
                                            focusColor: AppColors.TRANSPARENT,
                                            highlightColor:
                                                AppColors.TRANSPARENT,
                                            onTap: () {
                                              // _launchWhatsapp(
                                              //     "9898983234", "Hello");
                                              _launchWhatsapp(
                                                  obj_vendorslist.value.roles?[index].vendors?[indx].mobile?[0].mobileno??"", "Hello");
                                              // _launchWhatsapp("918000143214", 'hello');
                                            },
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 15),
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColors.GREEN),
                                                  child: SvgPicture.asset(
                                                    IMG_WHATSAPP_SVG_NEW,
                                                    height: 20,
                                                    color: white,
                                                  ),
                                                )
                                                // ClipOval(
                                                //   child: Image(
                                                //       height: 40,
                                                //       width: 40,
                                                //       fit: BoxFit.cover,
                                                //       image: AssetImage(
                                                //           'assets/images/ic_whatsapp.png')),
                                                // )
                                                )),
                                        InkWell(
                                            splashColor: AppColors.TRANSPARENT,
                                            hoverColor: AppColors.TRANSPARENT,
                                            focusColor: AppColors.TRANSPARENT,
                                            highlightColor:
                                                AppColors.TRANSPARENT,
                                            onTap: () {
                                              // _makingPhoneCall;
                                              // launchUrl("tel:+99364921507");
                                              launchUrl("tel:+".toString()+(obj_vendorslist.value.roles?[index].vendors?[indx].mobile?[0].mobileno.toString()??""));
                                            },
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 15),
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: APP_THEME_COLOR),
                                                  child: SvgPicture.asset(
                                                    IMG_CALL_SVG_NEW,
                                                    height: 20,
                                                    color: white,
                                                  ),
                                                )))
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ));
              })
        ],
      ),
    );
  }

//</editor-fold>

}

class Vendor_Choice {
  const Vendor_Choice({required this.title, required this.image,required this.count});
  final String title;
  final String image;
  final String count;
}






