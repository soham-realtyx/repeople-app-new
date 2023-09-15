class RequestUserList {
  String? id;
  String? oid;
  String? personname;
  String? mobile;
  String? countryCode;
  String? datetime;
  String? project;
  String? unit;
  String? fullunitdetails;
  String? profile;

  RequestUserList(
      {this.id,
        this.oid,
        this.personname,
        this.mobile,
        this.countryCode,
        this.datetime,
        this.project,
        this.unit,
        this.fullunitdetails,
        this.profile});

  RequestUserList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    oid = json['oid'];
    personname = json['personname'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    datetime = json['datetime'];
    project = json['project'];
    unit = json['unit'];
    fullunitdetails = json['fullunitdetails'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['oid'] = this.oid;
    data['personname'] = this.personname;
    data['mobile'] = this.mobile;
    data['country_code'] = this.countryCode;
    data['datetime'] = this.datetime;
    data['project'] = this.project;
    data['unit'] = this.unit;
    data['fullunitdetails'] = this.fullunitdetails;
    data['profile'] = this.profile;
    return data;
  }
}