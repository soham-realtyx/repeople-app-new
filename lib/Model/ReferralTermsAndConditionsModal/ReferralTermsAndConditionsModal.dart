class ReferralTermsAndConditionsModel{
  String? id;
  String? title;
  String? termsconditiondesc;


  ReferralTermsAndConditionsModel({
    this.id,
    this.title,
    this.termsconditiondesc,
  });

  ReferralTermsAndConditionsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    termsconditiondesc = json['termsconditiondesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['termsconditiondesc'] = this.termsconditiondesc;
    return data;
  }
}