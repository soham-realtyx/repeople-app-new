
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Repeople/Model/ProjectDetails/HighlightsModal.dart';


class VendorModel{
  String? name;
  String? count;
  List<VendorPersonModel>? person_list;
  VendorModel(this.name,  this.count, this.person_list);
}
class VendorPersonModel{
  String? name;
  String? count;
  String? mobile;
  VendorPersonModel( this.name,this.count, this.mobile);
}



class VendorsModalNew {
  String? id;
  String? projectname;
  List<RolesBlockModal>? roles;

  VendorsModalNew(
      {
        this.id,
        this.projectname,
        this.roles,

      });

  VendorsModalNew.fromJson(Map<String, dynamic> json) {
    // debugger();
    id = json['id'].toString();
    projectname = json['projectname'].toString();

    if (json['roles'] != null) {
      roles = <RolesBlockModal>[];
      json['roles'].forEach((v) {
        roles!.add(RolesBlockModal.fromJson(v));
      });
    }

    //description = json['description'] != null? DescriptionModal.fromJson(json['description']): null;

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['projectname'] = projectname;

    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}


class RolesBlockModal {
  String? id;
  String? name;
  List<VendorSublistModel>? vendors;
  String? icon;
  String? total;

  RolesBlockModal({
    this.id,
    this.name,
    this.vendors,
    this.icon,
    this.total,

  });

  RolesBlockModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['vendors'] != null && json['vendors'].length>0 && json['vendors'].toString().contains("[")) {
      print(json['vendors'].toString()+"our json dataaaa");
      vendors = <VendorSublistModel>[];
      json['vendors'].forEach((v) {
        vendors!.add(VendorSublistModel.fromJson(v));
      });
    }
    icon = json['icon'];
    total = json['total'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (vendors != null) {
      data['vendors'] = vendors!.map((v) => v.toJson()).toList();
    }
    data['icon'] = icon;
    data['total'] = total;
    return data;
  }
}

class VendorSublistModel {
  String? id;
  String? name;
  String? shortname;
  String? image;
  List<VendorMobileModel>? mobile;

  VendorSublistModel({
    this.id,
    this.name,
    this.shortname,
    this.image,

  });

  VendorSublistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortname = json['shortname'];
    image = json['image'].toString();
    if (json['mobile'] != null && json['mobile'].length>0 && json['mobile'].toString().contains("[")) {
      print(json['mobile'].toString()+"our json dataaaa");
      mobile = <VendorMobileModel>[];
      json['mobile'].forEach((v) {
        mobile!.add(VendorMobileModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['shortname'] = shortname;
    data['image'] = image;
    if (mobile != null) {
      data['mobile'] = mobile!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VendorMobileModel {
  String? mobileno;
  String? iswhatsApp;
  String? mobileverify;
  String? countrycode;
  String? countrycodestr;


  VendorMobileModel({
    this.mobileno,
    this.iswhatsApp,
    this.mobileverify,
    this.countrycode,
    this.countrycodestr,

  });

  VendorMobileModel.fromJson(Map<String, dynamic> json) {
    mobileno = json['mobileno'];
    iswhatsApp = json['iswhatsApp'];
    mobileverify = json['mobileverify'].toString();
    countrycode = json['countrycode'].toString();
    countrycodestr = json['countrycodestr'].toString();


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileno'] = mobileno;
    data['iswhatsApp'] = iswhatsApp;
    data['mobileverify'] = mobileverify;
    data['countrycode'] = countrycode;
    data['countrycodestr'] = countrycodestr;


    return data;
  }
}


