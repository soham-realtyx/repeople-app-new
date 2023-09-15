class UserrightListClass {
  bool? isselected = false;
  String? pagename;
  String? appmenuname;
  String? iconImage;
  int? isindividual;
  String? icon;
  String? iconunicode;
  String? iconstyle;
  String? iconclass;
  int? viewright;
  int? viewallright;
  int? viewselfright;
  int? addright;
  int? addallright;
  int? addselfright;
  int? editright;
  int? editallright;
  int? editselfright;
  int? delright;
  int? delallright;
  int? delselfright;
  int? printright;
  int? printallright;
  int? printselfright;
  int? changepriceright;

  UserrightListClass(
      {this.pagename,
        this.appmenuname,
        this.isindividual,
        this.icon,
        this.iconunicode,
        this.iconstyle,
        this.iconclass,
        this.viewright,
        this.viewallright,
        this.viewselfright,
        this.addright,
        this.addallright,
        this.addselfright,
        this.editright,
        this.editallright,
        this.editselfright,
        this.delright,
        this.delallright,
        this.delselfright,
        this.printright,
        this.printallright,
        this.printselfright,
        this.changepriceright});

  UserrightListClass.Drawer(this.pagename,this.appmenuname,this.iconImage);

  UserrightListClass.fromJson(Map<String, dynamic> json) {
    pagename = json['pagename'];
    appmenuname = json['appmenuname'];
    isindividual = json['isindividual'];
    icon = json['icon'];
    iconunicode = json['iconunicode'];
    iconstyle = json['iconstyle'];
    iconclass = json['iconclass'];
    viewright = json['viewright'];
    viewallright = json['viewallright'];
    viewselfright = json['viewselfright'];
    addright = json['addright'];
    addallright = json['addallright'];
    addselfright = json['addselfright'];
    editright = json['editright'];
    editallright = json['editallright'];
    editselfright = json['editselfright'];
    delright = json['delright'];
    delallright = json['delallright'];
    delselfright = json['delselfright'];
    printright = json['printright'];
    printallright = json['printallright'];
    printselfright = json['printselfright'];
    changepriceright = json['changepriceright'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pagename'] = this.pagename;
    data['appmenuname'] = this.appmenuname;
    data['isindividual'] = this.isindividual;
    data['icon'] = this.icon;
    data['iconunicode'] = this.iconunicode;
    data['iconstyle'] = this.iconstyle;
    data['iconclass'] = this.iconclass;
    data['viewright'] = this.viewright;
    data['viewallright'] = this.viewallright;
    data['viewselfright'] = this.viewselfright;
    data['addright'] = this.addright;
    data['addallright'] = this.addallright;
    data['addselfright'] = this.addselfright;
    data['editright'] = this.editright;
    data['editallright'] = this.editallright;
    data['editselfright'] = this.editselfright;
    data['delright'] = this.delright;
    data['delallright'] = this.delallright;
    data['delselfright'] = this.delselfright;
    data['printright'] = this.printright;
    data['printallright'] = this.printallright;
    data['printselfright'] = this.printselfright;
    data['changepriceright'] = this.changepriceright;
    return data;
  }
}