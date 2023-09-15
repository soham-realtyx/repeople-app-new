
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Controller/ReferAFriendFormController/ReferAFriendFormController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/MyContactsController/MyContactsController.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:shimmer/shimmer.dart';
class MyContacts extends StatefulWidget {
  GlobalKey<ScaffoldState>? globalKey;
  MyContacts({Key? key,this.globalKey});

  @override
  _MyContactsState createState() => _MyContactsState();
}

class _MyContactsState extends State<MyContacts> {
  // MyContactsController cnt_Contacts = Get.put(MyContactsController());
  ReferAFriendFormController cnt_ReferFriendForm = Get.put(ReferAFriendFormController());
  CommonHeaderController cnt_HeaderController = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> _GlobalMyContactPage2key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    cnt_ReferFriendForm.mycontacts.refresh();
    cnt_ReferFriendForm.futureContactList2.value =cnt_ReferFriendForm.fetchContacts();
  }

  void _searchContacts(String query) {
    setState(() {
      cnt_ReferFriendForm.mycontacts.value = cnt_ReferFriendForm.mycontacts2
          .where((contact) =>
          contact.displayName.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<MyContactsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: _GlobalMyContactPage2key,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10,bottom: 10),
                    child: TextField(

                      onChanged: _searchContacts,
                      style: TextStyle(
                          color: BLACK,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: fontFamily
                      ),
                      decoration: InputDecoration(
                        // labelText: 'Search Contacts',
                        contentPadding: EdgeInsets.only(top: 10,bottom: 10),
                        hintText: "Search Contacts",
                        hintStyle: TextStyle(
                            color: gray_color_1,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: fontFamily
                        ),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  Obx(() => _myContactData())
                ],
              ),
            ),
            cnt_HeaderController.commonAppBar("Select Contacts",
                _GlobalMyContactPage2key,isNotificationHide: true,ismenuiconhide: true),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: BottomNavigationBarClass(),
            // )
          ],
        ),
      ),
    );
  }
  Widget _myContactData() {
    if (cnt_ReferFriendForm.permissionDenied.value) return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 250),
        Center(child: Text('Permission denied')),
      ],
    );

    return   Obx((){  return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          if(cnt_ReferFriendForm.mycontacts.isNotEmpty)
            return ListView.builder(
                itemCount: cnt_ReferFriendForm.mycontacts.length,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, i) {
                  String custmername = "${cnt_ReferFriendForm.mycontacts[i].displayName}".trim();
                  String firstletter = custmername.isNotEmpty ? custmername.trim().substring(0,1) : '';
                  Uint8List? image = cnt_ReferFriendForm.mycontacts[i].photo;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                          title: Text(
                            cnt_ReferFriendForm.mycontacts[i].displayName,
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: new_black_color
                            ),
                          ),
                          contentPadding: EdgeInsets.only(bottom: 6,top: 6,right: 20,left: 20),
                          leading: (cnt_ReferFriendForm.mycontacts[i].photo == null)
                              ? const CircleAvatar(backgroundColor: Colors.grey,child: Icon(Icons.person))
                              : CircleAvatar(backgroundImage: MemoryImage(image!)),
                          onTap: () async {
                            cnt_ReferFriendForm.contactNew.value =
                            (await FlutterContacts.getContact(cnt_ReferFriendForm.mycontacts[i].id))!;
                            print(cnt_ReferFriendForm.contactNew.value);
                            print("fullContact?.name");
                            //await Get.to(()=>ReferAFriendFormPage(contact: fullContact));
                            Get.back();
                            cnt_ReferFriendForm.Update();
                            // _GlobalMyContactPage2key.currentState?.dispose();
                          }),
                      Padding(
                        padding: EdgeInsets.only(left: 80,right: 20),
                        child: HorizontalDivider(
                            width: Get.width,
                            color: gray_color_1,
                            height: 1
                        ),
                      )
                    ],
                  );});
          else return CoOwnerShimmerEffect();
          // return CoOwnerShimmerEffect();
        } else {
          return CoOwnerShimmerEffect();
        }
      },
      future: cnt_ReferFriendForm.futureContactList2.value,
    );
    });
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
            }
        )
    );
  }

}
