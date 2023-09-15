
class AwardsNewModal {
  String? id;
  String? id_;
  String? awardname;
  String? rank;
  String? shortdescription;
  String? longdescription;
  String? displayorder;
  String? isactive;
  String? awardimg;
  String? awardcategory;

  AwardsNewModal(
      {this.id,
        this.id_,
        this.awardname,
        this.rank,
        this.shortdescription,
        this.longdescription,
        this.displayorder,
        this.isactive,
        this.awardimg,
        this.awardcategory
      });

  AwardsNewModal.fromJson(Map<String, dynamic> json) {
    // debugger();
    id = json['id'];
    id_ = json['_id'];
    // if (json['image'] != null) {
    //   imagelist=ImageModal.fromJson(json['image']);
    // }
    awardname = json['awardname'];
    rank = json['rank'].toString();
    shortdescription = json['shortdescription'];
    longdescription = json['longdescription'];
    displayorder = json['displayorder'].toString();
    isactive = json['isactive'].toString();
    awardimg = json['awardimg'];
    awardcategory = json['awardcategory'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['_id'] = id_;
    // if (imagelist != null) {
    //   // data['image'] = imagelist!.map((v) => v.toJson()).toList();
    //   data['image'] = imagelist!.toJson();
    // }
    data['awardname'] = awardname;
    data['rank'] = rank;
    data['shortdescription'] = shortdescription;
    data['longdescription'] = longdescription;
    data['displayorder'] = displayorder;
    data['isactive'] = isactive;
    data['awardimg'] = awardimg;
    data['awardcategory'] = awardcategory;
    return data;
  }
}