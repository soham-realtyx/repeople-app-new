import 'package:Repeople/Controller/DashBoardHeaderController/DashboardHeaderController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/styles.dart';

class dashBoardHeader extends StatefulWidget {
  const dashBoardHeader({super.key});

  @override
  _dashBoardHeaderState createState() => _dashBoardHeaderState();
}

class _dashBoardHeaderState extends State<dashBoardHeader> {
  DashboardHeaderController cnt_DashboardHeader = Get.put(DashboardHeaderController());

  @override
  void initState() {
    super.initState();
    cnt_DashboardHeader.ListOfHedaer();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  cnt_DashboardHeader.arrDashBoardHeader[GLOBAL_THEME_INDEX.value].widget);
  }
}

class CustomDetailsAppBar extends StatefulWidget {
  late final String title;
  late final double height;
  Color? color;
  List<Widget>? leadingWidget;
  List<Widget>? trillingWidget;

  CustomDetailsAppBar(
      {super.key, required this.title,
      required this.height,
      this.leadingWidget,
      this.trillingWidget,
      this.color});

  @override
  _CustomDetailsAppBarState createState() => _CustomDetailsAppBarState();
}

class _CustomDetailsAppBarState extends State<CustomDetailsAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [fullcontainerboxShadow],
        color: widget.color /*== null ? Colors.white : widget.color*/,
      ),
      height: widget.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: widget.leadingWidget!,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: widget.trillingWidget!,
            ),
          )
        ],
      ),
    );
  }
}
