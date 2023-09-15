class ProjectModal {
  int? id;
  String? sId;
  String? name;
  String? location;
  String? featureimg;
  String? flat;
  bool? isfavourite;
  List<Attributes>? attributes;

  ProjectModal(
      {this.id,
        this.sId,
        this.name,
        this.location,
        this.featureimg,
        this.flat,
        this.attributes,
        this.isfavourite,
      });

  ProjectModal.fromJson(Map<String, dynamic> json) {
    // debugger();
    id = json['id'];
    sId = json['_id'];
    name = json['name'];
    location = json['location'];
    featureimg = json['featureimg'];
    flat = json['flat'];
    isfavourite = json['isfavourite'];

    if (json['projectarr'] != null) {
      attributes = <Attributes>[];
      json['projectarr'].forEach((v) {
        attributes!.add(Attributes.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['_id'] = sId;
    data['name'] = name;
    data['location'] = location;
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
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