class UpdateModelClass {
  String? id;
  String? titile;
  String? titile1;
  String? description;
  String? document;
  String? dateTime;
  String? time;
  String? date;
  String? extension;
  String? noticecategoryname;

  UpdateModelClass(
      {this.id,
        this.titile,
        this.titile1,
        this.description,
        this.document,
        this.dateTime,
        this.time,
        this.extension,
        this.noticecategoryname,
        this.date});

  UpdateModelClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titile = json['title'];
    titile1 = json['titile'];
    description = json['description'];
    document = json['document'];
    dateTime = json['date_time'];
    time = json['time'];
    date = json['date'];
    extension = json['extension'];
    noticecategoryname = json['noticecategoryname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.titile;
    data['titile'] = this.titile1;
    data['description'] = this.description;
    data['document'] = this.document;
    data['date_time'] = this.dateTime;
    data['time'] = this.time;
    data['date'] = this.date;
    data['extension'] = this.extension;
    data['noticecategoryname'] = this.noticecategoryname;
    return data;
  }
}