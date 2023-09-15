// class OffersModel{
//   int? id;
//   String? offertarget;
//   String? offertargetname;
//   String? offername;
//   String? offerdesc;
//   String? landscapeimg;
//   String? potraitimg;
//   String? offerattach;
//   String? offerstartdate;
//   String? offerenddate;
//   String? offerredirect;
//   String? offerterms;
//   String? offerreleasedate;
//   int? isactive;
//   String? entry_uid;
//   String? entry_by;
//   String? entry_date;
//   String? date_value;
//   String? fulllandscapeimg;
//   String? fullpotraitimg;
//   String? fullofferattach;
//
//   OffersModel({
//     this.id,
//     this.offertarget,
//     this.offertargetname,
//     this.offername,
//     this.offerdesc,
//     this.landscapeimg,
//     this.potraitimg,
//     this.offerattach,
//     this.offerstartdate,
//     this.offerenddate,
//     this.offerredirect,
//     this.offerterms,
//     this.offerreleasedate,
//     this.isactive,
//     this.entry_uid,
//     this.entry_by,
//     this.entry_date,
//     this.date_value,
//     this.fulllandscapeimg,
//     this.fullpotraitimg,
//     this.fullofferattach,
//
//   });
//
//   OffersModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     offertarget = json['offertarget'];
//     offertargetname = json['offertargetname'];
//     offername = json['offername'];
//     offerdesc = json['offerdesc'];
//     landscapeimg = json['landscapeimg'];
//     potraitimg = json['potraitimg'];
//     offerattach = json['offerattach'];
//     offerstartdate = json['offerstartdate'];
//     offerenddate = json['offerenddate'];
//     offerredirect = json['offerredirect'];
//     offerterms = json['offerterms'];
//     offerreleasedate = json['offerreleasedate'];
//     isactive = json['isactive'];
//     entry_uid = json['entry_uid'];
//     entry_by = json['entry_by'];
//     entry_date = json['entry_date'];
//     date_value = json['date_value'];
//     fulllandscapeimg = json['fulllandscapeimg'];
//     fullpotraitimg = json['fullpotraitimg'];
//     fullofferattach = json['fullofferattach'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['offertarget'] = this.offertarget;
//     data['offertargetname'] = this.offertargetname;
//     data['offername'] = this.offername;
//     data['offerdesc'] = this.offerdesc;
//     data['landscapeimg'] = this.landscapeimg;
//     data['potraitimg'] = this.potraitimg;
//     data['offerattach'] = this.offerattach;
//     data['offerstartdate'] = this.offerstartdate;
//     data['offerenddate'] = this.offerenddate;
//     data['offerredirect'] = this.offerredirect;
//     data['offerterms'] = this.offerterms;
//     data['offerreleasedate'] = this.offerreleasedate;
//     data['isactive'] = this.isactive;
//     data['entry_uid'] = this.entry_uid;
//     data['entry_by'] = this.entry_by;
//     data['entry_date'] = this.entry_date;
//     data['date_value'] = this.date_value;
//     data['fulllandscapeimg'] = this.fulllandscapeimg;
//     data['fullpotraitimg'] = this.fullpotraitimg;
//     data['fullofferattach'] = this.fullofferattach;
//
//     return data;
//   }
// }


class OffersModel{
  String? id;
  String? offername;
  String? offertarget;
  String? offertargetname;
  String? offerdesc;
  String? offerattach;
  String? landscapeimg;
  String? potraitimg;
  String? offerstartdate;
  String? offerenddate;
  String? offerredirect;
  String? offerterms;
  String? offerreleasedate;


  OffersModel({
    this.id,
    this.offertarget,
    this.offertargetname,
    this.offername,
    this.offerdesc,
    this.landscapeimg,
    this.potraitimg,
    this.offerattach,
    this.offerstartdate,
    this.offerenddate,
    this.offerredirect,
    this.offerterms,
    this.offerreleasedate,


  });

  OffersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    offertarget = json['offertarget'].toString();
    offertargetname = json['offertargetname'];
    offername = json['offername'];
    offerdesc = json['offerdesc'];
    landscapeimg = json['landscapeimg'];
    potraitimg = json['potraitimg'];
    offerattach = json['offerattach'];
    offerstartdate = json['offerstartdate'];
    offerenddate = json['offerenddate'];
    offerredirect = json['offerredirect'];
    offerterms = json['offerterms'];
    offerreleasedate = json['offerreleasedate'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['offertarget'] = this.offertarget;
    data['offertargetname'] = this.offertargetname;
    data['offername'] = this.offername;
    data['offerdesc'] = this.offerdesc;
    data['landscapeimg'] = this.landscapeimg;
    data['potraitimg'] = this.potraitimg;
    data['offerattach'] = this.offerattach;
    data['offerstartdate'] = this.offerstartdate;
    data['offerenddate'] = this.offerenddate;
    data['offerredirect'] = this.offerredirect;
    data['offerterms'] = this.offerterms;
    data['offerreleasedate'] = this.offerreleasedate;


    return data;
  }
}