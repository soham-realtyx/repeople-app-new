class AddPropertybuildingModel {
  String? buildingid;
  String? buildingname;

  AddPropertybuildingModel({this.buildingid, this.buildingname});

  AddPropertybuildingModel.fromJson(Map<String, dynamic> json) {
    buildingid = json['buildingid'];
    buildingname = json['buildingname'];
  }
  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return "$buildingname";
  // }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buildingid'] = this.buildingid;
    data['buildingname'] = this.buildingname;
    return data;
  }
}
