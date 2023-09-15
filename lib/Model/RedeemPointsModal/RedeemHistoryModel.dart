class RedeemHistoryModel {
  String? id;
  String? name;
  String? category;
  int? redeemamount;
  String? redeemamountstr;
  String? date;
  String? status;
  String? class1;
  String? vouchercode;

  RedeemHistoryModel({this.id, this.name,this.vouchercode, this.category, this.redeemamount, this.redeemamountstr, this.date, this.status, this.class1});

  RedeemHistoryModel.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  category = json['category'];
  redeemamount = json['redeemamount'];
  redeemamountstr = json['redeemamountstr'];
  date = json['date'];
  status = json['status'];
  class1 = json['class'];
  vouchercode = json['vouchercode'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['name'] = this.name;
  data['category'] = this.category;
  data['redeemamount'] = this.redeemamount;
  data['redeemamountstr'] = this.redeemamountstr;
  data['date'] = this.date;
  data['status'] = this.status;
  data['class'] = this.class1;
  data['vouchercode'] = this.vouchercode;
  return data;
  }
}