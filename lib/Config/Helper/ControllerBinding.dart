import 'package:get/get.dart';

import '../../Controller/BottomNavigator/BottomNavigatorController.dart';

class ControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(BottomNavigatorController());
    // Get.lazyPut(() => BottomNavigationBarController());
  }
}