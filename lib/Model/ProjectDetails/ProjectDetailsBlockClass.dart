class ProjectDetailsModal {
  int? id;
  // String? sId;
  String? projectname;
  String? category;
  String? siteurl;
  int? isactive;
  String? address;
  String? landmark;
  String? area;
  String? location;
  String? entry_by;
  String? entrydate;
  String? longdesc;
  String? shortdesc;
  String? update_by;
  String? update_uid;
  String? updatedate;
  int? developercmpid;
  String? citystr;
  String? countrystr;
  String? latitude;
  String? locationdescription;
  String? longitude;
  String? pincodestr;
  String? rerastate;
  String? statestr;
  int? ishighpriority;
  String? constatusstr;
  String? constructionlevel;
  String? aboutdeveloper;
  // List<AuthorizedCP>? authorisedcp;
  // List<CategoryTypeArray>? categorytypearray;
  // List<ConstructionFundingArray>? constructionfunding;
  String? developername;
  String? devfeatureimg;
  String? devlogo;
  String? disclaimer;
  String? displayprice;
  String? displaysize;
  String? featureimg;
  // List<HomeLoans>? homeloans;
  int? invertorystatusid;
  String? invertorystatusstr;
  int? issoldout;
  String? logo;
  String? logosvg;
  String? slug;
  int? isreranotapplicable;
  int? displayorder;
  int? leadpolicyid;
  String? currencyname;
  String? maincurrencyid;
  String? mainmeasurementid;
  String? measurementname;
  int? allowrepeoplerequestunit;
  List<Attributes>? attributes;
  List<ReraRegistrations>? reraregistration;
  // List<LegalRegistrations>? legaldocument;
  // List<Brochure>? brochure;
  // List<NearByLocation>? nearbylocation;
  List<Highlights>? highlights;
  List<Amenities>? amenities;
  // List<Gallery>? gallery;


  ProjectDetailsModal(
      {

        this.id,
        // this.sId,
        this.projectname,
        this.category,
        this.siteurl,
        this.isactive,
        this.address,
        this.landmark,
        this.area,
        this.location,
        this.entry_by,
        this.entrydate,
        this.longdesc,
        this.shortdesc,
        this.update_by,
        this.update_uid,
        this.updatedate,
        this.developercmpid,
        this.citystr,
        this.countrystr,
        this.latitude,
        this.locationdescription,
        this.longitude,
        this.pincodestr,
        this.rerastate,
        this.statestr,
        this.ishighpriority,
        this.constatusstr,
        this.constructionlevel,
        this.aboutdeveloper,
        // this.authorisedcp,
        // this.categorytypearray,
        // this.constructionfunding,
        this.developername,
        this.devfeatureimg,
        this.devlogo,
        this.disclaimer,
        this.displayprice,
        this.displaysize,
        this.featureimg,
        // this.homeloans,
        this.invertorystatusid,
        this.invertorystatusstr,
        this.issoldout,
        this.logo,
        this.logosvg,
        this.slug,
        this.isreranotapplicable,
        this.displayorder,
        this.leadpolicyid,
        this.currencyname,
        this.maincurrencyid,
        this.mainmeasurementid,
        this.measurementname,
        this.allowrepeoplerequestunit,
        // this.attributes,
        // this.reraregistration,
        // this.legaldocument,
        // this.brochure,
        // this.nearbylocation,
        // this.highlights,
        // this.amenities,
        // this.gallery,
        // this.id,
        // this.sId,
        // this.name,
        // this.location,
        // this.featureimg,
        // this.flat,
        // this.attributes,
        // this.isfavourite,
      });

  ProjectDetailsModal.fromJson(Map<String, dynamic> json) {
    // debugger();
    id = json['id'];
    // sId = json['_id'];
    projectname = json['projectname'];
    category = json['category'];
    siteurl = json['siteurl'];
    isactive = json['isactive'];
    address = json['address'];
    landmark = json['landmark'];
    area = json['area'];
    location = json['location'];
    entry_by = json['entry_by'];
    entrydate = json['entrydate'];
    longdesc = json['longdesc'];
    shortdesc = json['shortdesc'];
    update_by = json['update_by'];
    update_uid = json['update_uid'];
    updatedate = json['updatedate'];
    developercmpid = json['developercmpid'];
    citystr = json['citystr'];
    countrystr = json['countrystr'];
    latitude = json['latitude'];
    locationdescription = json['locationdescription'];
    longitude = json['longitude'];
    pincodestr = json['pincodestr'];
    rerastate = json['rerastate'];
    statestr = json['statestr'];
    ishighpriority = json['ishighpriority'];
    constatusstr = json['constatusstr'];
    constructionlevel = json['constructionlevel'];
    // authorisedcp = json['authorisedcp'];
    // categorytypearray = json['categorytypearray'];
    // constructionfunding = json['constructionfunding'];
    developername = json['developername'];
    devfeatureimg = json['devfeatureimg'];
    devlogo = json['devlogo'];
    disclaimer = json['disclaimer'];
    aboutdeveloper = json['aboutdeveloper'];
    displayprice = json['displayprice'];
    displaysize = json['displaysize'];
    featureimg = json['featureimg'];
    // homeloans = json['homeloans'];
    invertorystatusid = json['invertorystatusid'];
    invertorystatusstr = json['invertorystatusstr'];
    issoldout = json['issoldout'];
    // reraregistration = json['reraregistration'];


    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(Attributes.fromJson(v));
      });
    }

    if (json['reraregistration'] != null) {
      reraregistration = <ReraRegistrations>[];
      json['reraregistration'].forEach((v) {
        reraregistration!.add(ReraRegistrations.fromJson(v));
      });
    }

    if (json['highlights'] != null) {
      highlights = <Highlights>[];
      json['highlights'].forEach((v) {
        highlights!.add(Highlights.fromJson(v));
      });
    }

    if (json['amenities'] != null) {
      amenities = <Amenities>[];
      json['amenities'].forEach((v) {
        amenities!.add(Amenities.fromJson(v));
      });
    }
  }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   // data['_id'] = sId;
  //   // data['name'] = name;
  //   data['location'] = location;
  //   if (attributes != null) {
  //     data['attributes'] = attributes!.map((v) => v.toJson()).toList();
  //   }
  //
  //   return data;
  // }
}


class Attributes {
  Projectid? projectid;
  int? id;
  String? project;
  String? category;
  String? unittype;
  String? configuration;
  String? carpetsize;
  String? price;
  int? showprice;
  String? showpricestr;
  int? showsize;
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

class ReraRegistrations {
  Projectid? projectid;
  int? id;
  String? possesiondate;
  String? name;
  String? reranumber;
  String? rerastateid;
  String? rerastate;
  String? description;
  String? reracertificate;
  String? entry_uid;
  String? entry_by;
  String? entrydate;
  // String? planimage;

  ReraRegistrations({
    this.projectid,
    this.id,
    this.possesiondate,
    this.name,
    this.reranumber,
    this.rerastateid,
    this.rerastate,
    this.description,
    this.reracertificate,
    this.entry_uid,
    this.entry_by,
    this.entrydate,
    // this.planimage,


  });

  ReraRegistrations.fromJson(Map<String, dynamic> json) {
    projectid = json['projectid'] != null? Projectid.fromJson(json['projectid']): null;
    id = json['id'];
    possesiondate = json['possesiondate'];
    name = json['name'];
    reranumber = json['reranumber'];
    rerastateid = json['rerastateid'];
    rerastate = json['rerastate'].toString();
    description = json['description'].toString();
    reracertificate = json['reracertificate'];
    entry_uid = json['entry_uid'];
    entry_by = json['entry_by'];
    entrydate = json['entrydate'];
    // planimage = json['planimage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (projectid != null) {
    //   data['projectid'] = projectid!.toJson();
    // }
    data['id'] = id;
    // data['project'] = project;
    data['possesiondate'] = possesiondate;
    data['name'] = name;
    data['reranumber'] = reranumber;
    data['rerastateid'] = rerastateid;
    data['rerastate'] = rerastate;
    data['description'] = description;
    data['reracertificate'] = reracertificate;
    data['entry_uid'] = entry_uid;
    data['entry_by'] = entry_by;
    data['entrydate'] = entrydate;
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

class Highlights {

  int? id;
  String? name;
  String? description;
  String? highlighticon;
  String? highlightimage;
  String? entry_uid;
  String? entry_by;
  String? entrydate;
  String? update_by;
  String? update_uid;
  String? updatedate;


  Highlights({

    this.id,
    this.name,
    this.description,
    this.highlighticon,
    this.highlightimage,
    this.entry_uid,
    this.entry_by,
    this.entrydate,
    this.update_by,
    this.update_uid,
    this.updatedate,



  });

  Highlights.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    name = json['name'];
    description = json['description'];
    highlighticon = json['highlighticon'];
    highlightimage = json['highlightimage'];
    entry_uid = json['entry_uid'];
    entry_by = json['entry_by'];
    entrydate = json['entrydate'];
    update_by = json['update_by'];
    update_uid = json['update_uid'];
    updatedate = json['updatedate'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['highlighticon'] = highlighticon;
    data['highlightimage'] = highlightimage;
    data['entry_uid'] = entry_uid;
    data['entry_by'] = entry_by;
    data['entrydate'] = entrydate;
    data['update_by'] = update_by;
    data['update_uid'] = update_uid;
    data['updatedate'] = updatedate;

    return data;
  }
}

class Amenities {

  int? id;
  String? name;
  String? imagetype;
  String? imagetypestr;
  String? description;
  String? amenityicon;
  String? amenityimage;
  String? entry_uid;
  String? entry_by;
  String? entrydate;
  String? update_by;
  String? update_uid;
  String? updatedate;



  Amenities({

    this.id,
    this.name,
    this.imagetype,
    this.imagetypestr,
    this.description,
    this.amenityicon,
    this.amenityimage,
    this.entry_uid,
    this.entry_by,
    this.entrydate,
    this.update_by,
    this.update_uid,
    this.updatedate,



  });

  Amenities.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    name = json['name'];
    imagetype = json['imagetype'];
    imagetypestr = json['imagetypestr'];
    description = json['description'];
    amenityicon = json['amenityicon'];
    amenityimage = json['amenityimage'];
    entry_uid = json['entry_uid'];
    entry_by = json['entry_by'];
    entrydate = json['entrydate'];
    update_by = json['update_by'];
    update_uid = json['update_uid'];
    updatedate = json['updatedate'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['imagetype'] = imagetype;
    data['imagetypestr'] = imagetypestr;
    data['description'] = description;
    data['amenityicon'] = amenityicon;
    data['amenityimage'] = amenityimage;
    data['entry_uid'] = entry_uid;
    data['entry_by'] = entry_by;
    data['entrydate'] = entrydate;
    data['update_by'] = update_by;
    data['update_uid'] = update_uid;
    data['updatedate'] = updatedate;

    return data;
  }
}