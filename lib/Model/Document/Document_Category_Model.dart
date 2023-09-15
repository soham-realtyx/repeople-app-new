
class Doc_Cat_List{
  String? doc_cat_name;
  String? no_of_doc;
  bool? status;
  String?   ismodifyed;
  late List<DocumentsSubModel> documents_sub_list;
  Doc_Cat_List({ this.doc_cat_name, this.no_of_doc, this.status, this.ismodifyed,required this.documents_sub_list});



}

class DocumentsSubModel {
  String? id;
  String? imageurl;
  String? doc_name;


  // XFile? imageurl;

  DocumentsSubModel({this.id,this.imageurl,this.doc_name,});

  DocumentsSubModel.fromJson(Map<String, dynamic> json) {
    id=json['id'];
    imageurl = json['imageurl'];
    doc_name = json['doc_name'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageurl'] = this.imageurl;
    data['doc_name'] = this.doc_name;
    return data;
  }
}

class DocumentListMain {
  String? id;
  String? name;
  String? count;
  String? color;
  String? isvisible;
  String? documenttypeid;

  DocumentListMain({this.id, this.name, this.count, this.color,this.isvisible,this.documenttypeid});

  DocumentListMain.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
    color = json['color'];
    isvisible = json['isvisble'];
    documenttypeid = json['documenttypeid'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['count'] = this.count;
    data['color'] = this.color;
    data['isvisble'] = this.isvisible;
    data['documenttypeid'] = this.documenttypeid;
    return data;
  }
}
class DocumentCommonModel {
  String? id;
  String? documentname;
  String? islock;
  String? document_categoryid;
  String? document_category;


  DocumentCommonModel({this.id, this.documentname,this.islock,this.document_category,this.document_categoryid});

  DocumentCommonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    documentname = json['documentname'];
    islock = json['islock'].toString();
    document_category = json['document_category'];
    document_categoryid = json['document_categoryid'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['documentname'] = this.documentname;
    data['document_category'] = this.document_category;
    data['document_categoryid'] = this.document_categoryid;
    return data;
  }
}

//view document screen model class
class DocumentViewer {
  String? id;
  String? document;


  DocumentViewer({this.id, this.document});

  DocumentViewer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    document = json['document'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['document'] = this.document;
    return data;
  }
}