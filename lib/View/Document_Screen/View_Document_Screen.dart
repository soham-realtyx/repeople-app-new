
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/Loader.dart';


import '../../Config/Constant.dart';
import '../../Config/Helper/DownloadFile.dart';
import '../../Config/utils/Images.dart';
import '../../Config/utils/styles.dart';
import '../../Controller/DocumentController/ViewDocumentScreenController.dart';
import '../../Widgets/ShimmerWidget.dart';
class view_document_new extends StatefulWidget {
  String title;
  String id;
  view_document_new({required this.title, required this.id});
  @override
  view_document_newtState createState() => new view_document_newtState();
}
class view_document_newtState extends State<view_document_new> {




  ViewDocumentController cnt_viewdocument = Get.put(ViewDocumentController());
  GlobalKey<ScaffoldState>  GlobalViewDocumentScreenkey = GlobalKey<ScaffoldState>();
  CommonHeaderController cnt_CommonHeader  =Get.put(CommonHeaderController());

  @override
  void initState() {
    super.initState();
    cnt_viewdocument.title.value=widget.title;
    cnt_viewdocument. RetriveDocumentData(id: widget.id.toString());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: GlobalViewDocumentScreenkey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
      body:SafeArea(
    child: RefreshIndicator(
          onRefresh: () async {
          },
          child: Stack(
              children: [
                SingleChildScrollView(
                    child:  Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 8.0, top: 85.h),
                        child: Column(
                              crossAxisAlignment:CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                            Obx(() =>     cnt_viewdocument.image.isNotEmpty && cnt_viewdocument.image.value!=null?   Container(
                          alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(cornarradius)),

                                color: white,
                                boxShadow: [fullcontainerboxShadow]

                            ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
                          child: Obx(()=> CachedNetworkImage(
                            // width: Get.width-10,
                            placeholder: (context, url) => Container(
                             child: Align(
                               alignment: Alignment.center,
                               child: Container(
                                 width: 90,
                                 height: 90,
                                 child: Padding(
                                   padding: const EdgeInsets.all(10.0),
                                   child: SizedBox.expand(
                                       child: Image.asset(LOADER_ICON,
                                           height: 80, width: 80)),
                                 ),
                                 decoration: BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: BorderRadius.circular(45),
                                 ),
                               ),
                             ),
                            ),
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            placeholderFadeInDuration: Duration.zero,
                            imageUrl: cnt_viewdocument.image.value ,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) {
                              return Container(
                                height: 200,
                                child: Center(
                                  child: Container(

                                      // color: Colors.grey.shade300,
                                      child: Image.asset(setImage(cnt_viewdocument.image.substring(cnt_viewdocument.image.indexOf('.')).toString()))),
                                ),
                              );
                            },
                          )),
                        ),
                      )): Container(
                              width: Get.width,
                              height: 250,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),  ),
                              child: ShimmerEffect(child: shimmerWidget(width: 80, height: 50, radius: 12)),),),
                            SizedBox(height: 15,),
                            Obx(() =>      Visibility(
                                visible: cnt_viewdocument.image.isNotEmpty && cnt_viewdocument.image.value!=null,
                                child:Download_Button(),))



                              ],))),

                cnt_CommonHeader.commonAppBar(widget.title, GlobalViewDocumentScreenkey,color: white),

              ]))),

         );
  }

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
  Widget Download_Button() {
    return OnTapButton(
        onTap: () {
          DownloadFile(
              downloadType: DownloadType.URL,
              url: cnt_viewdocument.image.value,
          );
        },
        height: 40,
        width: 140,
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Download",

        style:
        TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w600));
  }

}
