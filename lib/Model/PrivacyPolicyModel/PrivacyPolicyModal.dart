class PrivacyPolicyModel{
  String? id;
  String? title;
  String? description;


  PrivacyPolicyModel({
    this.id,
    this.title,
    this.description,
  });

  PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();

    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}