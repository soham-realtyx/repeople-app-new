

class ReferralFAQ{
  String? question;
  String? answer;

  ReferralFAQ(this.question,this.answer);
}


class ReferralModel{
  String? title;

  ReferralModel({
    this.title,
  });

  ReferralModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    return data;
  }
}

class RefferInfo {
  String? id;
  String? title;
  String? description;
  String? points;
  String? icon;

  RefferInfo({this.id, this.title, this.description, this.points, this.icon});

  RefferInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    points = json['points'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['points'] = this.points;
    data['icon'] = this.icon;
    return data;
  }
}



