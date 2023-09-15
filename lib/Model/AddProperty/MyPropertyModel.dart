class MyPropertyList {
  int? index;
  String? projectid;
  String? project;
  String? inventorytypeid;
  String? inventorytype;
  String? plotid;
  String? plot;
  String? unitdetails;
  String? building;
  String? floorid;
  String? floor;
  String? unitid;
  String? unit;
  String? buildingid;
  String? name;
  String? unitroletype;
  Gallery? gallery;
  String? villaid;
  String? villa;
  String? unitroletypeid;
  String? area;
  String? coverimg;
  String? logosvg;
  String? featureimg;

  MyPropertyList(
      {
        this.index,
        this.projectid,
        this.project,
        this.inventorytypeid,
        this.inventorytype,
        this.plotid,
        this.plot,
        this.unitdetails,
        this.buildingid,
        this.building,
        this.floorid,
        this.floor,
        this.unitid,
        this.unit,
        this.name,
        this.unitroletype,
        this.gallery,
        this.area,
        this.coverimg,
        this.featureimg,
        this.logosvg,
        this.unitroletypeid,
        this.villa,
        this.villaid
      });

  MyPropertyList.fromJson(Map<String, dynamic> json) {

    index = json['index'];
    projectid = json['projectid'];
    project = json['project'];
    inventorytypeid = json['inventorytypeid'];
    inventorytype = json['inventorytype'];
    plotid = json['plotid'];
    plot = json['plot'];
    unitdetails = json['unitdetails'];
    inventorytype = json['inventorytype'];
    buildingid = json['buildingid'];
    building = json['building'];
    floorid = json['floorid'];
    floor = json['floor'];
    unitid = json['unitid'];
    unit = json['unit'];
    unitroletype = json['unitroletype'];
    villaid = json['villaid'];
    villa = json['villa'];
    unitroletypeid = json['unitroletypeid'].toString();
    area = json['area'];
    coverimg = json['coverimg'];
    featureimg = json['featureimg'];

    if(json['plot']!=null && json['plot']!=""){
      name = json['plot'];
    }
    if(json['floor']!=null && json['floor']!=""){
      name = json['floor'];
    }
    if(json['unit']!=null && json['unit']!=""){
      name = json['unit'];
    }
    gallery =
    json['gallery'] != null ? new Gallery.fromJson(json['gallery']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //   data['index'] = this.index;
    data['projectid'] = this.projectid;
    if(this.project!=null)
      data['project'] = this.project;
    if(this.inventorytypeid!=null)
      data['inventorytypeid'] = this.inventorytypeid;
    if(this.inventorytype!=null)
      data['inventorytype'] = this.inventorytype;
    if(this.plotid!=null)
      data['plotid'] = this.plotid;
    if(this.plot!=null)
      data['plot'] = this.plot;
    if(this.unitdetails!=null)
      data['unitdetails'] = this.unitdetails;
    if(this.buildingid!=null)
      data['buildingid'] = this.buildingid;
    if(this.building!=null)
      data['building'] = this.building;
    if(this.floorid!=null)
      data['floorid'] = this.floorid;
    if(this.floor!=null)
      data['floor'] = this.floor;
    if(this.unitid!=null)
      data['unitid'] = this.unitid;
    if(this.unit!=null)
      data['unit'] = this.unit;
    if(this.unitroletype!=null)
      data['unitroletype'] = this.unitroletype;
    if(this.villaid!=null)
      data['villaid'] = this.villaid;
    if(this.villa!=null)
      data['villa'] = this.villa;
    if(this.unitroletypeid!=null)
      data['unitroletypeid'] = this.unitroletypeid.toString();
    if(this.area!=null)
      data['area'] = this.area;
    if(this.coverimg!=null)
      data['coverimg'] = this.coverimg;
    if(this.logosvg!=null)
      data['logosvg'] = this.logosvg;
    if(this.featureimg!=null)
      data['featureimg'] = this.featureimg;
    if (this.gallery != null) {
      data['gallery'] = this.gallery?.toJson();
    }
    return data;
  }
}

class Gallery {
  String? lable;
  List<GalleryData>? gallaryListdata;

  Gallery({this.lable, this.gallaryListdata});

  Gallery.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];
    if (json['data'] != null) {
      gallaryListdata = <GalleryData>[];
      json['data'].forEach((v) {
        gallaryListdata?.add(new GalleryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lable'] = this.lable;
    if (this.gallaryListdata != null) {
      data['data'] = this.gallaryListdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GalleryData {
  String? name;
  String? icon;
  String? imagetype;
  String? description;

  GalleryData({this.name, this.icon, this.imagetype, this.description});

  GalleryData.fromJson(Map<String, dynamic> json) {
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