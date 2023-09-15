import 'package:get/get.dart';

class RefferAFriendTermsAndConditionModel {
  String? id;
  String? title;
  String? description;
  RxBool? isOpen=false.obs;

  RefferAFriendTermsAndConditionModel({this.id, this.title, this.description,this.isOpen});

  RefferAFriendTermsAndConditionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isOpen?.value =json['isOpen']=false;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['isOpen'] = this.isOpen?.value=false;
    return data;
  }
}