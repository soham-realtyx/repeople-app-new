class PropertiesDetailsModel {
  PropertiesDetailModel2? data;

  String? message;
  int? status;

  PropertiesDetailsModel(
      {this.data, this.message, this.status});

  PropertiesDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? PropertiesDetailModel2.fromJson(json['data']) : null;

    message = json['message'];
    status = json['status'];
  }

  static List<PropertiesDetailsModel> fromJsonList(List<dynamic> JsonData) {
    List<PropertiesDetailsModel> list = List.empty(growable: true);
    for(var v in JsonData ){
      PropertiesDetailsModel detailsModel = PropertiesDetailsModel.fromJson(v);
      list.add(detailsModel);
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }

    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}


class PropertiesDetailModel2 {
  int? unitroletypeid;
  String? unitroletype;
  String? projectid;
  String? project;
  String? buildingid;
  String? building;
  String? floorid;
  String? floor;
  String? unitid;
  String? unit;
  String? fullflatdetails;
  String? projectlogo;
  String? coverimg;
  String? logosvg;
  String? featureimg;
  String? projectname;
  String? citystr;
  String? pincodestr;
  String? area;
  String? plot;
  String? inventorytypeid;
  String? inventorytype;
  String? villa;
  Gallery? gallery;
  Siteprogress? siteProgress;

  PropertiesDetailModel2(
      {this.unitroletypeid,
        this.unitroletype,
        this.projectid,
        this.project,
        this.buildingid,
        this.building,
        this.floorid,
        this.floor,
        this.unitid,
        this.unit,
        this.fullflatdetails,
        this.projectlogo,
        this.coverimg,
        this.logosvg,
        this.featureimg,
        this.projectname,
        this.citystr,
        this.pincodestr,
        this.inventorytypeid,
        this.inventorytype,
        this.plot,
        this.villa,
        this.gallery,
        this.siteProgress,
        this.area});

  PropertiesDetailModel2.fromJson(Map<String?, dynamic> json) {
    unitroletypeid = json['unitroletypeid'];
    unitroletype = json['unitroletype'];
    projectid = json['projectid'];
    project = json['project'];
    buildingid = json['buildingid'];
    building = json['building'];
    floorid = json['floorid'];
    floor = json['floor'];
    unitid = json['unitid'];
    unit = json['unit'];
    fullflatdetails = json['fullflatdetails'];
    projectlogo = json['projectlogo'];
    coverimg = json['coverimg'];
    logosvg = json['logosvg'];
    featureimg = json['featureimg'];
    projectname = json['projectname'];
    citystr = json['citystr'];
    pincodestr = json['pincodestr'];
    area = json['area'];
    inventorytypeid = json['inventorytypeid'];
    inventorytype = json['inventorytype'];
    plot = json['plot'];
    villa = json['villa'];
    gallery =
    json['gallery'] != null ? new Gallery.fromJson(json['gallery']) : null;
    siteProgress = json['siteprog'] != null
        ? new Siteprogress.fromJson(json['siteprog'])
        : null;
  }

  Map<String?, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitroletypeid'] = this.unitroletypeid;
    data['unitroletype'] = this.unitroletype;
    data['projectid'] = this.projectid;
    data['project'] = this.project;
    data['buildingid'] = this.buildingid;
    data['building'] = this.building;
    data['floorid'] = this.floorid;
    data['floor'] = this.floor;
    data['unitid'] = this.unitid;
    data['unit'] = this.unit;
    data['fullflatdetails'] = this.fullflatdetails;
    data['projectlogo'] = this.projectlogo;
    data['coverimg'] = this.coverimg;
    data['logosvg'] = this.logosvg;
    data['featureimg'] = this.featureimg;
    data['projectname'] = this.projectname;
    data['citystr'] = this.citystr;
    data['pincodestr'] = this.pincodestr;
    data['area'] = this.area;
    data['inventorytypeid'] = this.inventorytypeid;
    data['inventorytype'] = this.inventorytype;
    data['plot'] = this.plot;
    data['villa'] = this.villa;
    if (this.gallery != null) {
      data['gallery'] = this.gallery?.toJson();
    }
    if (this.siteProgress != null) {
      data['siteprog'] = this.siteProgress?.toJson();
    }
    return data;
  }
}

class Gallery {
  String? lable;
  List<GalleryListModel>? galleryListdata;

  Gallery({this.lable, this.galleryListdata});

  Gallery.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];
    if (json['data'] != null) {
      galleryListdata = <GalleryListModel>[];
      json['data'].forEach((v) {
        galleryListdata?.add(new GalleryListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lable'] = this.lable;
    if (this.galleryListdata != null) {
      data['data'] = this.galleryListdata?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Siteprogress {
  String? lable;
  List<SiteProgressModel>? SiteProgressListdata;

  Siteprogress({this.lable, this.SiteProgressListdata});

  Siteprogress.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];
    if (json['data'] != null) {
      SiteProgressListdata = <SiteProgressModel>[];
      json['data'].forEach((v) {
        SiteProgressListdata?.add(new SiteProgressModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lable'] = this.lable;
    if (this.SiteProgressListdata != null) {
      data['data'] = this.SiteProgressListdata?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class GalleryListModel {
  String? name;
  String? icon;
  String? imagetype;
  String? description;

  GalleryListModel({this.name, this.icon, this.imagetype, this.description});

  GalleryListModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    imagetype = json['imagetype'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['imagetype'] = this.imagetype;
    data['description'] = this.description;
    return data;
  }
}

class SiteProgressModel {
  String? monthyear;
  String? sitename;
  String? icon;
  String? description;

  SiteProgressModel({this.monthyear, this.sitename, this.icon, this.description});

  SiteProgressModel.fromJson(Map<String, dynamic> json) {
    monthyear = json['monthyear'];
    sitename = json['sitename'];
    icon = json['icon'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthyear'] = this.monthyear;
    data['sitename'] = this.sitename;
    data['icon'] = this.icon;
    data['description'] = this.description;
    return data;
  }
}