class AddCoOwner{
  String? buildingname;
  String? wing;
  String? flatno;

  AddCoOwner({
    this.buildingname,
    this.wing,
    this.flatno});

  AddCoOwner.fromJson(Map<String, dynamic> json) {
    buildingname = json['buildingname'];
    wing = json['wing'];
    flatno = json['flatno'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buildingname'] = this.buildingname;
    data['wing'] = this.wing;
    data['flatno'] = this.flatno;
    return data;
  }
}