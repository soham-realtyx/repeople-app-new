
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Config/Constant.dart';

BuildContext? _appLoaderContext;

appLoader(BuildContext context){
  showGeneralDialog(context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    pageBuilder: (_, __, ___) {
      _appLoaderContext = context;
      return Align(
        alignment: Alignment.center,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(45),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox.expand(
                child: Image.asset(LOADER_ICON,
                    height: 80, width: 80)),
          ),
        ),
      );
    },);
}

void removeAppLoader(BuildContext context) {
  if (_appLoaderContext != null) {
    
    Get.back();
  }
  // Navigator.of(context, rootNavigator: false).pop('dialog');
}