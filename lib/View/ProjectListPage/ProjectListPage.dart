import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/ProjectController/ProjectController.dart';
import 'package:Repeople/Model/ProjectListModal/ProjectListModal.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/DashboardPage/DashboardPage.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  ProjectController cntProjectList = Get.put(ProjectController());
  CommonHeaderController cntCommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> globalProjectPageKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cntProjectList.trendingList.clear();
      cntProjectList.isTrending.value=0;
      cntProjectList.trendingList.clear();
      cntProjectList.isTrending.value = cntProjectList.trendingList.length-1;

      BottomNavigationBarClass().selectedIndex=1;
      cntProjectList.futurearrprojectlist.value = cntProjectList.RetrieveProjectData();
      cntProjectList.futurearrprojectlistnew.value= cntProjectList.futurearrprojectlist.value;
      cntProjectList.LoadPage();

    });
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        BottomNavigationBarClass().selectedIndex=0;
        Get.offAll(const DashboardPage());
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.BACKGROUND_WHITE,
        key: globalProjectPageKey,
        resizeToAvoidBottomInset: false,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox( height: 70),
                      projectListLabel(),
                      searchProjectTextField(),
                      trendingData(),
                      projectListData(),
                      const SizedBox( height: 80),
                    ],
                  ),
                ),

                cntCommonHeader.commonAppBar(
                    PROJECT_APPMENUNAME, globalProjectPageKey,
                    color: white),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomNavigationBarClass(selectedIndex: 1),
                )
              ],
            )),
      ),
    );
  }

  Widget projectListLabel() {
    return Container(
      // color: LIGHT_GRAY_COLOR,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      child: RichText(
        text: TextSpan(
            text: "Hello,",
            style: regularTextStyle(txtColor: new_black_color, fontSize: 21),
            children: <TextSpan>[
              TextSpan(
                  text: '\n$lblProjectListLabel ',
                  style:
                  boldTextStyle(txtColor: new_black_color, fontSize: 24)),
            ] // children:
        ),
      ),
    );
  }

  Widget searchProjectTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Autocomplete<ProjectListModal>(
        optionsBuilder: (value) {
          List<ProjectListModal> filter = [];
          if (value.text.isNotEmpty) {
            cntProjectList.onSearchTextChanged(value.toString());
            filter = cntProjectList.arrProjectlist
                .where((element) => element.projectname!
                .toLowerCase()
                .contains(value.text.toLowerCase()))
                .toList();
          }
          return filter;
        },
        displayStringForOption: (ProjectListModal value) => value.projectname!,
        initialValue: TextEditingValue.empty,
        onSelected: (value) {
          cntProjectList.onSearchTextChanged(value.projectname.toString());
        },
        optionsMaxHeight: Get.height / 3,
        fieldViewBuilder: (context, textController, focusNode, onSubmit) {
          return Container(
            decoration: BoxDecoration(boxShadow: [newcontainerboxShadow]),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(cornarradius),
              child: TextField(
                controller: textController,
                focusNode: cntProjectList.fcm_search,
                onSubmitted: (value) {
                  cntProjectList.onSearchTextChanged(value);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  cntProjectList.onSearchTextChanged(value);
                },
                onEditingComplete: () {
                  cntProjectList.onSearchTextChanged(textController.text);
                },
                onTap: () {
                  MoengageAnalyticsHandler().track_event("project_search");
                  cntProjectList.onSearchTextChanged(textController.text);
                },
                decoration: InputDecoration(
                    hintText: 'Search here',
                    hintStyle: regularTextStyle(
                        txtColor: HexColor("#333333"),
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 10, right: 20, top: 15, bottom: 15),
                    suffixIcon: InkWell(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          MediaQuery.of(context).viewInsets.bottom != 0.0
                              ? FocusManager.instance.primaryFocus?.unfocus()
                              : FocusManager.instance.primaryFocus
                              ?.requestFocus(cntProjectList.fcm_search);
                          cntProjectList.onSearchTextChanged(textController.text);
                        },
                        child: Container(
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            height: 28,
                            width: 28,
                            decoration: CustomDecorations().backgroundlocal(
                                APP_THEME_COLOR,
                                cornarradius,
                                0,
                                APP_THEME_COLOR),
                            child: SvgPicture.asset(
                              IMG_SEARCH_SVG_NEW_2,
                              color: white,
                            )))),
                cursorColor: Colors.black54,
              ),
            ),
          );
        },
        optionsViewBuilder: (context, function, list) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: Container(
                // padding: EdgeInsets.only(top: 0),
                height: Get.height / 3,
                width: Get.width - 40,
                decoration: BoxDecoration(
                  // boxShadow: [boxShadow],
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.WHITE),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        list.elementAt(index).projectname!,
                        style: regularTextStyle(
                            txtColor: HexColor("#b4b4b4"), fontSize: 14),
                      ),
                      onTap: () {
                        function(list.elementAt(index));
                        cntProjectList.onSearchTextChanged(list.elementAt(index).projectname!);
                      },
                    );
                  },
                  itemCount: list.length,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget trendingData() {
    return Container(
      padding: const EdgeInsets.only(top: 16,bottom: 11,left: 20,right: 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: Obx(() => Wrap(
          spacing: 8.0,
          runSpacing: 5.0,
          direction: Axis.horizontal,
          children: List.generate(
            cntProjectList.trendingList.length+1,
                (i) {

              if(i==0){
                return  GestureDetector(
                  onTap: (){
                    cntProjectList.isTrending.value = i-1;
                    cntProjectList.futurearrprojectlist.value=cntProjectList.RetrieveProjectData(trendingName: "false");
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(IMG_MAP_SEARCH_SVG_NEW),
                      Text(
                        "Trending",
                        style: TextStyle(
                            color: gray_color_1,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            fontFamily: fontFamily),
                      ),
                      const SizedBox(width: 0),
                    ],
                  ),
                );
              }else{
                return _trendingChildList(i-1);
              }
            },

          ),
        )),
      ),
    );
  }

  Widget _trendingChildList(int i){
    return GestureDetector(
      onTap: (){
        cntProjectList.isTrending.value = i;
        cntProjectList.onSearchTextChanged(cntProjectList.trendingList[i].toString());
        cntProjectList.futurearrprojectlist.refresh();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: cntProjectList.isTrending.value==i?DARK_BLUE:null,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border:  Border.all(
            color: gray_color_1,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                capitalizeFirstLetter(cntProjectList.trendingList[i].toString()),
                style: TextStyle(
                    color: cntProjectList.isTrending.value==i?white:gray_color_1,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    fontFamily: fontFamily),
              ),
            ),
            SvgPicture.asset(IMG_RIGHR_ARROW_SVG_NEW_2,color: cntProjectList.isTrending.value==i?white:gray_color_1,)
          ],
        ),
      ),
    );
  }

  Widget projectListData() {
    return Obx(() => FutureBuilder(
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          if (cntProjectList.arrProjectlist.isNotEmpty) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: cntProjectList.arrProjectlist.length,
                itemBuilder: (context, i) {
                  return _generateProjectListData1(i);
                });
          } else {
            return Container(
              height: Get.height / 2.5,
              width: Get.width,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Obx(() {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cntProjectList.message.value,
                      style: TextStyle(
                          color: AppColors.TEXT_TITLE, fontSize: 15),
                    ),
                  ],
                );
              }),
            );
          }
        } else {
          return projectShimmerWidget();
          // return Container();
        }
      },
      future: cntProjectList.futurearrprojectlist.value,
    ));
  }

  Widget _generateProjectListData1(int index) {
    ProjectListModal obj = cntProjectList.arrProjectlist[index];

    return GestureDetector(
      onTap: () {
        MoengageAnalyticsHandler().SendAnalytics(
            {"project_id": obj.sId, "project_name": obj.projectname},
            "project_details");
        cntProjectList.onNavigatornew(obj);
      },
      child: Container(
        height: 346.w,
        width: Get.width,
        margin: const EdgeInsets.only(bottom: 20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CarouselSlider.builder(
                carouselController: cntProjectList.controller_event,
                itemCount: obj.gallery?.gallaryListdata?.length,
                itemBuilder: (context, index2, realIndex) {
                  return InkWell(
                    onTap: () {
                    },
                    child: ClipRRect(
                        child: CachedNetworkImage(
                          height: 211.w,
                          width: Get.width,
                          placeholder: (context, url) => shimmerWidget(
                            height: 211.w,
                            width: Get.width,
                          ),
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          placeholderFadeInDuration: Duration.zero,
                          imageUrl:
                          obj.gallery?.gallaryListdata?[index2].icon ?? "",
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return SvgPicture.network(
                              // IMG_BUILD4,
                              obj.gallery?.gallaryListdata?[index2].icon ?? "",
                              // height: 250,
                              width: Get.width,
                              fit: BoxFit.cover,
                            );
                          },
                        )),
                  );
                },
                options: CarouselOptions(
                    autoPlay: true,
                    height: 211.w,
                    viewportFraction: 1,
                    onPageChanged: (index, _) {
                      cntProjectList.current.value = index;
                      cntProjectList.current.refresh();
                    }),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: Get.width,
                height: 164.w,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                // padding: EdgeInsets.only(top: 10.w,bottom: 10.w,right: 8.w,left: 8.w),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [newcontainerboxShadow]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.w,right: 8.w,left: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              width: 84.w,
                              height: 84.w,
                              placeholder: (context, url) => shimmerWidget(
                                  width: 84, height: 84, radius: 10),
                              fadeInDuration: Duration.zero,
                              fadeOutDuration: Duration.zero,
                              placeholderFadeInDuration: Duration.zero,
                              imageUrl: obj.featureimg ?? "",
                              fit: BoxFit.fill,
                              errorWidget: (context, url, error) {
                                return SvgPicture.network(obj.featureimg ?? "",
                                    width: 84.w,
                                    height: 84.w,
                                    fit: BoxFit.fill);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(obj.projectname ?? "",
                                  style: boldTextStyle(
                                      fontSize: 15, txtColor: DARK_BLUE)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(obj.area ?? "",
                                  style: mediumTextStyle(
                                      fontSize: 10, txtColor: new_black_color)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    obj.configurationList!=null?SizedBox(
                      height: 42.w,
                      // alignment: Alignment.centerLeft,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount:  obj.configurationList?.length,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(right: 8.w,left: 8.w),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int i) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.h, vertical: 6.w),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 0),
                                    color:
                                    APP_THEME_COLOR.withOpacity(0.1),
                                    spreadRadius: 0
                                )
                              ],
                              color: hex("F5F6FA"),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  obj.configurationList![i].configuration??"",
                                  style: boldTextStyle(
                                      fontSize: 10, txtColor: DARK_BLUE),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      obj.configurationList![i].price??"",
                                      style: boldTextStyle(
                                          fontSize: 10,
                                          txtColor: hex("707070")),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      obj.configurationList![i].onward??"",
                                      style: regularTextStyle(
                                          fontSize: 10,
                                          txtColor: hex("707070")),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                          // :SizedBox();
                        },
                      ),
                    ):const SizedBox()

                  ],
                ),
              ),
            ),
            Positioned(
              // right: index.isEven?10:25,
              right: 24,
              top: 25,
              child: GestureDetector(
                onTap: () {
                  obj.isfavorite.toString() == "1"
                      ? MoengageAnalyticsHandler().SendAnalytics({
                    "project_name": obj.projectname ?? "",
                    "project_id": obj.sId ?? ""
                  }, "project_favorite")
                      : MoengageAnalyticsHandler().SendAnalytics({
                    "project_name": obj.projectname ?? "",
                    "project_id": obj.sId ?? ""
                  }, "project_unfavorite");
                  if (cntProjectList.islogin.isTrue) {
                    cntProjectList.AddFavoriteProjectData(obj, index);
                    cntProjectList.arrProjectlist.refresh();
                  } else {
                    cntProjectList.LoginDialog();
                  }
                },
                child: Container(
                    height: 35,
                    width: 35,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: HexColor("#FFFFFF").withOpacity(0.8),
                    ),
                    child: obj.isfavorite.toString() == "1"
                        ? SvgPicture.asset(IMG_FAVORITE_SVG_2)
                        : SvgPicture.asset(
                      IMG_FAVORITE_SVG,
                      // color: WHITE,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget projectShimmerWidget() {
    return ShimmerEffect(
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              // height: Get.height,
                padding: EdgeInsets.only(top:index==0?10:0,bottom: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    shimmerWidget(
                        height: 211.h, width: Get.width, radius: 10),
                  ],
                ));
          },
          itemCount: 6,
        ));
  }

}
