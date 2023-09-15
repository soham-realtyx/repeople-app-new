
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProjectDetailsModalNew {
  String? coverimg;
  String? logosvg;
  String? featureimg;
  String? projectname;
  String? citystr;
  String? pincodestr;
  String? locationimg;
  String? area;
  List<ProjectDetailsBlock>? headarr;
  List<ConfigurationModal>? configuration;
  List<OverviewModal>? overview;
  List<ReraModal>? rera;
  List<BrochureModal>? brochure;
  DescriptionModal? description;
  LocationModal? location;
  AmenitiesModal? amenities;
  HighlightModal? highlight;
  GalleryModal? gallery;
  SiteProgressModal? siteprog;
  LayoutModal? layout;
  String? id;
  String? sId;
  String? isfavourite;

  ProjectDetailsModalNew(
      {
        this.coverimg,
        this.logosvg,
        this.featureimg,
        this.projectname,
        this.citystr,
        this.pincodestr,
        this.area,
        this.configuration,
        this.amenities,
        this.highlight,
        this.gallery,
        this.siteprog,
        this.layout,
        this.overview,
        this.rera,
        this.brochure,
        this.headarr,
        this.description,
        this.location,
        this.id,
        this.sId,
        this.isfavourite,
        this.locationimg,

      });

  ProjectDetailsModalNew.fromJson(Map<String, dynamic> json) {
    // debugger();
    coverimg = json['coverimg'].toString();
    logosvg = json['logosvg'].toString();
    featureimg = json['featureimg'];
    projectname = json['projectname'];
    citystr = json['citystr'];
    pincodestr = json['pincodestr'];
    locationimg = json['locationimg'];
    area = json['area'];

    // area = json['area'];

    if (json['configuration'] != null) {
      configuration = <ConfigurationModal>[];
      json['configuration'].forEach((v) {
        configuration!.add(ConfigurationModal.fromJson(v));
      });
    }
    if (json['overview'] != null) {
      overview = <OverviewModal>[];
      json['overview'].forEach((v) {
        if(v['data'].toString().contains("[")){
        overview!.add(OverviewModal.fromJson(v));
        }
      });
    }

    if (json['rera'] != null) {
      rera = <ReraModal>[];
      json['rera'].forEach((v) {
        rera!.add(ReraModal.fromJson(v));
      });
    }
    if (json['brochure'] != null) {
      brochure = <BrochureModal>[];
      json['brochure'].forEach((v) {
        brochure!.add(BrochureModal.fromJson(v));
      });
    }
    if (json['headarr'] != null) {
      headarr = <ProjectDetailsBlock>[];
      json['headarr'].forEach((v) {
        headarr!.add(ProjectDetailsBlock.fromJson(v));
      });

    }


    description = json['description'] != null? DescriptionModal.fromJson(json['description']): null;

    location = json['location'] != null? LocationModal.fromJson(json['location']): null;

    amenities = json['amenities'] != null? AmenitiesModal.fromJson(json['amenities']): null;

    highlight = json['highlight'] != null? HighlightModal.fromJson(json['highlight']): null;

    gallery = json['gallery'] != null? GalleryModal.fromJson(json['gallery']): null;


    siteprog = json['siteprog'] != null? SiteProgressModal.fromJson(json['siteprog']): null;

    layout = json['layout'] != null? LayoutModal.fromJson(json['layout']): null;

    id = json['id'].toString();
    sId = json['_id'].toString();
    isfavourite = json['isfavorite'].toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coverimg'] = coverimg;
    data['logosvg'] = logosvg;
    data['featureimg'] = featureimg;
    data['projectname'] = projectname;
    data['citystr'] = citystr;
    data['pincodestr'] = pincodestr;
    data['area'] = area;
    data['locationimg'] = locationimg;
    if (configuration != null) {
      data['configuration'] = configuration!.map((v) => v.toJson()).toList();
    }
 if (headarr != null) {
      data['headarr'] = headarr!.map((v) => v.toJson()).toList();
    }
if (overview != null) {
      data['overview'] = overview!.map((v) => v.toJson()).toList();
    }
// if (location != null) {
//       data['location'] = location!.map((v) => v.toJson()).toList();
//     }
if (rera != null) {
      data['rera'] = rera!.map((v) => v.toJson()).toList();
    }
if (brochure != null) {
      data['brochure'] = brochure!.map((v) => v.toJson()).toList();
    }

    if (description != null) {
      data['description'] = description!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (amenities != null) {
      data['amenities'] = amenities!.toJson();
    }
    if (highlight != null) {
      data['highlight'] = highlight!.toJson();
    }
    if (gallery != null) {
      data['gallery'] = gallery!.toJson();
    }

    data['id'] = id;
    data['_id'] = sId;
    data['isfavourite'] = isfavourite;

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

class ConfigurationModal {
  String? configuration;
  String? price;
  String? onward;


  ConfigurationModal({

    this.configuration,
    this.price,
    this.onward,
  });

  ConfigurationModal.fromJson(Map<String, dynamic> json) {
    configuration = json['configuration'];
    price = json['price'].toString();
    onward = json['onward'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['configuration'] = configuration;
    data['price'] = price;
    data['onward'] = onward;

    return data;
  }
}

class OverviewModal {
  String? lable;
 List<DataModal>? data1;



  OverviewModal({

    this.lable,
    this.data1,

  });

  OverviewModal.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];
    if (json['data'] != null && json['data'].length>0 && json['data'].toString().contains("[")) {
      print(json['data'].toString()+"our json dataaaa");
      data1 = <DataModal>[];
      json['data'].forEach((v) {
        data1!.add(DataModal.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lable'] = lable;
    // if (data != null) {
    //   data['data'] = this.data!.toJson();
    // }

    return data;
  }
}












class ProjectDetailsBlock {
  String? icon;
  String? title;
  String? details;


  ProjectDetailsBlock({

    this.icon,
    this.title,
    this.details,
  });

  ProjectDetailsBlock.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    title = json['title'].toString();
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = icon;
    data['title'] = title;
    data['details'] = details;

    return data;
  }
}

class LocationModal {
  String? lable;
  String? essentialslable;
  String? address;
  List<LatLongDataModal>? latlongdata;
  List<EssentialsModal>? essentials;


  LocationModal({
    this.lable,
    this.essentialslable,
    this.address,
    this.latlongdata,
    this.essentials,


  });

  LocationModal.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];
    essentialslable = json['essentialslable'];
    address = json['address'];
    if (json['latlongdata'] != null && json['latlongdata'].toString().contains("{")) {
      latlongdata = <LatLongDataModal>[];
      json['latlongdata'].forEach((v) {
        latlongdata!.add(LatLongDataModal.fromJson(v));
      });

    }
    if (json['essentials'] != null) {
      essentials = <EssentialsModal>[];
      json['essentials'].forEach((v) {
        essentials!.add(EssentialsModal.fromJson(v));
      });

    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lable'] = lable;
    data['essentialslable'] = essentialslable;
    data['address'] = address;
    if (latlongdata != null) {
      data['latlongdata'] = latlongdata!.map((v) => v.toJson()).toList();
    }
    if (essentials != null) {
      data['essentials'] = essentials!.map((v) => v.toJson()).toList();
    }



    return data;
  }
}
class DataModal {
  String? name;
  String? image;
  String? sitename;
  String? description;
  String? location;
  String? reranumber;
  String? reracertificate;
  String? reradescription;
  String? brochurename;
  String? brpermissionstr;
  String? brochurefile;


  DataModal({

    this.name,
    this.image,
    this.sitename,
    this.description,
    this.location,
    this.reranumber,
    this.reracertificate,
    this.reradescription,
    this.brochurename,
    this.brpermissionstr,
    this.brochurefile,
  });

  DataModal.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'].toString();
    sitename = json['sitename'].toString();
    description = json['description'].toString();
    location = json['location'].toString();
    reranumber = json['reranumber'].toString();
    reracertificate = json['reracertificate'].toString();
    reradescription = json['reradescription'].toString();
    brochurename = json['brochurename'].toString();
    brpermissionstr = json['brpermissionstr'].toString();
    brochurefile = json['brochurefile'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['sitename'] = sitename;
    data['description'] = description;
    data['location'] = location;
    data['reranumber'] = reranumber;
    data['reradescription'] = reradescription;
    data['brochurename'] = brochurename;
    data['brpermissionstr'] = brpermissionstr;
    data['brochurefile'] = brochurefile;

    return data;
  }
}

class AmenitiesModal {
  String? lable;
  List<AmenitiesDataModal>? amenitiesdata;

  AmenitiesModal({
    this.lable,
    this.amenitiesdata,

  });

  AmenitiesModal.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];

    if (json['data'] != null && json['data'].length>0 && json['data'].toString().contains("[")) {
      print(json['data'].toString()+"our json dataaaa");
      amenitiesdata = <AmenitiesDataModal>[];
      json['data'].forEach((v) {
        amenitiesdata!.add(AmenitiesDataModal.fromJson(v));
      });
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lable'] = lable;
    return data;
  }
}
class AmenitiesDataModal {
  String? name;
  String? description;
  String? amenityicon;
  String? amenityimage;
  String? imagetype;


  AmenitiesDataModal({

    this.name,
    this.description,
    this.amenityicon,
    this.amenityimage,
    this.imagetype,
  });

  AmenitiesDataModal.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'].toString();
    amenityicon = json['amenityicon'].toString();
    amenityimage = json['amenityimage'].toString();
    imagetype = json['imagetype'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['amenityicon'] = amenityicon;
    data['amenityimage'] = amenityimage;
    data['imagetype'] = imagetype;

    return data;
  }
}

class HighlightModal {
  String? lable;
  List<HighlightsDataModal>? highlightsdata;

  HighlightModal({
    this.lable,
    this.highlightsdata,

  });

  HighlightModal.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];

    if (json['data'] != null && json['data'].length>0 && json['data'].toString().contains("[")) {
      print(json['data'].toString()+"our json dataaaa");
      highlightsdata = <HighlightsDataModal>[];
      json['data'].forEach((v) {
        highlightsdata!.add(HighlightsDataModal.fromJson(v));
      });
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lable'] = lable;
    return data;
  }
}
class HighlightsDataModal {
  String? name;
  String? description;
  String? highlighticon;
  String? highlightimage;



  HighlightsDataModal({

    this.name,
    this.description,
    this.highlighticon,
    this.highlightimage,

  });

  HighlightsDataModal.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'].toString();
    highlighticon = json['highlighticon'].toString();
    highlightimage = json['highlightimage'].toString();


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['highlighticon'] = highlighticon;
    data['highlightimage'] = highlightimage;


    return data;
  }
}

class GalleryModal {
  String? lable;
  List<GalleryDataModal>? gallerydata;

  GalleryModal({
    this.lable,
    this.gallerydata,

  });

  GalleryModal.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];

    if (json['data'] != null && json['data'].length>0 && json['data'].toString().contains("[")) {
      print(json['data'].toString()+"our json dataaaa");
      gallerydata = <GalleryDataModal>[];
      json['data'].forEach((v) {
        gallerydata!.add(GalleryDataModal.fromJson(v));
      });
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lable'] = lable;
    return data;
  }
}
class GalleryDataModal {
  String? name;
  String? icon;
  String? imagetype;
  String? description;



  GalleryDataModal({

    this.name,
    this.icon,
    this.imagetype,
    this.description,

  });

  GalleryDataModal.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'].toString();
    imagetype = json['imagetype'].toString();
    description = json['description'].toString();


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['icon'] = icon;
    data['imagetype'] = imagetype;
    data['description'] = description;


    return data;
  }
}

class SiteProgressModal {
  String? lable;
  List<SiteProgressDataModal>? siteprogressdata;

  SiteProgressModal({
    this.lable,
    this.siteprogressdata,

  });

  SiteProgressModal.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];

    if (json['data'] != null && json['data'].length>0 && json['data'].toString().contains("[")) {
      print(json['data'].toString()+"our json dataaaa");
      siteprogressdata = <SiteProgressDataModal>[];
      json['data'].forEach((v) {
        siteprogressdata!.add(SiteProgressDataModal.fromJson(v));
      });
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lable'] = lable;
    return data;
  }
}
class SiteProgressDataModal {
  String? monthyear;
  String? sitename;
  String? icon;
  String? description;



  SiteProgressDataModal({

    this.monthyear,
    this.sitename,
    this.icon,
    this.description,

  });

  SiteProgressDataModal.fromJson(Map<String, dynamic> json) {
    monthyear = json['monthyear'];
    sitename = json['sitename'].toString();
    icon = json['icon'].toString();
    description = json['description'].toString();


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['monthyear'] = monthyear;
    data['sitename'] = sitename;
    data['icon'] = icon;
    data['description'] = description;


    return data;
  }
}

class LayoutModal {
  String? lable;
  List<LayoutDataModal>? layoutdata;

  LayoutModal({
    this.lable,
    this.layoutdata,

  });

  LayoutModal.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];

    if (json['data'] != null && json['data'].length>0 && json['data'].toString().contains("[")) {
      print(json['data'].toString()+"our json dataaaa");
      layoutdata = <LayoutDataModal>[];
      json['data'].forEach((v) {
        layoutdata!.add(LayoutDataModal.fromJson(v));
      });
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lable'] = lable;
    return data;
  }
}
class LayoutDataModal {
  String? layoutname;
  String? icon;
  String? layouttype;



  LayoutDataModal({

    this.layoutname,
    this.icon,
    this.layouttype,

  });

  LayoutDataModal.fromJson(Map<String, dynamic> json) {
    layoutname = json['layoutname'];
    icon = json['icon'].toString();
    layouttype = json['layouttype'].toString();


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['layoutname'] = layoutname;
    data['icon'] = icon;
    data['layouttype'] = layouttype;


    return data;
  }
}

class LatLongDataModal {
  String? name;
  String? latitude;
  String? longitude;
  String? projectlocation;
  String? marker_image;
  LatLng project_location=LatLng(0, 0);

  LatLongDataModal({

    this.name,
    this.latitude,
    this.longitude,
    this.marker_image,
    this.projectlocation,

  });

  LatLongDataModal.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    marker_image = json['icon'].toString();
    projectlocation = json['projectlocation'].toString();

    if (json['latitude'] != null && json['longitude'] != null) {
      project_location= LatLng(double.parse(latitude!), double.parse(longitude!));
      // essentials = <EssentialsModal>[];
      // json['essentials'].forEach((v) {
      //   essentials!.add(EssentialsModal.fromJson(v));
      // });
print(project_location.toString());
print("project_location");
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['projectlocation'] = projectlocation;


    return data;
  }
}

class EssentialsModal {
  String? count;
  String? name;

  EssentialsModal({

    this.count,
    this.name,

  });

  EssentialsModal.fromJson(Map<String, dynamic> json) {
    count = json['count'].toString();
    name = json['name'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['name'] = name;


    return data;
  }
}

class ReraModal {
  String? reranumber;
  String? description;

  ReraModal({

    this.reranumber,
    this.description,

  });

  ReraModal.fromJson(Map<String, dynamic> json) {
    reranumber = json['reranumber'].toString();
    description = json['price'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reranumber'] = reranumber;
    data['description'] = description;


    return data;
  }
}

class BrochureModal {
  String? brochurename;
  String? brpermissionstr;
  String? brochurefile;

  BrochureModal({

    this.brochurename,
    this.brpermissionstr,
    this.brochurefile,

  });

  BrochureModal.fromJson(Map<String, dynamic> json) {
    brochurename = json['brochurename'].toString();
    brpermissionstr = json['brpermissionstr'].toString();
    brochurefile = json['brochurefile'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brochurename'] = brochurename;
    data['brpermissionstr'] = brpermissionstr;
    data['brochurefile'] = brochurefile;


    return data;
  }
}

class DescriptionModal {
  Projectid? projectid;
  String? shortdesc;
  String? longdesc;


  DescriptionModal({
    this.projectid,
    this.shortdesc,
    this.longdesc,



  });

  DescriptionModal.fromJson(Map<String, dynamic> json) {
    projectid = json['projectid'] != null? Projectid.fromJson(json['projectid']): null;
    shortdesc = json['shortdesc'];
    longdesc = json['longdesc'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (projectid != null) {
      data['projectid'] = projectid!.toJson();
    }
    data['shortdesc'] = shortdesc;
    data['longdesc'] = longdesc;

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