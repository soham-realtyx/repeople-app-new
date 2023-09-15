
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/UpdatesController/UpdatesController.dart';
import 'package:Repeople/Model/UpdateModelClass/UpdateModelClass.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:shimmer/shimmer.dart';


class UpdateDetailsPage extends StatefulWidget {
  final int? index;
  UpdateDetailsPage( {this.index});

  @override
  _UpdateDetailsPageState createState() => _UpdateDetailsPageState();
}

class _UpdateDetailsPageState extends State<UpdateDetailsPage> {
  CommonHeaderController cnt_Header = Get.put(CommonHeaderController());
  UpdatesController cnt_updates = Get.put(UpdatesController());
  GlobalKey<ScaffoldState> UpdateDetailsscaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: UpdateDetailsscaffoldKey,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
      body: SafeArea(
          child: Stack(
            children: [

              SingleChildScrollView(child: updates_details()),
              cnt_Header.commonAppBar(UPDATES_APPMENUNAME_CAP, UpdateDetailsscaffoldKey,color: AppColors.NEWAPPBARCOLOR)
            ],
          )
      ),
    );
  }
  Widget updates_details() {
    UpdateModelClass obj = cnt_updates.arrUpdateList[widget.index!];
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20,top: 80),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(cornarradius),
                child: Container(
                    width: Get.width,
                    height: 190.h,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.5, color: white),
                      borderRadius:
                      BorderRadius.circular(7),
                    ),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(7),
                      child: CachedNetworkImage(
                        // width: Get.width-10,
                        placeholder: (context, url) =>
                            Shimmer.fromColors(
                                baseColor:
                                Colors.grey.shade300,
                                highlightColor:
                                Colors.grey.shade100,
                                enabled: true,
                                child: shimmerWidget(
                                    height: 180,
                                    width: Get.width,
                                    radius: 0)),
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        placeholderFadeInDuration:
                        Duration.zero,
                        imageUrl: obj.document ?? "",
                        fit: BoxFit.fill,
                        errorWidget:
                            (context, value, error) {
                          return Container(
                              color: Colors.grey.shade300,
                              child: GestureDetector(
                                  onTap: () {},
                                  child: Image.asset(
                                      cnt_updates.setImage(obj
                                          .extension
                                          .toString()))));
                        },
                      ),
                    ))),

            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 310,
              child: Text(obj.titile ?? "",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: DARK_BLUE,
                    fontWeight: FontWeight.w700,
                    fontFamily: fontFamily,
                  )),
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(obj.dateTime ?? "",
                style: TextStyle(
                    fontSize: 10.sp,
                    color: gray_color_1,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w600)),

            SizedBox(
              height: 10,
            ),
            //Text(obj.desc!,style:  TextStyle(
            Text(obj.description ?? "",
                style: TextStyle(
                    fontSize: 10.sp,
                    color: gray_color_1,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w600
                )),

            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
