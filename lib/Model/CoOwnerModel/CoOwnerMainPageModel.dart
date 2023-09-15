class CoOwnerModel {
  String? id;
  String? image;
  String? contact;
  String? unitdetails;
  String? status;
  String? color;
  String? invitee;
  String? entry_date;
  String? inventorytypeid;
  String? buttonText;
  String? fullname;
  String? unitroletype;
  String? unitroletypeid;
  String? email;
  String? personemail;
  CoOwnerModel({
    this.id,
    this.image,
    this.contact,
    this.unitdetails,
    this.buttonText,
    this.inventorytypeid,
    this.status,
    this.entry_date,
    this.color,
    this.invitee,
    this.fullname,
    this.unitroletype,
    this.unitroletypeid,
    this.email,
    this.personemail,
  });

  CoOwnerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    contact = json['contact'];
    unitdetails = json['unitdetails'];
    status = json['status'];
    color = json['class'];
    invitee = json['invitee'];
    entry_date = json['entry_date'];
    inventorytypeid = json['inventorytypeid'];
    buttonText = json['buttonText'];
    fullname = json['fullname'];
    unitroletype = json['unitroletype'];
    unitroletypeid = json['unitroletypeid'].toString();
    email = json['email'];
    personemail = json['personemail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['contact'] = this.contact;
    data['unitdetails'] = this.unitdetails;
    data['status'] = this.status;
    data['class'] = this.color;
    data['invitee'] = this.invitee;
    data['entry_date'] = this.entry_date;
    data['inventorytypeid'] = this.inventorytypeid;
    data['buttonText'] = this.buttonText;
    data['fullname'] = this.fullname;
    data['unitroletype'] = this.unitroletype;
    data['unitroletypeid'] = this.unitroletypeid.toString();
    data['email'] = this.email;
    data['personemail'] = this.personemail;
    return data;
  }
}


class UnitDetailsListModal {
  String? projectid;
  String? project;
  String? inventorytypeid;
  String? inventorytype;
  String? plotid;
  String? plot;
  String? unitdetails;
  String? villaid;
  String? villa;

  UnitDetailsListModal({
    this.projectid,
    this.project,
    this.inventorytypeid,
    this.inventorytype,
    this.plotid,
    this.plot,
    this.unitdetails,
    this.villaid,
    this.villa,
  });

  UnitDetailsListModal.fromJson(Map<String, dynamic> json) {
    // debugger();
    projectid = json['projectid'];
    project = json['project'];
    inventorytypeid = json['inventorytypeid'];
    inventorytype = json['inventorytype'];
    plotid = json['plotid'];
    plot = json['plot'];
    unitdetails = json['unitdetails'];
    villaid = json['villaid'];
    villa = json['villa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['projectid'] = projectid;
    data['project'] = project;
    data['inventorytypeid'] = inventorytypeid;
    data['inventorytype'] = inventorytype;
    data['plotid'] = plotid;
    data['plot'] = plot;
    data['unitdetails'] = unitdetails;
    data['villaid'] = villaid;
    data['villa'] = villa;

    return data;
  }
}