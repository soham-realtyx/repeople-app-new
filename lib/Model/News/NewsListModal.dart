class NewsListClass {
  int? id;
  String? title;
  String? newspublishdate;
  String? description;
  String? newsurl;
  String? newsimage;
  int? displayorder;
  int? isactive;
  String? entry_uid;
  String? entry_by;
  String? entry_date;
  String? update_by;
  String? update_date;
  String? update_uid;
  String? date_value;
  String? fullnewsimage;
  String? newscategory;


  NewsListClass(
      {this.id,
        this.title,
        this.newspublishdate,
        this.description,
        this.newsurl,
        this.newsimage,
        this.displayorder,
        this.isactive,
        this.entry_uid,
        this.entry_by,
        this.entry_date,
        this.update_by,
        this.update_date,
        this.update_uid,
        this.date_value,
        this.fullnewsimage,
        this.newscategory,

      });

  // NewsListClass.Drawer(this.pagename,this.appmenuname,this.iconImage);

  NewsListClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    newspublishdate = json['newspublishdate'];
    description = json['description'];
    newsurl = json['newsurl'];
    displayorder = json['displayorder'];
    isactive = json['isactive'];
    entry_uid = json['entry_uid'];
    entry_by = json['entry_by'];
    entry_date = json['entry_date'];
    update_by = json['update_by'];
    update_date = json['update_date'];
    update_uid = json['update_uid'];
    date_value = json['date_value'];
    fullnewsimage = json['fullnewsimage'];
    newscategory = json['newscategory'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['newspublishdate'] = this.newspublishdate;
    data['description'] = this.description;
    data['newsurl'] = this.newsurl;
    data['displayorder'] = this.displayorder;
    data['isactive'] = this.isactive;
    data['entry_uid'] = this.entry_uid;
    data['entry_by'] = this.entry_by;
    data['entry_date'] = this.entry_date;
    data['update_by'] = this.update_by;
    data['update_date'] = this.update_date;
    data['update_uid'] = this.update_uid;
    data['date_value'] = this.date_value;
    data['fullnewsimage'] = this.fullnewsimage;
    data['newscategory'] = this.newscategory;
    return data;
  }
}