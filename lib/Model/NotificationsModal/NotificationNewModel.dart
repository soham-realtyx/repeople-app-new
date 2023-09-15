class NotificationApiCall {
  String? autoid;
  String? id;
  String? n_id;
  String? notificationid;
  String? title;
  String? message;
  String? image;
  int? redirect;
  String? date;

  NotificationApiCall(
      {this.autoid,
        this.id,
        this.n_id,
        this.notificationid,
        this.title,
        this.message,
        this.image,
        this.redirect,
        this.date});

  NotificationApiCall.fromJson(Map<String, dynamic> json) {
    autoid = json['autoid'];
    id = json['id'];
    n_id = json['n_id'];
    notificationid = json['notificationid'];
    title = json['title'];
    message = json['message'];
    image = json['image'];
    redirect = json['redirect'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['autoid'] = this.autoid;
    data['id'] = this.id;
    data['n_id'] = this.n_id;
    data['notificationid'] = this.notificationid;
    data['title'] = this.title;
    data['message'] = this.message;
    data['image'] = this.image;
    data['redirect'] = this.redirect;
    data['date'] = this.date;
    return data;
  }
}