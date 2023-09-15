class BuyAndSellModel {
  String? id;
  String? title;
  String? configuration;
  String? isproperty;
  String? color;
  String? area;
  String? address;
  String? contact;
  String? description;

  BuyAndSellModel(
      {this.id,
        this.title,
        this.configuration,
        this.isproperty,
        this.color,
        this.area,
        this.address,
        this.contact,
        this.description});

  BuyAndSellModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    configuration = json['configuration'];
    isproperty = json['isproperty'];
    color = json['color'];
    area = json['area'];
    address = json['address'];
    contact = json['contact'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['configuration'] = this.configuration;
    data['isproperty'] = this.isproperty;
    data['color'] = this.color;
    data['area'] = this.area;
    data['address'] = this.address;
    data['contact'] = this.contact;
    data['description'] = this.description;
    return data;
  }
}