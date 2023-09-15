class DashboardOffersModel {
  String? id;
  String? sliderurl;
  String? sliderimage;

  DashboardOffersModel({this.id, this.sliderurl, this.sliderimage});

  DashboardOffersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sliderurl = json['sliderurl'];
    sliderimage = json['sliderimage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sliderurl'] = this.sliderurl;
    data['sliderimage'] = this.sliderimage;
    return data;
  }
}