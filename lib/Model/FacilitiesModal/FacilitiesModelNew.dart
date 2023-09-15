class facilitiesModel {
  String? id;
  String? facilityid;
  String? projectid;
  String? title;
  String? isfacility;
  String? color;
  String? contact;
  String? personemail;
  String? description;

  facilitiesModel(
      {this.id,
        this.facilityid,
        this.projectid,
        this.title,
        this.isfacility,
        this.color,
        this.contact,
        this.personemail,
        this.description});

  facilitiesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    facilityid = json['facilityid'];
    projectid = json['projectid'];
    title = json['title'];
    isfacility = json['isfacility'];
    color = json['color'];
    contact = json['contact'];
    personemail = json['personemail'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['facilityid'] = this.facilityid;
    data['projectid'] = this.projectid;
    data['title'] = this.title;
    data['isfacility'] = this.isfacility;
    data['color'] = this.color;
    data['contact'] = this.contact;
    data['personemail'] = this.personemail;
    data['description'] = this.description;
    return data;
  }
}