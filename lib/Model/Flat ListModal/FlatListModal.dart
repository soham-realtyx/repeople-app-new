class FlatListModal {
  String? projectid;
  String? project;
  String? inventorytypeid;
  String? inventorytype;
  String? plotid;
  String? plot;
  String? unitdetails;

  FlatListModal(
      {
        this.projectid,
        this.project,
        this.inventorytypeid,
        this.inventorytype,
        this.plotid,
        this.plot,
        this.unitdetails,
      });

  FlatListModal.fromJson(Map<String, dynamic> json) {
    // debugger();
    projectid = json['projectid'];
    project = json['project'];
    inventorytypeid = json['inventorytypeid'];
    inventorytype = json['inventorytype'];
    plotid = json['plotid'];
    plot = json['plot'];
    unitdetails = json['unitdetails'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['projectid'] = projectid;
    data['project'] = project;
    data['inventorytypeid'] = inventorytypeid;
    data['inventorytype'] = inventorytype;
    data['plotid'] = plotid;
    data['plot'] = plot;
    data['unitdetails'] = unitdetails;

    return data;
  }

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return "$name";
  // }
}