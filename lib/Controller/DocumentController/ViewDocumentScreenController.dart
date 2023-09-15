
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Model/Document/Document_Category_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/Constant.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Config/utils/colors.dart';
import '../CommonHeaderController/CommenHeaderController.dart';


class ViewDocumentController extends GetxController {


  TextEditingController txt_search = TextEditingController();

  RxList<Doc_Cat_List> arrDocCategoryList = RxList<Doc_Cat_List>([]);
  Rx<Future<List<Doc_Cat_List>>> futureDocCategoryData = Future.value(<Doc_Cat_List>[]).obs;
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  var GlobalViewDocumentScreenkey = GlobalKey<ScaffoldState>();

  int loadmore = 0;
  int pagecount = 1;
  ScrollController scrollController = ScrollController();
  RxString message = "".obs;
  RxString title = "".obs;
  RxString image = "".obs;


  RxBool isCancel = false.obs;
  FocusNode focusNode = FocusNode();
  RxInt addrights = 0.obs;

  //new list declaration
  RxList<DocumentViewer> arrDocList = RxList<DocumentViewer>([]);


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  //<editor-fold desc = "Services">

  List<Doc_Cat_List> documents_category_list= [];


  Future<List<Doc_Cat_List>> RetrieveDocumentListData() async {

    arrDocCategoryList=RxList<Doc_Cat_List>([]);
    List<Doc_Cat_List> arrtemp = [];
    arrtemp.addAll(
        [
          Doc_Cat_List(
              doc_cat_name: 'Passport', no_of_doc: '1 Documents',status: true,ismodifyed: "yes",
              documents_sub_list:[
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/passport 1.jpeg",
                    doc_name: "Passport 1"
                ),
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/passport2.jpeg",
                    doc_name: "Passport 2"
                ),
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/passport2.jpeg",
                    doc_name: "Passport 3"
                ),
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/passport 1.jpeg",
                    doc_name: "Passport 4"
                ),
              ]

          ),
          Doc_Cat_List(doc_cat_name: 'Aadhaar Card',no_of_doc: 'Upload',status: false,ismodifyed: "yes",
              documents_sub_list:[
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/adharcard1.png",
                    doc_name: "Aadhaar Card 1"
                ),
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/adharcard2.png",
                    doc_name: "Aadhaar Card 2"
                ),
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/adharcard3.png",
                    doc_name: "Aadhaar Card 3"
                ),

              ]),
          Doc_Cat_List(doc_cat_name: 'Pan Card',no_of_doc: 'Upload',status: false,ismodifyed: "yes",
              documents_sub_list:[
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/pancard1.jpeg",
                    doc_name: "Pan Card 1"
                ),
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/pancard2.jpeg",
                    doc_name: "Pan Card 2"
                ),

              ]),
          Doc_Cat_List(doc_cat_name: 'Driving Licence',no_of_doc: 'Upload',status: false,ismodifyed: "yes",
              documents_sub_list:[
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/drivinglicense1.jpeg",
                    doc_name: "Driving Licence 1"
                ),
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/drivinglicense2.jpeg",
                    doc_name: "Driving Licence 2"
                ),
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/drivinglicense3.jpeg",
                    doc_name: "Driving Licence 2"
                ),

              ]),
          Doc_Cat_List(doc_cat_name: 'Voter Id',no_of_doc: 'Upload',status: false,ismodifyed:"yes",
              documents_sub_list:[
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/voterid1.jpeg",
                    doc_name: "Voter Id 1"
                ),
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/voterid2.jpeg",
                    doc_name: "Voter Id 2"
                ),
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/voterid3.jpeg",
                    doc_name: "Voter Id 3"
                ),

              ]),
          Doc_Cat_List(doc_cat_name: 'Demand Letter',no_of_doc: 'Upload',status: true,ismodifyed: "yes",
              documents_sub_list:[
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/passport 1.jpeg",
                    doc_name: "Demand Letter 1"
                ),

              ]),
          Doc_Cat_List(doc_cat_name: 'Agreement Paper',no_of_doc: 'Upload',status: true,ismodifyed: "yes",
              documents_sub_list:[
                DocumentsSubModel(
                    id: "",
                    imageurl: "assets/images/passport 1.jpeg",
                    doc_name: "Agreement Paper 1"
                ),

              ])


        ]
    );

    arrDocCategoryList.addAll(arrtemp);
    arrDocCategoryList.refresh();

    return arrDocCategoryList;
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


  //<editor-fold desc = "Api Call ">

  RetriveDocumentData({required String id}) async {
    arrDocList = RxList<DocumentViewer>([]);
    try{

      SharedPreferences sp = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        'action': 'viewdocument',
        'document_id':id,
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

        List<DocumentViewer> arrtemp = [];
        arrtemp = List.from(result.map((e) => DocumentViewer.fromJson(e)));
        arrDocList.addAll(arrtemp);
        arrDocList.refresh();
        if(arrDocList.length>0){
          image.value=arrDocList.value.first.document.toString();
          image.refresh();
        }




      } else {

        message.value = responseData['message'];


      }

    }catch(e){
      print(e);
    }


  }

  //</editor-fold >









}
