
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/View/Document_Screen/View_Document_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Model/Document/Document_Category_Model.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/Constant.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Config/utils/Images.dart';
import '../../Config/utils/Strings.dart';
import '../../Config/utils/colors.dart';
import '../../Config/utils/styles.dart';
import '../../Model/Document/DocumentMainCategory.dart';
import '../../Widgets/CustomDecoration.dart';
import '../../Widgets/ShimmerWidget.dart';
import '../../Widgets/TextEditField.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class DocumentController extends GetxController {
  TextEditingController txt_search = TextEditingController();
  RxList<Doc_Cat_List> arrDocCategoryList = RxList<Doc_Cat_List>([]);
  Rx<Future<List<Doc_Cat_List>>> futureDocCategoryData = Future.value(<Doc_Cat_List>[]).obs;
  //new list declaration
  RxList<DocumentListMain> arrDocCategoryMainList = RxList<DocumentListMain>([]);
  Rx<Future<List<DocumentListMain>>> futureDocCategoryMainData = Future.value(<DocumentListMain>[]).obs;

  RxList<DocumentCommonModel> arrDocSubMainList = RxList<DocumentCommonModel>([]);
  Rx<Future<List<DocumentCommonModel>>> futureDocSubMainData = Future.value(<DocumentCommonModel>[]).obs;

  RxList<DocumentMainCtegory> arrDocMainList = RxList<DocumentMainCtegory>([]);
  Rx<Future<List<DocumentMainCtegory>>> futureDocMainData = Future.value(<DocumentMainCtegory>[]).obs;
  Rxn<DocumentMainCtegory> MainDocType=Rxn<DocumentMainCtegory>();

  //form key declaration
  final GlobalKey<FormState> SubListForm = GlobalKey<FormState>();
  final GlobalKey<FormState> EditListForm = GlobalKey<FormState>();

  //text editing controller
  Rxn<TextEditingController> docu_name = new  Rxn(TextEditingController());

  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalDocumentScreenkey = GlobalKey<ScaffoldState>();

  int loadmore = 0;
  int pagecount = 1;
  ScrollController scrollController = ScrollController();
  RxString message = "".obs;
  RxString IsUpdatable=''.obs;
  RxString? dcocument_id=''.obs;

  RxBool isCancel = false.obs;
  FocusNode focusNode = FocusNode();
  RxInt addrights = 0.obs;
  late TabController categoryTabController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  LoadPage() {

    futureDocCategoryData.refresh();
    scrollController.addListener(() {
      scrollUpdate();
    });
  }


  Future<List<DocumentMainCtegory>> RetrieveMainDocumentListData() async {
    arrDocMainList = RxList<DocumentMainCtegory>([]);
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'action': 'filldocumenttype',
    };
    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_DOCUMENT_CATEGORY_LIST,
        apiHeaderType: ApiHeaderType.Content,
      headerdata: headers

       );
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
    List result = responseData['result'];
    List<DocumentMainCtegory> arrtemp = [];
    arrtemp = List.from(result.map((e) => DocumentMainCtegory.fromJson(e)));
    arrDocMainList.addAll(arrtemp);
    arrDocMainList.refresh();
    } else {
    message.value = responseData['message'];
    }
    return arrDocMainList;
  }

  Future<List<DocumentListMain>> RetrieveDocumentListData() async {
    arrDocCategoryMainList = RxList<DocumentListMain>([]);
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'action': 'listcategory',
      'documenttype_id' : dcocument_id?.value ?? "1"
    };
    print(data.toString()+"====>>>>>>>");
    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_DOCUMENT_CATEGORY_LIST,
        apiHeaderType: ApiHeaderType.Content,
      headerdata: headers

       );
    Map<String, dynamic>? responseData = await response.getResponse();
    if (responseData!['status'] == 1) {
    List result = responseData['result'];
    List<DocumentListMain> arrtemp = [];
    arrtemp = List.from(result.map((e) => DocumentListMain.fromJson(e)));
    arrDocCategoryMainList.addAll(arrtemp);
    arrDocCategoryMainList.refresh();
    IsUpdatable.value=responseData['isupdate'] ?? "false";
    } else {
    message.value = responseData['message'];
    }
    return arrDocCategoryMainList;
  }

  Future<List<DocumentCommonModel>> RetrieveDocumentSubListData({required String id,required String name,required String categoryid}) async {
    try{

      Apploader(contextCommon);
      arrDocSubMainList = RxList<DocumentCommonModel>([]);
      SharedPreferences sp = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        'action': 'listdocument',
        'documenttype_id':id,
        'document_categoryid' : categoryid

      };

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_DOCUMENT_CATEGORY_LIST,
          apiHeaderType: ApiHeaderType.Content,
          headerdata: headers

      );

      Map<String, dynamic>? responseData = await response.getResponse();
      Navigator.pop(contextCommon);
      if (responseData!['status'] == 1) {
        List result = responseData['data'];

        List<DocumentCommonModel> arrtemp = [];
        arrtemp = List.from(result.map((e) => DocumentCommonModel.fromJson(e)));
        arrDocSubMainList.addAll(arrtemp);
        arrDocSubMainList.refresh();
        return arrDocSubMainList;
      } else {
        Navigator.pop(contextCommon);
        message.value = responseData['message'];
        validationMsg(message.value);
        return arrDocSubMainList;
      }

    }catch(e){
      print(e);
      Navigator.pop(contextCommon);
      validationMsg("Something Went Wrong");
      return arrDocSubMainList;
    }


  }

  DeleteDocumentData({required String id}) async {

    try{

      SharedPreferences sp = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        'action': 'deletedocument',
        'id':id,
      };

      print(data.toString()+" this is deleted documentt  ");

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_DOCUMENT_CATEGORY_LIST,
          apiHeaderType: ApiHeaderType.Content,
          headerdata: headers

      );


      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {

        SuccessMsg(responseData['message'] ?? "document deleted successfully");
        futureDocCategoryMainData.value = RetrieveDocumentListData();


      } else {

        message.value = responseData['message'];
        validationMsg(message.value );


      }

    }catch(e){
      print(e);
      validationMsg("something went wrong");
    }


  }

  EditDocumentData({required DocumentCommonModel obj}) async {

    try{

      SharedPreferences sp = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        'action': 'adddocument',
        'documentname':docu_name.value?.text,
        'formevent':'editright',
        'id':obj.id,
        "document_categoryid":obj.document_categoryid,
        "document_category":obj.document_category,
      };

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_DOCUMENT_CATEGORY_LIST,
          apiHeaderType: ApiHeaderType.Content,
          headerdata: headers

      );


      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {

        SuccessMsg(responseData['message'] ?? "document updated successfully");
        Get.back();
        futureDocCategoryMainData.value = RetrieveDocumentListData();


      } else {

        message.value = responseData['message'];
        validationMsg(message.value);


      }

    }catch(e){
      print(e);
      validationMsg("Something went wrong");
    }


  }

  AddCategoryDocumentData({required String name}) async {

    try{

      SharedPreferences sp = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        'action': 'addcategory',
        'legaldoctype': name,
        'formevent':'addright',
      };

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_DOCUMENT_CATEGORY_LIST,
          apiHeaderType: ApiHeaderType.Content,
          headerdata: headers
      );


      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {

        SuccessMsg(responseData['message'] ?? "category added successfully");
        Get.back();
        futureDocCategoryMainData.value = RetrieveDocumentListData();
      }
      else {
        message.value = responseData['message'];
        validationMsg(message.value);
      }

    }catch(e){
      print(e);
      validationMsg("Something went wrong");
    }


  }

  DeleteCategoryData({required String id}) async {

    try{

      SharedPreferences sp = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        'action': 'deletecategory',
        'id':id,
      };

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_DOCUMENT_CATEGORY_LIST,
          apiHeaderType: ApiHeaderType.Content,
          headerdata: headers

      );


      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {

        SuccessMsg(responseData['message'] ?? "document deleted successfully");
        futureDocCategoryMainData.value = RetrieveDocumentListData();


      } else {

        message.value = responseData['message'];
        validationMsg(message.value);


      }

    }catch(e){
      print(e);
      validationMsg("Something went wrong");
    }


  }

  RenameCategoryData({required String id,required String name}) async {

    try{
      Apploader(contextCommon);
      SharedPreferences sp = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        'action': 'addcategory',
        'legaldoctype': name,
        'formevent': 'editright',
        'id':id,
      };

      print("check my data"+data.toString());

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_DOCUMENT_CATEGORY_LIST,
          apiHeaderType: ApiHeaderType.Content,
          headerdata: headers

      );


      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
      Navigator.pop(contextCommon);
        SuccessMsg(responseData['message'] ?? "category renamed successfully");
        futureDocCategoryMainData.value = RetrieveDocumentListData();


      } else {
        Navigator.pop(contextCommon);
        message.value = responseData['message'];
        validationMsg(message.value);


      }

    }catch(e){
      print(e);
      validationMsg("Something went wrong");
      Navigator.pop(contextCommon);
    }


  }

  //</editor-fold >

  //<editor-fold desc = "Bottom sheet for sub list">
  View_SubListBottomsheeet({required String name}) {
    bottomSheetDialog(
      child: viewdocumentwidget(),
      message: name ,
      backgroundColor: APP_THEME_COLOR,
      isCloseMenuShow: true,
    );
  }

  Widget viewdocumentwidget() {
    return SingleChildScrollView(
      child: Container(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0), // content padding
              child: Form(
                key: SubListForm,
                child: new Wrap(
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      scrollDirection: Axis.vertical,
                      itemCount: arrDocSubMainList.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentCommonModel obj=arrDocSubMainList[index];
                        return Column(children: [
                          Padding(
                              padding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
                              child: Row(
                                children: [

                                  Expanded(child: Text( obj.documentname ??"", style: regularTextStyle(fontSize: 14)),),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      boxShadow: [fullcontainerboxShadow],
                                      shape: BoxShape.circle,
                                      color: white,
                                    ),
                                    child:  MoreMenuButton(obj),),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )),
                          Divider(
                            thickness: 1,
                            color: hex("f1f1f1"),
                            //color: BLACK,
                          ),
                        ]);
                      },
                    )
                  ],
                ),
              ))),
    );
  }

  Widget MoreMenuButton(DocumentCommonModel obj) => PopupMenuButton<int>(

    color: Colors.white,
    offset: const Offset(10, -20),
    padding: const EdgeInsets.only(top: 0),

    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(cornarradius))
    ),
    onSelected: (value) async {
      if (value == 1) {
        Get.to(view_document_new(
          title: obj.documentname.toString(),
          id: obj.id.toString(),
        ));

      }

      else if (value == 2) {
        Get.back();
        Rename_subcategoryBottomsheeet(obj);

      } else if (value == 3) {

          Deletedialog(obj.id.toString());

      }

    },
    child: Container(
      height: 40.w,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        IMG_MORE_SVG_NEW,
        height: 15.w,

      ),
    ),
    itemBuilder: (context) => [

      wd_menuchild(IMG_VIEW_SVG_NEW, "View", () {}, 1),

   if(obj.islock.toString()!="1")   wd_menuchild(IMG_EDIT_SVG_ICON_NEW, "Edit", () {}, 2),

      if(obj.islock.toString()!="1")  wd_menuchild(IMG_DELETE_SVG_NEW, "Delete", () {}, 3),

    ],
    // onSelected: (item) => More_SelectedItem(item),
  );

  PopupMenuItem<int> wd_menuchild(
      String image, String title, VoidCallback ontap, int id,
      [bool svg = true]) {
    return PopupMenuItem<int>(

      value: id,
      height: 30,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          svg
              ? SvgPicture.asset(
            image,
            height: 15.w,
          )
              : Image.asset(
            image,
            height: 15.w,
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(
            title,
            style: regularTextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }


  Deletedialog(String id) {
    LoginDialoge(
        dialogtext: "Are you sure you want to delete?",
        stackicon:
        SvgPicture.asset(IMG_LOGOUT_SVG_NEW,color: white,height: 35,),

        firstbuttontap: () {
          Get.back();
        },
        secondbuttontap: () {
          Get.back();
          Get.back();
          DeleteDocumentData(id:id);

        },
        secondbuttontext: "Yes",
        firstbuttontext: "No");
  }

  Rename_subcategoryBottomsheeet(DocumentCommonModel obj ) {
    docu_name.value!.text=obj.documentname.toString() ;

    bottomSheetDialog(
      child: renamedocsublist(obj),
      message: "Rename Document",
      backgroundColor: APP_THEME_COLOR,
      isCloseMenuShow: true,
    );
  }

  Widget renamedocsublist(DocumentCommonModel obj) {
    return SingleChildScrollView(
      child: Container(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  0.0, 20.0, 0.0, 0.0), // content padding
              child: Form(
                key: EditListForm,
                child: new Wrap(
                  children: <Widget>[

                    simpleTextFieldNewWithCustomization(
                        hintText: "Document Name",
                        // imageIcon: IMG_PROFILEUSER_SVG_DASHBOARD,
                        imageIcon: IMG_USER_SVG_NEW,
                        controller: docu_name,
                        textInputType: TextInputType.name,
                        labelText: "Document Name*",
                        validator: (value) =>
                            validation(value, "Please Enter Document Name")),


                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Center(child: RenameButton2(140,obj)),
                    ),

                  ],
                ),
              ))),
    );
  }

  Widget RenameButton2(double width,DocumentCommonModel obj) {
    return OnTapButton(
        onTap: () {
          if (EditListForm.currentState!.validate()) {
            EditDocumentData(obj: obj);
          }},
        decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Rename",
        width: width,
        height: 45,
        style: TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w600)
    );
  }

  //</editor-fold>

  Widget CategoryTabView() {
    return
      FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null)
            if(arrDocMainList.length>0)
              return Container(
                width: Get.width,
                child:Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(cornarradius),topRight:
                    Radius.circular(cornarradius),bottomRight: Radius.circular(cornarradius),
                        bottomLeft: Radius.circular(cornarradius)),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: DecoratedBox(decoration:  BoxDecoration(
                        color: Colors.white.withOpacity(0.0),
                        border: Border(
                            bottom: BorderSide(color: APP_THEME_COLOR.withOpacity(0.1), width: 2.sp)),
                      ),
                          child: TabBar(
                              controller: categoryTabController,
                              isScrollable: true,
                              labelColor: APP_THEME_COLOR,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor:APP_THEME_COLOR,
                              onTap: (val) {},
                              unselectedLabelColor: Colors.grey[500],
                              tabs: arrDocMainList.value.map((e) => Tab(
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Center(
                                      child: Text(
                                        e.type!,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.w600),),
                                    ),),
                                ),)).toList()
                            //
                          ))),
                ),
                // ),
              );
            else{
              return Container();
            }
          else
            return Container(
              height: 100,
              child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder:(_,index){
                        return   Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              shimmerWidget(height: 40.h, width: 80.w, radius: cornarradius),
                            ],
                          ),
                        );
                      } )


              ),
            );
        },
        future: futureDocMainData.value,
      );


  }



  scrollUpdate() {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;
    if (maxScroll == currentPosition) {
      if (loadmore == 1) {
        print(pagecount);
        pagecount++;
        RetrieveDocumentListData();

        update();
      }
    }
  }

  //</editor-fold>

  RefreshData() {
    arrDocCategoryList = RxList([]);
    // futureLeadTitleData.value = RetrieveGetCountData();
    futureDocCategoryMainData.value = RetrieveDocumentListData();
    futureDocCategoryData.refresh();
  }

  AllDataRefresh() {
    pagecount = 1;
    //FilterDataClear();
    arrDocCategoryList.clear();
    futureDocCategoryMainData.value = RetrieveDocumentListData();
  }
}
