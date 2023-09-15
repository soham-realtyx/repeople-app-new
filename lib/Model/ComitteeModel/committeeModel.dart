class ProjectDetailsModel{
  String? project_name;
 // List<UserLevel>? userLevel;

  ProjectDetailsModel({
    this.project_name,
   // this.userLevel
   });

  ProjectDetailsModel.fromJson(Map<String, dynamic> json) {
    project_name = json['project_name'];
    //userLevel = json['userLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_name'] = this.project_name;
    //data['userLevel'] = this.userLevel;
    return data;
  }

}
//
// class Users{
//   String? name;
//   String? email;
//   String? mobile_no;
//   String? image;
//
//   Users({
//     this.name,
//     this.email,
//     this.mobile_no,
//     this.image
//   });
//
//   Users.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     email = json['email'];
//     mobile_no = json['mobile_no'];
//     image = json['image'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['mobile_no'] = this.mobile_no;
//     data['image'] = this.image;
//     return data;
//   }
//
// }
//
//
// class UserLevel{
//   String? user_level;
//   List<Users>? udata;
//
//   UserLevel({
//     this.user_level,
//     this.udata
//   });
//
//   UserLevel.fromJson(Map<String, dynamic> json) {
//     user_level = json['user_level'];
//     udata = json['udata'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user_level'] = this.user_level;
//     data['udata'] = this.udata;
//     return data;
//   }
// }

class CommitteeListModel {
  String? id;
  String? role;
  List<Commitees>? commitees;

  CommitteeListModel({this.id, this.role, this.commitees});

  CommitteeListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    if (json['commitees'] != null) {
      commitees = <Commitees>[];
      json['commitees'].forEach((v) {
        commitees!.add(new Commitees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    if (this.commitees != null) {
      data['commitees'] = this.commitees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Commitees {
  String? id;
  String? personname;
  String? email;
  String? mobileno;
  String? countrycode;
  String? profile;

  Commitees(
      {this.id,
        this.personname,
        this.email,
        this.mobileno,
        this.countrycode,
        this.profile});

  Commitees.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personname = json['personname'];
    email = json['email'];
    mobileno = json['mobileno'];
    countrycode = json['countrycode'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['personname'] = this.personname;
    data['email'] = this.email;
    data['mobileno'] = this.mobileno;
    data['countrycode'] = this.countrycode;
    data['profile'] = this.profile;
    return data;
  }
}