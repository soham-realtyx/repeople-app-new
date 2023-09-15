class RedeemListModel {
  String? id;
  String? name;
  String? icon;
  List<Vouchers>? vouchers;

  RedeemListModel({this.id, this.name, this.vouchers,this.icon});

  RedeemListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    if (json['vouchers'] != null) {
      vouchers = <Vouchers>[];
      json['vouchers'].forEach((v) {
        vouchers!.add(new Vouchers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    if (this.vouchers != null) {
      data['vouchers'] = this.vouchers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vouchers {
  String? id;
  int? productID;
  int? amounttype;
  List<String>? amounttypeoption;
  String? name;
  String? image;
  String? description;
  String? termsandconditions;

  Vouchers(
      {this.id,
        this.productID,
        this.amounttype,
        this.amounttypeoption,
        this.name,
        this.image,
        this.description,
        this.termsandconditions});

  Vouchers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productID = json['productID'];
    amounttype = json['amounttype'];
    amounttypeoption = json['amounttypeoption'].cast<String>();
    name = json['name'];
    image = json['image'];
    description = json['description'];
    termsandconditions = json['termsandconditions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productID'] = this.productID;
    data['amounttype'] = this.amounttype;
    data['amounttypeoption'] = this.amounttypeoption;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['termsandconditions'] = this.termsandconditions;
    return data;
  }
}