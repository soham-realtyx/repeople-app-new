class ProjectListModal {
  String? id;
  String? sId;
  String? citystr;
  String? projectname;
  String? constatusstr;
  String? categorytypestr;
  String? pincodestr;
  String? area;
  String? featureimg;
  String? coverimg;
  String? logosvg;
  String? pincode;
  String? constructiontotalpercentage;
  String? displayorder;
  String? isactive;
  String? isactivecls;
  // String? price;
  String? isfavorite;
  List<Attributes>? attributes;
  List<Configuration>? configurationList;

  Gallery? gallery;
  ProjectListModal(
      {this.id,
        this.sId,
        this.citystr,
        this.projectname,
        this.constatusstr,
        this.pincodestr,
        this.area,
        this.featureimg,
        this.coverimg,
        this.logosvg,
        this.pincode,
        this.constructiontotalpercentage,
        this.displayorder,
        this.isactive,
        this.isactivecls,
        this.isfavorite,
        this.attributes,
        // this.price,
        this.gallery,
        this.configurationList,
      });

  ProjectListModal.fromJson(Map<String, dynamic> json) {
    // debugger();
    id = json['id'].toString();
    sId = json['_id'].toString();
    citystr = json['citystr'];
    projectname = json['projectname'];
    constatusstr = json['constatusstr'];
    pincodestr = json['pincodestr'];
    area = json['area'];
    featureimg = json['featureimg'];
    coverimg = json['coverimg'];
    logosvg = json['logosvg'];
    pincode = json['pincode'];
    constructiontotalpercentage = json['constructiontotalpercentage'].toString();
    displayorder = json['displayorder'].toString();
    isactive = json['isactive'];
    isactivecls = json['isactivecls'];
    isfavorite = json['isfavorite'].toString();
    // configuration = json['configuration'];
    // price = json['price'];
    // area = json['area'];
    gallery =
    json['gallery'] != null ? new Gallery.fromJson(json['gallery']) : null;
    if (json['projectarr'] != null) {
      attributes = <Attributes>[];
      json['projectarr'].forEach((v) {
        attributes!.add(Attributes.fromJson(v));
      });
    }
    if (json['configuration'] != null) {
      configurationList = <Configuration>[];
      json['configuration'].forEach((v) {
        configurationList?.add(new Configuration.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['_id'] = sId;
    data['citystr'] = citystr;
    data['projectname'] = projectname;
    data['constatusstr'] = constatusstr;
    data['pincodestr'] = pincodestr;
    data['area'] = area;
    data['featureimg'] = featureimg;
    data['coverimg'] = coverimg;
    data['logosvg'] = logosvg;
    data['pincode'] = pincode;
    data['constructiontotalpercentage'] = constructiontotalpercentage;
    data['displayorder'] = displayorder;
    data['isactive'] = isactive;
    data['isactivecls'] = isactivecls;
    data['isfavorite'] = isfavorite;
    // data['configuration'] = configuration;
    // data['price'] = price;
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    if (this.gallery != null) {
      data['gallery'] = this.gallery?.toJson();
    }
    if (this.configurationList != null) {
      data['configuration'] =
          this.configurationList?.map((v) => v.toJson()).toList();
    }

    return data;
  }
}


class Attributes {
  Projectid? projectid;
  String? id;
  String? project;
  String? category;
  String? unittype;
  String? configuration;
  String? carpetsize;
  String? price;
  int? showprice;
  String? showpricestr;
  String? showsize;
  String? showsizestr;
  String? planimage;

  Attributes({
    this.projectid,
    this.id,
    this.project,
    this.category,
    this.unittype,
    this.configuration,
    this.carpetsize,
    this.price,
    this.showprice,
    this.showpricestr,
    this.showsize,
    this.showsizestr,
    this.planimage,


  });

  Attributes.fromJson(Map<String, dynamic> json) {
    projectid = json['projectid'] != null? Projectid.fromJson(json['projectid']): null;
    id = json['id'];
    project = json['project'];
    category = json['category'];
    unittype = json['unittype'];
    configuration = json['configuration'];
    carpetsize = json['carpetsize'].toString();
    price = json['price'].toString();
    showprice = json['showprice'];
    showpricestr = json['showpricestr'];
    showsize = json['showsize'];
    showsizestr = json['showsizestr'];
    planimage = json['planimage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (projectid != null) {
      data['projectid'] = projectid!.toJson();
    }
    data['id'] = id;
    data['project'] = project;
    data['category'] = category;
    data['unittype'] = unittype;
    data['configuration'] = configuration;
    data['carpetsize'] = carpetsize;
    data['price'] = price;
    data['showprice'] = showprice;
    data['showpricestr'] = showpricestr;
    data['showsize'] = showsize;
    data['showsizestr'] = showsizestr;
    data['planimage'] = planimage;
    return data;
  }
}


class Projectid {
  String? oid;

  Projectid({this.oid});

  Projectid.fromJson(Map<String, dynamic> json) {
    oid = json['$oid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['$oid'] = oid;
    return data;
  }
}
class Configuration {
  String? configuration;
  String? price;
  String? onward;

  Configuration({this.configuration, this.price, this.onward});

  Configuration.fromJson(Map<String, dynamic> json) {
    configuration = json['configuration'];
    price = json['price'];
    onward = json['onward'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['configuration'] = this.configuration;
    data['price'] = this.price;
    data['onward'] = this.onward;
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
