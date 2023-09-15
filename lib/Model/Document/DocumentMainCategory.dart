class DocumentMainCtegory {
  int? id;
  String? type;

  DocumentMainCtegory(
      {
        this.id,
        this.type,
      });

  DocumentMainCtegory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;

    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$type";
  }
}