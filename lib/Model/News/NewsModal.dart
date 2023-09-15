// class NewsListModal{
//   String? image;
//   String? categoryname;
//   String? date;
//   String? descTitle;
//   String? desc;
//
//   NewsListModal(this.image,this.descTitle,this.date,this.desc,this.categoryname);
//
// }

// class NewsListModal {
//   int? id;
//   ImageModal? imagelist;
//   ThumbnailModal? thumbnaillist;
//   String? title;
//   String? description;
//   String? status;
//   String? datetime;
//
//
//   NewsListModal(
//       {this.id,
//         this.imagelist,
//         this.thumbnaillist,
//         this.title,
//         this.description,
//         this.status,
//         this.datetime,
//
//       });
//
//   NewsListModal.fromJson(Map<String, dynamic> json) {
//     // debugger();
//     id = json['id'];
//     if (json['image'] != null) {
//       imagelist=ImageModal.fromJson(json['image']);
//     }
//     if (json['thumbnail'] != null) {
//       //thumbnaillist = <ThumbnailModal>[];
//       // json['thumbnail'].forEach((v) {
//       // thumbnaillist!.add(ThumbnailModal.fromJson(v));
//       thumbnaillist=ThumbnailModal.fromJson(json);
//       // });
//     }
//     title = json['title'];
//     description = json['description'];
//     status = json['status'].toString();
//     datetime = json['datetime'];
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     if (imagelist != null) {
//       // data['image'] = imagelist!.map((v) => v.toJson()).toList();
//       data['image'] = imagelist!.toJson();
//     }
//     if (thumbnaillist != null) {
//       // data['thumbnail'] = thumbnaillist!.map((v) => v.toJson()).toList();
//       data['thumbnail'] = thumbnaillist!.toJson();
//     }
//     data['title'] = title;
//     data['description'] = description;
//     data['status'] = status;
//     data['datetime'] = datetime;
//     return data;
//   }
// }


class ImageModal {
  String? url;
  String? tag;
  int? id;

  ImageModal({
    this.url,
    this.tag,
    this.id,

  });

  ImageModal.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    tag = json['tag'];
    id = json['id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['tag'] = tag;
    data['id'] = id;
    return data;
  }
}

class ThumbnailModal {
  String? url;
  String? tag;
  int? id;

  ThumbnailModal({
    this.url,
    this.tag,
    this.id,

  });

  ThumbnailModal.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    tag = json['tag'];
    id = json['id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['tag'] = tag;
    data['id'] = id;
    return data;
  }
}

class NewsListModal {
  String? id;
  String? id_;
  String? title;
  String? newspublishdate;
  String? description;
  String? shortdescription;
  String? newsurl;
  String? displayorder;
  String? newsimage;
  String? isactive;
  String? newscategory;
  String? newssecondimage;


  NewsListModal(
      {this.id,
        this.id_,
        this.title,
        this.newspublishdate,
        this.description,
        this.shortdescription,
        this.newsurl,
        this.displayorder,
        this.newsimage,
        this.isactive,
        this.newscategory,
        this.newssecondimage,


      });

  NewsListModal.fromJson(Map<String, dynamic> json) {
    // debugger();
    id = json['id'].toString();
    id_ = json['_id'].toString();
    // if (json['image'] != null) {
    //   imagelist=ImageModal.fromJson(json['image']);
    // }
    // if (json['thumbnail'] != null) {
    //   //thumbnaillist = <ThumbnailModal>[];
    //   // json['thumbnail'].forEach((v) {
    //   // thumbnaillist!.add(ThumbnailModal.fromJson(v));
    //   thumbnaillist=ThumbnailModal.fromJson(json);
    //   // });
    // }
    title = json['title'];
    newspublishdate = json['newspublishdate'];
    description = json['description'];
    shortdescription = json['shortdescription'];
    newsurl = json['newsurl'].toString();
    displayorder = json['displayorder'].toString();
    newsimage = json['newsimage'];
    isactive = json['isactive'].toString();
    newscategory = json['newscategory'];
    newssecondimage = json['newssecondimage'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['_id'] = id_;
    // if (imagelist != null) {
    //   // data['image'] = imagelist!.map((v) => v.toJson()).toList();
    //   data['image'] = imagelist!.toJson();
    // }
    // if (thumbnaillist != null) {
    //   // data['thumbnail'] = thumbnaillist!.map((v) => v.toJson()).toList();
    //   data['thumbnail'] = thumbnaillist!.toJson();
    // }
    data['title'] = title;
    data['newspublishdate'] = newspublishdate;
    data['description'] = description;
    data['shortdescription'] = shortdescription;
    data['newsurl'] = newsurl;
    data['displayorder'] = displayorder;
    data['newsimage'] = newsimage;
    data['isactive'] = isactive;
    data['newscategory'] = newscategory;
    data['newssecondimage'] = newssecondimage;
    return data;
  }
}