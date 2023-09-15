


class LoginHistoryModel {
  // int? id;
  String? devicemodelname;
  String? date;
  String? useragent;
  String? appversion;
  String? macaddress;
  String? deviceid;
  String? os;
  String? osversion;
  String? isactive;
  String? key;
  String? id;
  LoginHistoryModel(
      {this.id,
        this.devicemodelname,
        this.date,
        this.useragent,
        this.appversion,
        this.macaddress,
        this.deviceid,
        this.os,
        this.osversion,
        this.isactive,
        this.key,
      });

  LoginHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    devicemodelname = json['devicemodelname'];
    date = json['date'];
    useragent = json['useragent'];
    appversion = json['appversion'];
    macaddress = json['macaddress'];
    deviceid = json['deviceid'];
    os = json['os'];
    osversion = json['osversion'];
    isactive = json['isactive'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['devicemodelname'] = this.devicemodelname;
    data['date'] = this.date;
    data['macaddress'] = this.macaddress;
    data['deviceid'] = this.deviceid;
    data['os'] = this.os;
    data['osversion'] = this.osversion;
    data['isactive'] = this.isactive;
    data['key'] = this.key;

    return data;
  }
}

class Id {
  Id({
    this.oid,
  });
   late final String? oid;

  Id.fromJson(Map<String, dynamic> json){
    oid = json['oid'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['oid'] = oid;
    return _data;
  }
}