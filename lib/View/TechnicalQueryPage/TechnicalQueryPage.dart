
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/TechnicalQueryController/TechnicalQueryController.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';

class TechnicalQueryPage extends StatefulWidget {
  const TechnicalQueryPage({Key? key}) : super(key: key);

  @override
  _TechnicalQueryPageState createState() => _TechnicalQueryPageState();
}

class _TechnicalQueryPageState extends State<TechnicalQueryPage> {

  CommonHeaderController cntCommonHeader = Get.put(CommonHeaderController());
  TechnicalQueryController cntTechnical=Get.put(TechnicalQueryController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cntTechnical.GlobalTechnicalkey,
      endDrawer: CustomDrawer(
        animatedOffset: const Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: const Offset(-1.0, 0),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: APPBAR_HEIGHT),
                  theme(),
                  const SizedBox(height: APPBAR_HEIGHT),
                ],
              ),
            ),
            cntCommonHeader.commonAppBar(TECHNICAL_QUERY, cntTechnical.GlobalTechnicalkey,color: white)
          ],
        ),
      ),
      bottomNavigationBar:BottomNavigationBarClass() ,
    );
  }
  //<editor-fold desc = "Theme 1">
  Widget theme(){
    return GetBuilder<TechnicalQueryController>(
      init: TechnicalQueryController(),
      builder: (controller){
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.only(left: 20.0, right: 20,top: 20),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: BLACK.withOpacity(0.1),
                // spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(
                    0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: cntTechnical.formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 16.h),
                          CommonDropDownTextField(
                            labelText: "Subject*",
                            onTap: (){
                              cntTechnical.SelectSubject();
                            },
                            imageIcon: IMG_SUBJECT_SVG_NEW,
                            controller: cntTechnical.txtSubject,
                            hintText: cntTechnical.txtSubject.text,
                          ),

                          SizedBox(height: 16.h),
                          attachmentWidget(),
                          SizedBox(height: 5.h),
                          queryTextField(cntTechnical.txtMassageNew),
                          SizedBox(height: 16.h),
                          submitButton(),
                          const SizedBox(height: 30,),
                       
                        ],
                      ),
                     
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget queryTextField(
      Rxn<TextEditingController>? controller,[double leftPadding = 0 , bool labelOpen = true]) {
    return Obx(() =>
        TextFormField(
          onChanged: (value){
            controller?.update((val) { });
          },
          style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
          maxLines: 4,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
          ],
          controller: controller?.value,
          validator: (value) =>
              validation(value, "Please enter query"),
          decoration: InputDecoration(
            border: InputBorder.none,
            floatingLabelBehavior: labelOpen?FloatingLabelBehavior.always:FloatingLabelBehavior.never,
            labelText: labelOpen?"Message*":null,
            hintText: "",
            labelStyle:
            TextStyle(
                fontSize: 14.sp,
                color:gray_color_1,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w500),
            hintStyle:TextStyle(
                fontSize: 16, color: LIGHT_GREY, fontWeight: FontWeight.normal),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
            errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
     
          ),
        ));
  }

  Widget attachmentWidget([double leftPadding = 0 , bool labelOpen = true]){
    return GestureDetector(
      onTap: (){
        cntTechnical.OnSelectDialog();
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelOpen?
                    Text("File",style:
                    TextStyle(
                        fontSize: 11.sp,
                        color:gray_color_1,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w500),
                    )
                        :Container(),
                    const SizedBox(height: 8,),
                    Container(
                        child: cntTechnical.arrImageAndFileList.length!=0? SizedBox(
                          height: cntTechnical.arrImageAndFileList.length !=0?100:10,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount:
                              cntTechnical.arrImageAndFileList.length > 0
                                  ? cntTechnical.arrImageAndFileList.length
                                  : 0,
                              itemBuilder: (context, i) {
                                return cntTechnical.FileBlock(i);
                              }),
                        ):Container(
                          height: labelOpen?null:50,
                          width: labelOpen?null:120,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Attach your file" , style:
                              TextStyle(fontSize: 15,
                                  color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.bold),
                              ),
                              SvgPicture.asset(IMG_FILE_UPLOAD_SVG)
                            ],
                          ),
                        )
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 8,),
          Divider(color: gray_color_1,thickness: 1,),

        ],
      ),
    );

  }

  Widget submitButton() {
    return OnTapButton(
        onTap: (){
          if(cntTechnical.formkey.currentState!.validate()){
            cntTechnical.SubmitTechnicalQuery();
          }
        },
        height: 40,
        width: Get.width,
        decoration:
        CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit".toUpperCase(),
        style: TextStyle(color: white, fontSize: 12.sp,fontFamily: fontFamily,fontWeight: FontWeight.w500)
    );
  }
}
