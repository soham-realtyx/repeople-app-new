class AddPropertyUnitModel {
  int? inventorytype;
  String? projectid;
  String? projectname;
  String? buildingid;
  String? buildingname;
  String? floorid;
  String? floorname;
  String? unitid;
  String? unitname;
  String? name;

  AddPropertyUnitModel(
      {this.inventorytype,
        this.projectid,
        this.projectname,
        this.buildingid,
        this.buildingname,
        this.floorid,
        this.floorname,
        this.unitid,
        this.unitname,
        this.name});

  AddPropertyUnitModel.fromJson(Map<String, dynamic> json) {
    inventorytype = json['inventorytype'];
    projectid = json['projectid'];
    projectname = json['projectname'];
    buildingid = json['buildingid'];
    buildingname = json['buildingname'];
    floorid = json['floorid'];
    floorname = json['floorname'];
    unitid = json['unitid'];
    unitname = json['unitname'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inventorytype'] = this.inventorytype;
    data['projectid'] = this.projectid;
    data['projectname'] = this.projectname;
    data['buildingid'] = this.buildingid;
    data['buildingname'] = this.buildingname;
    data['floorid'] = this.floorid;
    data['floorname'] = this.floorname;
    data['unitid'] = this.unitid;
    data['unitname'] = this.unitname;
    data['name'] = this.name;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return "$name";
  }
}