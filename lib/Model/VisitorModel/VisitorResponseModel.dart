class VisitorResponseModel {
  String? autoid;
  String? id;
  String? personname;
  String? mobile;
  String? countryCode;
  String? datetime;
  String? project;
  String? unit;
  String? fullunitdetails;
  String? profile;
  String? acceptStatus;
  String? acceptcolor;

  VisitorResponseModel(
      {this.autoid,
        this.id,
        this.personname,
        this.mobile,
        this.countryCode,
        this.datetime,
        this.project,
        this.unit,
        this.fullunitdetails,
        this.profile,
        this.acceptStatus,
        this.acceptcolor,

      });

  VisitorResponseModel.fromJson(Map<String, dynamic> json) {
    autoid = json['autoid'];
    id = json['id'];
    personname = json['personname'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    datetime = json['datetime'];
    project = json['project'];
    unit = json['unit'];
    fullunitdetails = json['fullunitdetails'];
    profile = json['profile'];
    acceptStatus = json['accept_status'];
    acceptcolor = json['accept_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['autoid'] = this.autoid;
    data['id'] = this.id;
    data['personname'] = this.personname;
    data['mobile'] = this.mobile;
    data['country_code'] = this.countryCode;
    data['datetime'] = this.datetime;
    data['project'] = this.project;
    data['unit'] = this.unit;
    data['fullunitdetails'] = this.fullunitdetails;
    data['profile'] = this.profile;
    data['accept_status'] = this.acceptStatus;
    data['accept_color'] = this.acceptcolor;
    return data;
  }
}