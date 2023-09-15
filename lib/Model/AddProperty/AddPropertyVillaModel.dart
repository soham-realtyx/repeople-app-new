class AddPropertyVillaModel {
  int? inventorytype;
  String? projectid;
  String? projectname;
  String? villaid;
  String? vilaname;

  AddPropertyVillaModel(
      {this.inventorytype,
        this.projectid,
        this.projectname,
        this.villaid,
        this.vilaname});

  AddPropertyVillaModel.fromJson(Map<String, dynamic> json) {
    inventorytype = json['inventorytype'];
    projectid = json['projectid'];
    projectname = json['projectname'];
    villaid = json['villaid'];
    vilaname = json['villaname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inventorytype'] = this.inventorytype;
    data['projectid'] = this.projectid;
    data['projectname'] = this.projectname;
    data['villaid'] = this.villaid;
    data['villaname'] = this.vilaname;
    return data;
  }
}