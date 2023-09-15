class AddPropertyPlotModel {
  int? inventorytype;
  String? projectid;
  String? projectname;
  String? plotid;
  String? plotname;

  AddPropertyPlotModel(
      {this.inventorytype,
        this.projectid,
        this.projectname,
        this.plotid,
        this.plotname});

  AddPropertyPlotModel.fromJson(Map<String, dynamic> json) {
    inventorytype = json['inventorytype'];
    projectid = json['projectid'];
    projectname = json['projectname'];
    plotid = json['plotid'];
    plotname = json['plotname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inventorytype'] = this.inventorytype;
    data['projectid'] = this.projectid;
    data['projectname'] = this.projectname;
    data['plotid'] = this.plotid;
    data['plotname'] = this.plotname;
    return data;
  }
}