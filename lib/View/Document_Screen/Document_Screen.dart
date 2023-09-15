import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/View/Document_Screen/DocumentDetailsScreen.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/DocumentController/DocumentController.dart';
import 'package:Repeople/Model/Document/Document_Category_Model.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import '../../Config/Function.dart';
import '../../Config/utils/Images.dart';
import '../../Config/utils/Strings.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/CustomDecoration.dart';
import '../../Widgets/TextEditField.dart';
import 'Add_Document_Screen.dart';

class Document_Screen extends StatefulWidget {
  @override
  document_vault_state createState() => new document_vault_state();
}

class document_vault_state extends State<Document_Screen> with TickerProviderStateMixin {

  DocumentController cnt_document = Get.put(DocumentController());
  CommonHeaderController cnt_CommonHeader  =Get.put(CommonHeaderController());
  Rxn<TextEditingController> cate_name = new Rxn(TextEditingController());
  Rxn<TextEditingController> docu_name = new  Rxn(TextEditingController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = new GlobalKey<FormState>();


  void initState() {
    super.initState();
    MoengageAnalyticsHandler().track_event("document_page");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    cnt_document.futureDocMainData.value=  cnt_document.RetrieveMainDocumentListData().whenComplete(() {
      setState(() {
        cnt_document.categoryTabController=TabController(length: cnt_document.arrDocMainList.length, vsync: this);
      });
      cnt_document.futureDocCategoryMainData.value=cnt_document.RetrieveDocumentListData();


        if(cnt_document.arrDocMainList.length>0){
          cnt_document.categoryTabController.addListener(() {
            if (cnt_document.categoryTabController.indexIsChanging)
            {

            }else{
             cnt_document.IsUpdatable.value=="false";
             cnt_document.IsUpdatable.refresh();
             cnt_document.MainDocType.value=cnt_document.arrDocMainList[cnt_document.categoryTabController.index];
             cnt_document.MainDocType.refresh();
             cnt_document.futureDocCategoryMainData.value=cnt_document.RetrieveDocumentListData();
              setState(() {});

            }
          });
        }

      });

    });
    cnt_document.LoadPage();



  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_document.GlobalDocumentScreenkey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
      body: SafeArea(
          child: RefreshIndicator(
              onRefresh: () async {
                cnt_document.AllDataRefresh();
              },
              child: Stack(children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        NewDocumentListData_1(),
                       // SizedBox(height: 50)
                      ],
                    ),
                  ),
                ),
                cnt_CommonHeader.commonAppBar(
                    "Documents", cnt_document.GlobalDocumentScreenkey,
                    color: AppColors.NEWAPPBARCOLOR),
              ]))),
      floatingActionButton: Obx(()=> cnt_document.IsUpdatable.value!="true"? Padding(
        padding:  EdgeInsets.only(right: 10.w,bottom: 12.h),
        child: FloatingActionButton(
          backgroundColor: APP_THEME_COLOR,
          onPressed: () {
            cate_name.value?.text="";
            // _add_category(context);
            Add_categoryBottomsheeet();
          },
          child: Icon(Icons.add),
        ),
      ):SizedBox()),
    );
  }

  TextEditingController userController = new TextEditingController();

  Widget wd_documentlistchild(int index) {
    DocumentListMain obj = cnt_document.arrDocCategoryMainList[index];

    return obj.isvisible.toString() == "1"
        ? Dismissible(
        key: Key(obj.name!),
        movementDuration: Duration(seconds: 2),
        onDismissed: (direction) {
          cnt_document.DeleteCategoryData( id: obj.id.toString());

          try {
            final snackBar = SnackBar(
              content: Text(obj.name! + 'Removed'),
              action: SnackBarAction(
                label: 'undo',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );

            // Scaffold.of(context).showSnackBar(snackBar);
          } catch (ex) {}
        },
        // Show a red background as the item is swiped away.
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin:EdgeInsets.only(left: 0.0, right: 0.0, bottom: 10) ,
          alignment: AlignmentDirectional.centerStart,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [fullcontainerboxShadow],
                    // color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(cornarradius),
                      topLeft: Radius.circular(cornarradius),
                      bottomLeft: Radius.circular(cornarradius),
                      bottomRight: Radius.circular(cornarradius),
                    )),
                child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: obj.count!="" && obj.count!=null ? ExpansionTile(
                      title: Text(obj.name!,
                          style: TextStyle(
                              fontSize: 15,
                              color: gray_color,
                              fontWeight: FontWeight.w600,
                              fontFamily: fontFamily,
                              height: 1.5)

                      ),
                      subtitle:Text( obj.count.toString()  , style: TextStyle(fontSize: 13, color: gray_color_2, fontFamily: fontFamily, height: 1.5)),
                      leading:  Container(margin: EdgeInsets.only(top: 0),
                          alignment: Alignment.center,
                          height: 60,
                          width: 60, padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue.withOpacity(0.08)),
                            color: AppColors.BACKGROUND_WHITE,
                          ),
                          child: SvgPicture.asset(
                            IMG_DOCUMENT_SVG_NEW,
                            color: APP_THEME_COLOR,
                          )),
                      trailing: Container(
                        width: 65,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        cate_name.value?.text = obj.name.toString();
                                        // _rename_category(context,
                                        //     index);
                                        Rename_categoryBottomsheeet(index);
                                      },
                                      child:
                                      Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [fullcontainerboxShadow],
                                          shape: BoxShape.circle,
                                          color: white,
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child:
                                        SvgPicture.asset(IMG_EDIT_SVG_ICON_NEW,
                                          height: 18,
                                        ),

                                      )
                                  ),

                                  Container(
                                    height: 8.0,
                                    width: 8.0,
                                    decoration: new BoxDecoration(
                                      borderRadius:
                                      new BorderRadius
                                          .circular(50.0),
                                      color: (obj.count!="" && obj.count!="0" && obj.count!=null)?Colors.green:Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      initiallyExpanded: false,
                      children: <Widget>[

                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 1,
                                  color: APP_THEME_COLOR.withOpacity(0.1),
                                ),

                                Padding(
                                    padding: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(add_document(title: obj.name.toString(), id: obj.id.toString()))?.then((value) {
                                                    if(value!=null){
                                                      cnt_document.futureDocCategoryMainData.value =cnt_document.RetrieveDocumentListData();
                                                    }
                                                  });
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          IMG_ADD_SVG_NEW,
                                                          height: 20,
                                                          width: 20,
                                                          color: gray_color_2
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text('Add',
                                                          style: mediumTextStyle(
                                                              fontSize: 13,
                                                              txtColor:/* obj
                                                                  .documents_sub_list
                                                                  .isNotEmpty
                                                              ? */gray_color_2
                                                            // : gray_color_3
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Visibility(
                                          // visible: true,
                                            visible: obj.count!="" && obj.count!="0" && obj.count!=null,
                                            child:Container(
                                              height: 34.h,
                                              alignment: Alignment.topCenter,
                                              width: 1,
                                              // thickness: 1,
                                              // color: hex("f1f1f1"),
                                              color: APP_THEME_COLOR.withOpacity(0.1),
                                            )),

                                        Visibility(
                                            visible: obj.count!="" && obj.count!="0" && obj.count!=null,
                                            child:Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  if(obj.count!="" && obj.count!="0" && obj.count!=null)
                                                    InkWell(
                                                        onTap: () {
                                                          if (obj.count!="" && obj.count!="0" && obj.count!=null) {
                                                            cnt_document.RetrieveDocumentSubListData(id: obj.documenttypeid.toString(),name: obj.name.toString(),categoryid: obj.id.toString()).then((value) {
                                                              cnt_document.View_SubListBottomsheeet(name: obj.name.toString());
                                                            });
                                                            // View_categoryBottomsheeet(index);
                                                          }

                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(vertical: 5),
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(
                                                                    IMG_VIEW_SVG_NEW,
                                                                    height: 20,
                                                                    width: 20,
                                                                    color: gray_color_2
                                                                    ,
                                                                  ),
                                                                  SizedBox(width: 5,),
                                                                  Text('View',
                                                                      style: mediumTextStyle(
                                                                          fontSize: 13,
                                                                          txtColor: gray_color_2
                                                                      )
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                ],
                                              ),
                                            )),

                                      ],
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ):
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7.0),
                      child: ExpansionTile(
                        title: Text(obj.name!,
                            style: TextStyle(
                                fontSize: 15,
                                color: gray_color,
                                fontWeight: FontWeight.w600,
                                fontFamily: fontFamily,
                                height: 1.5)

                        ),
                        leading:  Container(margin: EdgeInsets.only(top: 0),
                            alignment: Alignment.center,
                            height: 60,
                            width: 60, padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue.withOpacity(0.08)),
                              color: AppColors.BACKGROUND_WHITE,
                            ),
                            child: SvgPicture.asset(
                              IMG_DOCUMENT_SVG_NEW,
                              color: APP_THEME_COLOR,
                            )),
                        trailing: Container(
                          width: 65,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          cate_name.value?.text = obj.name.toString();
                                          // _rename_category(context,
                                          //     index);
                                          Rename_categoryBottomsheeet(
                                              index);
                                        },
                                        child:
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [fullcontainerboxShadow],
                                            shape: BoxShape.circle,
                                            color: white,
                                          ),
                                          padding: EdgeInsets.all(10),
                                          child:
                                          SvgPicture.asset(IMG_EDIT_SVG_ICON_NEW,
                                            height: 18,
                                          ),

                                        )
                                    ),

                                    Container(
                                      height: 8.0,
                                      width: 8.0,
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                        new BorderRadius
                                            .circular(50.0),
                                        color: (obj.count!="" && obj.count!="0" && obj.count!=null)?Colors.green:Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        initiallyExpanded: false,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 1,
                                    color: APP_THEME_COLOR.withOpacity(0.1),
                                  ),

                                  Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.to(add_document(title: obj.name.toString(), id: obj.id.toString()))?.then((value) {
                                                      if(value!=null){
                                                        cnt_document.futureDocCategoryMainData.value =cnt_document.RetrieveDocumentListData();
                                                      }
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SvgPicture.asset(
                                                            IMG_ADD_SVG_NEW,
                                                            height: 20,
                                                            width: 20,
                                                            color: gray_color_2
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text('Add',
                                                            style: mediumTextStyle(
                                                                fontSize: 13,
                                                                txtColor:/* obj
                                                                    .documents_sub_list
                                                                    .isNotEmpty
                                                                ? */gray_color_2
                                                              // : gray_color_3
                                                            )
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Visibility(
                                            // visible: true,
                                              visible: obj.count!="" && obj.count!="0" && obj.count!=null,
                                              child:Container(
                                                height: 34.h,
                                                alignment: Alignment.topCenter,
                                                width: 1,
                                                // thickness: 1,
                                                // color: hex("f1f1f1"),
                                                color: APP_THEME_COLOR.withOpacity(0.1),
                                              )),

                                          Visibility(
                                              visible: obj.count!="" && obj.count!="0" && obj.count!=null,
                                              child:Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    if(obj.count!="" && obj.count!="0" && obj.count!=null)
                                                      InkWell(
                                                          onTap: () {
                                                            if (obj.count!="" && obj.count!="0" && obj.count!=null) {
                                                              cnt_document.RetrieveDocumentSubListData(id: obj.documenttypeid.toString(),name: obj.name.toString(),categoryid: obj.id.toString()).then((value) {
                                                                cnt_document.View_SubListBottomsheeet(name: obj.name.toString());
                                                              });
                                                            }

                                                          },
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(vertical: 5),
                                                                child: Row(
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                      IMG_VIEW_SVG_NEW,
                                                                      height: 20,
                                                                      width: 20,
                                                                      color: gray_color_2
                                                                      ,
                                                                    ),
                                                                    SizedBox(width: 5,),
                                                                    Text('View',
                                                                        style: mediumTextStyle(
                                                                            fontSize: 13,
                                                                            txtColor: gray_color_2
                                                                        )
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                  ],
                                                ),
                                              )),

                                        ],
                                      )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ),
              )
              // ),
            ],
          ),
        ))
        : Padding(
      padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 10),
      child: Column(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color: white,
              boxShadow: [fullcontainerboxShadow],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(cornarradius),
                topLeft: Radius.circular(cornarradius),
                bottomLeft: Radius.circular(cornarradius),
                bottomRight: Radius.circular(cornarradius),
              ),
            ),
            child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child:obj.count!="" && obj.count!=null?
                ExpansionTile(
                  title: Text(obj.name ?? "", style: TextStyle(fontSize: 15, color: gray_color, fontWeight: FontWeight.w600, fontFamily: fontFamily, height: 1.5)),
                  subtitle: Text(obj.count.toString() ,
                      // obj.no_of_doc!,
                      style: TextStyle(
                          fontSize: 13,
                          color: gray_color_2,
                          fontFamily: fontFamily,
                          height: 1.5)),

                  leading: Container(
                      margin: EdgeInsets.only(top: 0),
                      alignment: Alignment.center,
                      height: 60,
                      width: 60,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue.withOpacity(0.08)),
                        color: AppColors.BACKGROUND_WHITE,
                      ),
                      child: SvgPicture.asset(
                        IMG_DOCUMENT_SVG_NEW,
                        color: APP_THEME_COLOR,
                      )),

                  trailing: obj.count!="" && obj.count!="0" && obj.count!=null
                      ? Container(
                    // margin: new EdgeInsets.only(left: 42.0),
                    alignment: Alignment.center,
                    height: 8.0,
                    width: 8.0,
                    decoration: new BoxDecoration(
                      borderRadius:
                      new BorderRadius.circular(50.0),
                      color: Colors.green,
                    ),
                  ) :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 8.0,
                        width: 8.0,
                        decoration: new BoxDecoration(borderRadius: new BorderRadius.circular(50.0), color: Colors.red,),
                      )
                    ],
                  ),
                  initiallyExpanded: false,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 1,
                              color: APP_THEME_COLOR.withOpacity(0.1),
                            ),

                            Padding(
                                padding: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Obx(() =>
                                        Visibility(
                                          visible: cnt_document.IsUpdatable.value=="true" ,
                                          child: Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.to(add_document(title: obj.name.toString(), id: obj.id.toString()))?.then((value) {
                                                      if(value!=null){
                                                        cnt_document.futureDocCategoryMainData.value =cnt_document.RetrieveDocumentListData();
                                                      }
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SvgPicture.asset(
                                                            IMG_ADD_SVG_NEW,
                                                            height: 20,
                                                            width: 20,
                                                            color: gray_color_2
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text('Add',
                                                            style: mediumTextStyle(
                                                                fontSize: 13,
                                                                txtColor:/* obj
                                                                      .documents_sub_list
                                                                      .isNotEmpty
                                                                  ? */gray_color_2
                                                              // : gray_color_3
                                                            )
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),

                                    Visibility(
                                      // visible: true,
                                        visible: obj.count!="" && obj.count!="0" && obj.count!=null && cnt_document.IsUpdatable.value=="true",
                                        child:Container(
                                          height: 34.h,
                                          alignment: Alignment.topCenter,
                                          width: 1,
                                          // thickness: 1,
                                          // color: hex("f1f1f1"),
                                          color: APP_THEME_COLOR.withOpacity(0.1),
                                        )),
                                    Visibility(child: Container(height: 34.h,)),

                                    Visibility(
                                        visible: obj.count!="" && obj.count!="0" && obj.count!=null,
                                        child:Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              if(obj.count!="" && obj.count!="0" && obj.count!=null)
                                                InkWell(
                                                    onTap: () {
                                                      if (obj.count!="" && obj.count!="0" && obj.count!=null) {
                                                        cnt_document.RetrieveDocumentSubListData(id: obj.documenttypeid.toString(),name: obj.name.toString(),categoryid: obj.id.toString()).then((value) {
                                                          cnt_document.View_SubListBottomsheeet(name: obj.name.toString());
                                                        });
                                                      }

                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 5),
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                IMG_VIEW_SVG_NEW,
                                                                height: 20,
                                                                width: 20,
                                                                color: gray_color_2
                                                                ,
                                                              ),
                                                              SizedBox(width: 5,),
                                                              Text('View',
                                                                  style: mediumTextStyle(
                                                                      fontSize: 13,
                                                                      txtColor: gray_color_2
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                            ],
                                          ),
                                        )),

                                  ],
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ):
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7.0),
                  child: ExpansionTile(
                    title: Text(obj.name ?? "",
                        style: TextStyle(
                            fontSize: 15,
                            color: gray_color,
                            fontWeight: FontWeight.w600,
                            fontFamily: fontFamily,
                            height: 1.5)
                    ),
                    leading: Container(
                        margin: EdgeInsets.only(top: 0),
                        alignment: Alignment.center,
                        height: 60,
                        width: 60,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue.withOpacity(0.08)),
                          color: AppColors.BACKGROUND_WHITE,
                        ),
                        child: SvgPicture.asset(
                          IMG_DOCUMENT_SVG_NEW,
                          color: APP_THEME_COLOR,
                        )),
                    trailing: obj.count!="" && obj.count!="0" && obj.count!=null
                        ? Container(
                      // margin: new EdgeInsets.only(left: 42.0),
                      alignment: Alignment.center,
                      height: 8.0,
                      width: 8.0,
                      decoration: new BoxDecoration(
                        borderRadius:
                        new BorderRadius.circular(50.0),
                        color: Colors.green,
                      ),
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 8.0,
                          width: 8.0,
                          decoration: new BoxDecoration(
                            borderRadius:
                            new BorderRadius.circular(
                                50.0),
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                    initiallyExpanded: false,
                    children: <Widget>[
                      cnt_document.IsUpdatable.value=="true"? InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        onTap: () {

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            color: Colors.white,

                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Divider(
                                thickness: 1,
                                color: hex("f1f1f1"),
                                //color: BLACK,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    right: 15,),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.to(add_document(title: obj.name.toString(), id: obj.id.toString()))?.then((value) {
                                                  if(value!=null){
                                                    cnt_document.futureDocCategoryMainData.value =cnt_document.RetrieveDocumentListData();
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                        IMG_ADD_SVG_NEW,
                                                        height: 18,
                                                        width: 18,
                                                        color:
                                                        // obj.documents_sub_list
                                                        //     .isNotEmpty
                                                        //     ?
                                                        gray_color_2
                                                      // : gray_color_3,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text('Add',
                                                        style: mediumTextStyle(
                                                            fontSize: 13,
                                                            txtColor: gray_color_2

                                                        )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        // visible: true,
                                          visible: obj.count!="" && obj.count!="0" && obj.count!=null,
                                          child:Container(
                                            height: 34.h,
                                            alignment: Alignment.topCenter,
                                            width: 1,
                                            // thickness: 1,
                                            // color: hex("f1f1f1"),
                                            color: APP_THEME_COLOR.withOpacity(0.1),
                                          )),
                                      Visibility(
                                          visible: obj.count!="" && obj.count!="0" && obj.count!=null,
                                          child:Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                if(obj.count!="" && obj.count!="0" && obj.count!=null)
                                                  InkWell(
                                                      onTap: () {
                                                        // if (obj.count!="" && obj.count!="0" && obj.count!=null) {
                                                        //   View_categoryBottomsheeet(
                                                        //       index);
                                                        // }
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(vertical: 5),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [

                                                                SvgPicture.asset(
                                                                  IMG_VIEW_SVG_NEW,
                                                                  height: 20,
                                                                  width: 20,
                                                                  color:  gray_color_2
                                                                  ,
                                                                ),

                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text('View',
                                                                    style: mediumTextStyle(
                                                                        fontSize: 13,
                                                                        txtColor: gray_color_2
                                                                    )

                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                              ],
                                            ),
                                          )),

                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ):SizedBox()
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget DocumentCatgoryListView() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            if (cnt_document.arrDocCategoryMainList.isNotEmpty) {
              return Container(
                  constraints: BoxConstraints(
                    minHeight: 50,
                    maxHeight: Get.height*0.76,

                  ),
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)),),
                  child: Obx(() {
                    return TabBarView(
                        controller: cnt_document.categoryTabController,
                        children: cnt_document.arrDocMainList.value.map((e) {
                          return ListView.builder(
                            padding: EdgeInsets.only(bottom: 35, top: 15,right: 5,left: 5),
                            shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (_, index) {
                              return Obx(() {
                                return wd_documentlistchild(index);
                              });
                            },
                            itemCount: cnt_document.arrDocCategoryMainList.length,
                          );
                        } ).toList()


                    );

                  }));
            }
            else {
              return Container(
                height: Get.height / 2,
                width: Get.width,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Obx(() {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cnt_document.message.value,
                        style: mediumTextStyle(
                            txtColor: AppColors.TEXT_TITLE, fontSize: 15),
                      ),
                    ],
                  );
                }),
              );
            }
          } else {
            return LeadShimmerWidget();
          }
        },
        future: cnt_document.futureDocCategoryMainData.value,
      );
    });
  }

  Widget NewDocumentListData_1(){
    return Container(
      child:  FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState
              == ConnectionState.done && snapshot.data != null) {
            if (cnt_document.arrDocMainList.value.isNotEmpty) {
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 0),
                itemBuilder: (context, i) {
                  return _generateDocumentDataBlock1(i);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4),
                itemCount:cnt_document.arrDocMainList.value.length,
              );
            } else {
              return Container(
                height: Get.height / 2,
                width: Get.width,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Obx(() {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cnt_document.message.value,
                        style: mediumTextStyle(
                            txtColor: AppColors.TEXT_TITLE, fontSize: 15),
                      ),
                    ],
                  );
                }),
              );
            }
          } else {
            return ShimmerEffect(
                child:
                GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.only(
                      left: 20, right: 20, top: 24, bottom: 0),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return
                      Container(
                        padding: EdgeInsets.only(top: 0, left: 0, right: 0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                          color: APP_GRAY_COLOR,),
                        width: 100,
                        height: 100,

                      );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: 4
                  ,
                )
              // Container(
              //   padding: EdgeInsets.only(top: 0, left: LEFT_PADDING, right: 0),
              //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: APP_GRAY_COLOR,),
              //   width: 100,
              //   height: 20,
              //
              // )
            );
          }
        },
        future: cnt_document.futureDocCategoryMainData.value,
      ),
    );
  }

  Widget _generateDocumentDataBlock1(int index){
    // DocumentListMain obj = cnt_document.arrDocMainList.vale[index];
    return GestureDetector(
      onTap: (){
        Get.to(()=>DocumentDetailsScreen(doc_id: "${cnt_document.arrDocMainList.value[index].id}",));
      },
      child: Container(
        child: Column(
          children: [
            SvgPicture.asset(IMG_FILE_SVG,height: 72,width: 92),
            SizedBox(height: 6.h),
            Text(cnt_document.arrDocMainList.value[index].type??"",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: new_black_color,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w700)
            )
          ],
        ),
      ),
    );
  }

  Widget LeadShimmerWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0,right: 10,left: 10),
      child: ShimmerEffect(
          child: Container(
            padding: EdgeInsets.only(top: cnt_document.arrDocCategoryList.isNotEmpty ? 10.h : 0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.w),
                    child: shimmerWidget(width: Get.width, height: 65.h, radius: 10),
                  );
                },
                itemCount: 6),
          )),
    );
  }

  Widget RenameButton(double width, int i) {
    return OnTapButton(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            DocumentListMain obj = cnt_document.arrDocCategoryMainList[i];
            setState(() {
              cnt_document.RenameCategoryData(name:  cate_name.value!.text,id: obj.id.toString() ?? "");
            });
            Navigator.of(context).pop();
          }
        },
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Rename",
        width: width,
        height: 45,
        style:
        TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w600)
      // TextStyle(color: WHITE)
    );
  }

  Widget RenameButton2(double width, int i, int i2) {
    return OnTapButton(
        onTap: () {
          if (_formKey3.currentState!.validate()) {
            setState(() {
              cnt_document.RenameCategoryData(name:  docu_name.value!.text,id: "");
              docu_name.value?.clear();
              docu_name.refresh();
            });

            Navigator.of(context).pop();
          }
        },
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Rename",
        width: width,
        height: 45,
        style:
        TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w600)
      // regularTextStyle(txtColor: WHITE)
      // TextStyle(color: WHITE)
    );
  }






  Widget renamecategory(int i) {
    return SingleChildScrollView(
      child: Container(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  0.0, 20.0, 0.0, 0.0), // content padding
              child: Form(
                key: _formKey,
                child: new Wrap(
                  children: <Widget>[


                    simpleTextFieldNewWithCustomization(
                        hintText: "Category Name",
                        // imageIcon: IMG_PROFILEUSER_SVG_DASHBOARD,
                        imageIcon: IMG_USER_SVG_NEW,
                        controller: cate_name,
                        textInputType: TextInputType.name,
                        labelText: "Category*",
                        validator: (value) =>
                            validation(value, "Please enter Category name")),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Center(child: RenameButton(140, i)),
                    ),
                  ],
                ),
              ))),
    );
  }

  Widget renamedocsublist(int i, int i2) {
    return SingleChildScrollView(
      child: Container(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  0.0, 20.0, 0.0, 0.0), // content padding
              child: Form(
                key: _formKey3,
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
                      child: Center(child: RenameButton2(140, i, i2)),
                    ),
                    // Padding(
                    //   padding:  EdgeInsets.symmetric(vertical: 20),
                    //   child: Center(child: SubmitButton(140)),
                    // ),
                    // RenameButton(140, i)
                  ],
                ),
              ))),
    );
  }

  Rename_subcategoryBottomsheeet(int i, int i2) {
    bottomSheetDialog(
      child: renamedocsublist(i, i2),
      message: "Rename Category",
      backgroundColor: APP_THEME_COLOR,
      isCloseMenuShow: true,
    );
  }


  //<editor-fold desc = "Floating Action Button ">
  Add_categoryBottomsheeet() {
    bottomSheetDialog(
      child: addnewcategory(),
      message: "Add New Category",
      backgroundColor: APP_THEME_COLOR,
      isCloseMenuShow: true,
    );
  }

  Widget addnewcategory() {
    return SingleChildScrollView(
      child: Container(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  0.0, 20.0, 0.0, 0.0), // content padding
              child: Form(
                key: _formKey,
                child: new Wrap(
                  children: <Widget>[
                    simpleTextFieldNewWithCustomization(
                        hintText: "Category Name",
                        imageIcon: IMG_USER_SVG_NEW,
                        controller: cate_name,
                        textInputType: TextInputType.name,
                        labelText: "Category*",
                        validator: (value) =>
                            validation(value, "Please enter Category name")),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: AddButton(140)),
                    ),
                  ],
                ),
              ))),
    );
  }

  Widget AddButton([double? width]) {
    return OnTapButton(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            cnt_document.AddCategoryDocumentData(name: cate_name.value!.text);
        }
        },
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Add",
        width: width,
        height: 45,
        style:
        TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w600)
      // TextStyle(color: WHITE)
    );
  }

  //</editor-fold>




  Delete_categorybottomsheet(int index) {
    bottomSheetDialog(
      // context: Get.context,
      child: deletedocumentbottomsheet(index),
      // context: context,
      message: 'Delete ' + cnt_document.arrDocCategoryList[index].doc_cat_name!,
      backgroundColor: APP_THEME_COLOR,
      // mainColor: AppColors.MENUBG,
      isCloseMenuShow: true,
    );
  }

  Rename_categoryBottomsheeet(int i) {
    bottomSheetDialog(
      // context: Get.context,
      child: renamecategory(i),
      // context: context,
      message: "Rename Category",
      backgroundColor: APP_THEME_COLOR,
      // mainColor: AppColors.MENUBG,
      isCloseMenuShow: true,
    );
  }

  void _delete_category(context, index) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        0.0, 0.0, 0.0, 0.0), // content padding
                    child: Form(
                      key: _formKey,
                      child: new Wrap(
                        children: <Widget>[
                          new ListTile(
                              title: new Text(
                                'Delete ' +
                                    cnt_document.arrDocCategoryList[index]
                                        .doc_cat_name!,
                                style: semiBoldTextStyle(),
                                // TextStyle(
                                //   fontWeight: FontWeight.bold,
                                // ),
                              ),
                              onTap: () {}),
                          //Divider(height: 1,color: Colors.black,),

                          ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: cnt_document.arrDocCategoryList[index]
                                .documents_sub_list.length,
                            itemBuilder: (BuildContext context, int index1) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 30),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          cnt_document
                                              .arrDocCategoryList[index]
                                              .documents_sub_list[index1]
                                              .doc_name ??
                                              "",
                                          style: regularTextStyle(fontSize: 20)
                                        //TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            Deletedialog(index, index1);
                                            // Get.back();
                                            //        doct_data_list.removeAt(index);
                                          });
                                        },
                                        child: Image(
                                            height: 30,
                                            image: AssetImage(
                                                "assets/images/ic_delete_active.png"))),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ))),
          );
        });
  }

  DeleteDialogUserDefinedDocuments(int index) {
    commondialog(
        dialogtext: "Are you sure you want to delete?",
        stackicon: Icon(
          Icons.exit_to_app,
          size: 40.0,
          color: Colors.white,
        ),
        firstbuttontap: () {
          Get.back();
        },
        secondbuttontap: () {
          Get.back();
          cnt_document.arrDocCategoryList.removeAt(index).obs;
          cnt_document.arrDocCategoryList.refresh();
          cate_name.value?.clear();
        },
        secondbuttontext: "Yes",
        firstbuttontext: "No");
  }

  Deletedialog(int index, int index1) {
    LoginDialoge(
        dialogtext: "Are you sure you want to delete?",
        // stackicon: Icon(Icons.exit_to_app,size: 40.0,color:Colors.white,),
        stackicon:
        SvgPicture.asset(IMG_LOGOUT_SVG_NEW,color: white,height: 35,),
        // Icon(
        //   Icons.exit_to_app,
        //   size: 40.0,
        //   color: Colors.white,
        // ),
        firstbuttontap: () {
          Get.back();
        },
        secondbuttontap: () {
          Get.back();
          Get.back();
          cnt_document.arrDocCategoryList[index].documents_sub_list
              .removeAt(index1)
              .obs;
          cnt_document.arrDocCategoryList.refresh();
        },
        secondbuttontext: "Yes",
        firstbuttontext: "No");
  }

  void view_document(context, index) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0), // content padding
                    child: Form(
                      key: _formKey,
                      child: new Wrap(
                        children: <Widget>[
                          new ListTile(
                              title: new Text(
                                  cnt_document
                                      .arrDocCategoryList[index].doc_cat_name!,
                                  style: semiBoldTextStyle(fontSize: 17)
                                // style: TextStyle(
                                //   fontSize: 17,
                                //   fontWeight: FontWeight.bold,
                                // ),
                              ),
                              onTap: () {}),
                          //Divider(height: 1,color: Colors.black,),

                          ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: cnt_document.arrDocCategoryList[index]
                                .documents_sub_list.length,
                            itemBuilder: (BuildContext context, int index1) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 30),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          cnt_document
                                              .arrDocCategoryList[index]
                                              .documents_sub_list[index1]
                                              .doc_name ??
                                              "",
                                          style: regularTextStyle(fontSize: 20)
                                        // style: TextStyle(
                                        //   fontSize: 20,
                                        // ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        docu_name.value?.text = cnt_document
                                            .arrDocCategoryList[index]
                                            .documents_sub_list[index1]
                                            .doc_name
                                            .toString();
                                        print(docu_name.value?.text);
                                        Navigator.of(context).pop();
                                        // _rename_document();
                                        Rename_subcategoryBottomsheeet(index, index1);
                                        //        doct_data_list.removeAt(index);
                                        // Toast.show('edit Document', context);
                                      },
                                      child: SvgPicture.asset(
                                        IMG_EDIT_SVG_ICON_NEW,
                                        height: 18,
                                      ),
                                      // Icon(
                                      //   Icons.edit,
                                      // )
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // Get.to(view_document_new(
                                        //   title: cnt_document
                                        //       .arrDocCategoryList[index]
                                        //       .documents_sub_list[index1]
                                        //       .doc_name ??
                                        //       "",
                                        //   imageurl: cnt_document
                                        //       .arrDocCategoryList[index]
                                        //       .documents_sub_list[index1]
                                        //       .imageurl!,
                                        //   id: "",
                                        // ));
                                      },
                                      child: SvgPicture.asset(
                                        IMG_VIEW_SVG_NEW,
                                        height: 18,
                                      ),
                                      // Icon(
                                      //   Icons.remove_red_eye,
                                      // ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ))),
          );
        });
  }


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

  Widget deletedocumentbottomsheet(int index) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0), // content padding
              child: Form(
                key: _formKey,
                child: new Wrap(
                  children: <Widget>[

                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      scrollDirection: Axis.vertical,
                      itemCount: cnt_document
                          .arrDocCategoryList[index].documents_sub_list.length,
                      itemBuilder: (BuildContext context, int index1) {
                        return Column(children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 5, top: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      cnt_document.arrDocCategoryList[index].documents_sub_list[index1].doc_name ?? "",
                                      style: regularTextStyle(fontSize: 14)
                                    //TextStyle(fontSize: 20),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      Deletedialog(index, index1);
                                      // Get.back();
                                      //        doct_data_list.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        boxShadow: [fullcontainerboxShadow],
                                        shape: BoxShape.circle,
                                        //borderRadius: new BorderRadius.circular(35.0),
                                        // color: APP_THEME_COLOR.withOpacity(0.01),
                                        color: white,
                                      ),
                                      // decoration: BoxDecoration(
                                      //
                                      //     shape: BoxShape.circle,
                                      //     color: APP_THEME_COLOR),
                                      child: SvgPicture.asset(
                                        IMG_DELETE_SVG_NEW,
                                        height: 25,
                                        //color: WHITE,
                                      )),
                                  // Image(
                                  //     height: 30,
                                  //     image: AssetImage(
                                  //         "assets/images/ic_delete_active.png"))
                                ),
                              ],
                            ),
                          ),
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


}

Widget SimpleTextFieldCategory({
  OnTapPress? onTap,
  bool autoFocus = false,
  String? imageIcon,
  String? labelText,
  String? hintText,
  TextEditingController? controller,
  List<TextInputFormatter>? inputformat,
  String? Function(String?)? validator,
  String? Function(String?)? onChanged,
  String? Function(String?)? onFieldSubmitted,
  TextInputType? textInputType,
  int? maxLength,
  int maxline = 1,
}) {
  return TextFormField(
    style: boldTextStyle(fontSize: 18, txtColor: APP_FONT_COLOR),
    //TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.bold),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    onTap: onTap,
    onChanged: onChanged,
    onFieldSubmitted: onFieldSubmitted,
    maxLength: maxLength,
    validator: validator,
    keyboardType: textInputType,
    controller: controller,
    decoration: InputDecoration(
      border: InputBorder.none,
      enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
      focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
      errorBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      disabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      focusedErrorBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      enabled: true,
      contentPadding: EdgeInsets.all(20),
      labelStyle: TextStyle(
          fontSize: 16,
          color: Colors.black.withOpacity(0.7),
          fontWeight: FontWeight.bold),
      // semiBoldTextStyle(fontSize: 16,txtColor: Colors.black.withOpacity(0.7),),
      // TextStyle(
      //     fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
      // : isFocus
      // ? TextStyle(fontWeight: FontWeight.bold, color: APP_FONT_COLOR)
      // : null,
      labelText: labelText,
      hintText: hintText,
      hintStyle:
      // regularTextStyle(fontSize: 16,txtColor:  Colors.black.withOpacity(0.7),),
      // TextStyle(
      //     fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.normal),
      TextStyle(
          fontSize: 15,
          color: Colors.grey.withOpacity(0.8),
          fontWeight: FontWeight.bold),
      focusColor: Colors.white,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      // prefixIcon: imageIcon!=""?Padding(
      //   padding: EdgeInsets.only(left: 0),
      //   child: Container(
      //     width: 50,
      //     height: 50,
      //     margin: EdgeInsets.only(right: 10),
      //     padding: const EdgeInsets.all(10.0),
      //     decoration: CustomDecorations()
      //         .backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
      //     child: Image.asset(imageIcon ?? ""),
      //   ),
      // ):Container(width: 1,height: 1,)
      // prefixIcon: Padding(
      //   padding: EdgeInsets.only(left: 0),
      //   child: Container(
      //     width: 50,
      //     height: 50,
      //     margin: EdgeInsets.only(right: 10),
      //     padding: const EdgeInsets.all(10.0),
      //     decoration: CustomDecorations()
      //         .backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
      //     child: Image.asset(imageIcon ?? ""),
      //   ),
      // )
    ),
  );
}
