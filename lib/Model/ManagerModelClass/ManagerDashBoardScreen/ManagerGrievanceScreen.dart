class ManagerGrievanceModel{
String? id;
String? name;
String? count;

ManagerGrievanceModel({
  this.id,
  this.name,
  this.count
});

ManagerGrievanceModel.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  count = json['count'].toString();
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = id;
  data['name'] = name;
  data['count'] = count;

  return data;
}

}