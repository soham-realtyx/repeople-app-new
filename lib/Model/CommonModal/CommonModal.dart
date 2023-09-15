class CommonModal {
  String? id;
  String? name;
  String? icon;
  String? color;
  CommonModal(
      {
        this.id,
        this.name,
        this.icon,
        this.color,
      });

  CommonModal.fromJson(Map<String, dynamic> json) {
    // debugger();
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    color = json['color'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['color'] = color;

    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$name";
  }
}