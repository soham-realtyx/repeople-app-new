import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/ReferAFriendFormController/ReferAFriendFormController.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/PrivacyTermPage/PrivacyTermPage.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class ReferAFriendFormPage extends StatefulWidget {
  ReferAFriendFormPage({Key? key, this.contact}) : super(key: key);
  final Contact? contact;
  @override
  _ReferAFriendFormPageState createState() => _ReferAFriendFormPageState();
}

class _ReferAFriendFormPageState extends State<ReferAFriendFormPage> {

  ReferAFriendFormController cnt_ReferFriendForm = Get.put(ReferAFriendFormController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> _Globalrefereafriendkey = GlobalKey<ScaffoldState>();
  Future<bool> ReferDialog(context) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Get.back();
            Get.back();
            return false;
          },
          child: AlertDialog(
              insetPadding: EdgeInsets.all(20),
              title: Text(
                "Terms & Conditions",
                style: TextStyle(color: gray_color, fontSize: 18, fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,),
                maxLines: 1,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: Container(
                  width: Get.width,
                  child: SingleChildScrollView(
                      child: cnt_ReferFriendForm.Refer_a_friend_Theme_1())
              )),
        );
      },
    );
  }

  @override
  void initState() {
    cnt_ReferFriendForm.txtFirstNameNew.value?.text="";
    cnt_ReferFriendForm.txtLastNameNew.value?.text="";
    cnt_ReferFriendForm.txtContactNew.value?.text="";
    //Future.delayed(Duration.zero, () => ReferDialog(context));
    cnt_ReferFriendForm.fetchContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: _Globalrefereafriendkey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [

            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  ReferAForm_1(),
                  SizedBox(height: 70),
                ],
              ),
            ),
            cnt_CommonHeader.commonAppBar(
                REFER_A_FRIEND_APPBAR, _Globalrefereafriendkey,
                isNotificationHide: true,
                color: AppColors.NEWAPPBARCOLOR,
                ismenuiconhide: true)
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarClass(),
    );
  }

  Widget ReferAForm_1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(2, 6), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(

              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Container(
                      // margin: EdgeInsets.only(left: LEFT_PADDING, right: RIGHT_PADDING),
                      child: Form(
                        key: cnt_ReferFriendForm.formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            simpleTextFieldNewWithCustomization(
                                hintText: "John",
                                maxLength: 72,
                                imageIcon: IMG_USER_SVG_NEW,
                                textCapitalization:
                                TextCapitalization.sentences,
                                inputFormat: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[a-zA-Z]")),
                                  UpperCaseTextFormatter()
                                ],
                                controller: cnt_ReferFriendForm.txtFirstNameNew,
                                labelText: "First Name*",
                                isSuffixIcon: true,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: GestureDetector(
                                      onTap: (){
                                        cnt_ReferFriendForm.CheckContactPermission();
                                        // Get.to(()=>MyContacts());
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: SvgPicture.asset(
                                              IMG_CONTACT_US_SVG))),
                                ),
                                validator: (value) => validation(
                                    value, "Please enter first name")),
                            SizedBox(
                              height: 16,
                            ),

                            simpleTextFieldNewWithCustomization(
                                hintText: "Doe",
                                maxLength: 72,
                                imageIcon: IMG_USER_SVG_NEW,
                                textCapitalization:
                                TextCapitalization.sentences,
                                inputFormat: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[a-zA-Z]")),
                                  UpperCaseTextFormatter()
                                ],
                                controller: cnt_ReferFriendForm.txtLastNameNew,
                                labelText: "Last Name*",
                                validator: (value) => validation(
                                    value, "Please enter last name")),
                            SizedBox(
                              height: 16,
                            ),
                            PhoneNumberTextField(cnt_ReferFriendForm.txtContactNew),
                            SizedBox(
                              height: 16,
                            ),
                            simpleTextFieldNewWithCustomization(
                                hintText: "johndoe@example.com",
                                // imageIcon: IMG_MAIL_SVG,
                                imageIcon: IMG_EMAIL_SVG_NEW,
                                controller: cnt_ReferFriendForm.txtEmailNew,
                                labelText: "Email*",
                                validator: (value) => emailvalidation(value)),
                            SizedBox(
                              height: 16,
                            ),
                            CommonDropDownTextField(
                              labelText: "Budget*",
                              onTap: () {
                                cnt_ReferFriendForm.SelectBudget();
                              },
                              // imageIcon: IMG_DOLLAR_SVG,
                              imageIcon: IMG_BUDGET_SVG_NEW,
                              controller: cnt_ReferFriendForm.txtBudget,
                              hintText: 'select budget',
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            CategoryListData(),
                            SizedBox(
                              height: 16,
                            ),
                            CommonDropDownTextField(
                              labelText: "Location*",
                              onTap: () {
                                cnt_ReferFriendForm.SelectCity();
                              },
                              // imageIcon: IMG_CITY_SVG,
                              imageIcon: IMG_CITY_SVG_NEW,
                              controller: cnt_ReferFriendForm.txtCity,
                              hintText: "Select City",
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TC_CheckBox(),
                    SizedBox(
                      height: 60.h,
                    ),

                    SubmitButton_1(),
                    //SubmitButton_1()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CategoryListData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Category",
            style: TextStyle(
                color: NewAppColors.GREY,
                // fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        SizedBox(
          height: 11.h,
        ),
        Container(
          // height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // for(int i=0;i<CategoryList.length;i++)
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() => GestureDetector(
                    onTap: () {
                      cnt_ReferFriendForm.CategoryOption?.value = CategorySelect.Residential;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5.5),
                      decoration: BoxDecoration(
                          border:
                          Border.all(width: 1.5, color: DARK_BLUE),
                          shape: BoxShape.circle),
                      child: Center(
                        child: ClipOval(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                color: cnt_ReferFriendForm.CategoryOption?.value ==
                                    CategorySelect.Residential
                                    ? DARK_BLUE
                                    : white,
                                shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(width: 10),
                  Text("Residential",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color:
                          cnt_ReferFriendForm.CategoryOption?.value == CategorySelect.Residential
                              ? new_black_color
                              : gray_color_1,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp)),
                ],
              )),
              SizedBox(width: 20),
              Obx(() => Row(
                children: [
                  Obx(() => GestureDetector(
                    onTap: () {
                      cnt_ReferFriendForm.CategoryOption?.value = CategorySelect.Commercial;
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.5),
                      decoration: BoxDecoration(
                          border:
                          Border.all(width: 1.5, color: DARK_BLUE),
                          shape: BoxShape.circle),
                      child: Center(
                        child: ClipOval(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                color: cnt_ReferFriendForm.CategoryOption?.value ==
                                    CategorySelect.Commercial
                                    ? DARK_BLUE
                                    : white,
                                shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(width: 10),
                  Text("Commercial",
                      style: TextStyle(
                          color: cnt_ReferFriendForm.CategoryOption?.value == CategorySelect.Commercial
                              ? new_black_color
                              : gray_color_1,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp)
                    // TextStyle(fontSize: 15, color: gray_color_1,fontWeight: FontWeight.w500),
                  ),
                ],
              )),
            ],
          ),
        ),
        SizedBox(
          height: 11.h,
        ),
        Container(
          height: 1,
          width: Get.width,
          color: gray_color_1,
        )
      ],
    );
  }

  Widget TC_CheckBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.max,
      children: [
        Obx(() => Checkbox(

          value: cnt_ReferFriendForm.isSelected.value,
          onChanged: (value) {
            cnt_ReferFriendForm.isSelected.value = value!;
          },
          activeColor: DARK_BLUE.withOpacity(0.6),
          focusColor: LIGHT_GREY_COLOR,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.5),
              side: BorderSide(
                  color: gray_color_1,
                  width: 0.4,
                  style: BorderStyle.solid)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          side: BorderSide(
            width: 1.2,
            color: gray_color_1,
            // strokeAlign: StrokeAlign.center,
            style: BorderStyle.solid,
          ),
        )),
        SizedBox(width: 0),
        Text("${"I accept the"}",
            style: TextStyle(
                color: new_black_color,
                fontSize: 14.sp,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w700)),
        SizedBox(width: 4),
        GestureDetector(
          onTap: (){
            MoengageAnalyticsHandler().track_event("terms&conditions");
            Get.to(
                PrivacyTermPage(
                  title: "Terms & Conditions",
                ),
                preventDuplicates: false);
          },
          child: Text(termAndCondirionsText,
              style: TextStyle(
                  color: DARK_BLUE,
                  fontSize: 14.sp,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w700)),
        ),

      ],
    );
  }

  Widget SubmitButton_1() {
    return OnTapButton(
        onTap: () {
          if (cnt_ReferFriendForm.formkey.currentState!
              .validate() /* && isocode1.value!="" &&isocode1.value!="INDIA"*/) {
            cnt_ReferFriendForm.SubmitReferData();
          } else {
            if (isocode1.value == "" || isocode1.value == "INDIA") {
              // ErrorMsg("Please select country code", title: "");
            }
            // Get.to(DashboardPage());
          }
          if (cnt_ReferFriendForm.formkey.currentState!.validate()) {
            if (isocode1.value == "" && isocode == "") {
              // ErrorMsg("Please select country code", title: "");
            }

            // SuccessMsg("Submitted successfully", title: "Success");
            // Get.to(DashboardPage());
            Get.back();
          }
        },
        height: 40,
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit".toUpperCase(),
        style: TextStyle(
            color: white,
            fontSize: 14,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500));
  }

  Widget CoOwnerShimmerEffect() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder:(_,index){
              return   Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                      child: shimmerWidget(height: 100, width: Get.width, radius: 0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerWidget(height: 12, width: 50, radius: 0),
                          SizedBox(height: 10,),
                          shimmerWidget(height: 12, width:150, radius: 0),
                        ],
                      ),
                    )

                  ],
                ),
              );
            } )


    );
  }
}
