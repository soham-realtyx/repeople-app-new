
class MyBuildingDirectoryModel{
  String? project_name;
  List<CategoryName>? Categoryname;

  MyBuildingDirectoryModel({
    this.project_name,
    this.Categoryname
  });

  MyBuildingDirectoryModel.fromJson(Map<String, dynamic> json) {
    project_name = json['project_name'];
    Categoryname = json['Categoryname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_name'] = this.project_name;
    data['CategoryName'] = this.Categoryname;
    return data;
  }

}

class User{
  String? name;
  String? category;
  String? images;
  String? blockno;
  String? ownership;
  String? mobileno;
  String? color;

  User({
    this.name,
    this.category,
    this.blockno,
    this.ownership,
    this.images,
    this.mobileno,
    this.color
  });

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    category = json['category'];
    blockno = json['blockno'];
    ownership = json['ownership'];
    images = json['images'];
    mobileno = json['mobileno'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['category'] = this.category;
    data['blockno'] = this.blockno;
    data['ownership'] = this.ownership;
    data['images'] = this.images;
    data['mobileno'] = this.mobileno;
    data['color'] = this.color;
    return data;
  }

}


class CategoryName{
  String? categoryicon;
  String? categoryname;
  List<User>? udata;

  CategoryName({
    this.udata,
    this.categoryicon,
    this.categoryname,

  });

  CategoryName.fromJson(Map<String, dynamic> json) {
    categoryicon = json['categoryicon'];
    categoryname = json['categoryname'];
    udata = json['udata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryicon'] = this.categoryicon;
    data['categoryname'] = this.categoryname;
    data['udata'] = this.udata;
    return data;
  }
}
class DirectoryListModal {
  String? id;
  String? personname;
  String? profile;
  String? mobile;
  String? countrycode;
  String? countrycodestr;
  String? role;
  List<String>? unit;
  String? occupation;

  DirectoryListModal(
      {this.id,
        this.personname,
        this.profile,
        this.mobile,
        this.countrycode,
        this.countrycodestr,
        this.role,
        this.unit,
        this.occupation});

  DirectoryListModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personname = json['personname'];
    profile = json['profile'];
    mobile = json['mobile'];
    countrycode = json['countrycode'];
    countrycodestr = json['countrycodestr'];
    role = json['role'];
    unit = json['unit'].cast<String>();
    occupation = json['occupation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['personname'] = this.personname;
    data['profile'] = this.profile;
    data['mobile'] = this.mobile;
    data['countrycode'] = this.countrycode;
    data['countrycodestr'] = this.countrycodestr;
    data['role'] = this.role;
    data['unit'] = this.unit;
    data['occupation'] = this.occupation;
    return data;
  }
}