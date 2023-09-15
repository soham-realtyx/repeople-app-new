class BudgetApiModel {
  int? id;
  int? minbudget;
  int? maxbudget;
  String? name;

  BudgetApiModel({this.id, this.minbudget, this.maxbudget, this.name});

  BudgetApiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    minbudget = json['minbudget'];
    maxbudget = json['maxbudget'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['minbudget'] = this.minbudget;
    data['maxbudget'] = this.maxbudget;
    data['name'] = this.name;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$name";
  }
}