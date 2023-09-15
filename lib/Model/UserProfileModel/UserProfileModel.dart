class UserProfileModel{
  String? fname;
  String? lname;
  String? personname;
  String? email;
  String? emailtype;
  String? proffession;
  String? mobileno;
  String? countrycode;
  String? countrycodestr;
  String? bod;
  String? anniversarydate;
  String? profile;
  String? alternateMobile;
  String? isAlternateWhatsApp;
  String? isWhatsApp;

  UserProfileModel({
    this.fname,
    this.lname,
    this.personname,
    this.email,
    this.emailtype,
    this.proffession,
    this.mobileno,
    this.countrycode,
    this.countrycodestr,
    this.bod,
    this.anniversarydate,
    this.profile,
    this.alternateMobile,
    this.isAlternateWhatsApp,
    this.isWhatsApp,
  });

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    fname = json['fname'];
    lname = json['lname'];
    personname = json['personname'];
    email = json['email'];
    emailtype = json['emailtype'];
    proffession = json['proffession'];
    mobileno = json['mobileno'];
    countrycode = json['countrycode'];
    bod = json['bod'];
    anniversarydate = json['anniversarydate'];
    profile = json['profile'];
    alternateMobile = json['alternatemobile'];
    isAlternateWhatsApp = json['isalternatewhatsApp'].toString();
    isWhatsApp = json['iswhatsApp'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['personname'] = this.personname;
    data['email'] = this.email;
    data['emailtype'] = this.emailtype;
    data['proffession'] = this.proffession;
    data['mobileno'] = this.mobileno;
    data['countrycode'] = this.countrycode;
    data['bod'] = this.bod;
    data['anniversarydate'] = this.anniversarydate;
    data['profile'] = this.profile;
    data['alternatemobile'] = this.alternateMobile;
    data['isalternatewhatsApp'] = this.isAlternateWhatsApp.toString();
    data['iswhatsApp'] = this.isWhatsApp.toString();
    return data;
  }
}