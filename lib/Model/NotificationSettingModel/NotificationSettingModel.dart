
import 'package:get/get.dart';

/*class NotificationSettingModel {
  String? notificationCategory;
  RxBool? isSelected=false.obs;

  NotificationSettingModel({
    this.notificationCategory,
    this.isSelected,
  });

  NotificationSettingModel.fromJson(String json) {
    notificationCategory = json;
    isSelected = false.obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationcategory'] = notificationCategory ?? "";
    data['isSelected'] = isSelected!.value;
    return data;
  }
}*/

class NotificationSettingModel {
  String? id;
  String? label;
  String? isUserNotification;
  RxBool? isSelected=false.obs;

  NotificationSettingModel({this.id, this.label, this.isUserNotification,this.isSelected});

  NotificationSettingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    isUserNotification = json['isusernotification'].toString();
    isSelected = false.obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['isusernotification'] = this.isUserNotification.toString();
    data['isSelected'] = isSelected!.value;
    return data;
  }
}


