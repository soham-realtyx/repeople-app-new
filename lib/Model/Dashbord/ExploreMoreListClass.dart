
class ExploreMoreListClass {
  String name;
  String image;
  String color;
  String? alias;
  ExploreMoreListClass(this.name,  this.image,this.color,this.alias);


}

class UserrightsModal {
  List<MenuItemModel>? exploreMore;
  List<MenuItemModel>? bottomNavigation;
  List<MenuItemModel>? sidebar;
  List<MenuItemModel>? HomeBuyerGuide;
  List<MenuItemModel>? ExtraFeatures;

  UserrightsModal({this.exploreMore, this.bottomNavigation, this.sidebar,this.HomeBuyerGuide,this.ExtraFeatures});

  UserrightsModal.fromJson(Map<String, dynamic> json) {
    if (json['explore_more'] != null) {
      exploreMore = <MenuItemModel>[];
      json['explore_more'].forEach((v) {
        exploreMore!.add(new MenuItemModel.fromJson(v));
      });
    }
    if (json['bottom_navigation'] != null) {
      bottomNavigation = <MenuItemModel>[];
      json['bottom_navigation'].forEach((v) {
        bottomNavigation!.add(new MenuItemModel.fromJson(v));
      });
    }
    if (json['sidebar'] != null) {
      sidebar = <MenuItemModel>[];
      json['sidebar'].forEach((v) {
        sidebar!.add(new MenuItemModel.fromJson(v));
      });
    }

    if(json['others'] !=null){

      if (json['others']['group1'] != null && json['others']['group1']['menu'] != null) {
        HomeBuyerGuide = <MenuItemModel>[];
        json['others']['group1']['menu'].forEach((v) {
          HomeBuyerGuide!.add(new MenuItemModel.fromJson(v));
        });
      }

      if (json['others']['group2'] != null && json['others']['group2']['menu'] != null) {
        ExtraFeatures = <MenuItemModel>[];
        json['others']['group2']['menu'].forEach((v) {
          ExtraFeatures!.add(new MenuItemModel.fromJson(v));
        });
      }
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.exploreMore != null) {
      data['explore_more'] = this.exploreMore!.map((v) => v.toJson()).toList();
    }
    if (this.bottomNavigation != null) {
      data['bottom_navigation'] =
          this.bottomNavigation!.map((v) => v.toJson()).toList();
    }
    if (this.sidebar != null) {
      data['sidebar'] = this.sidebar!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuItemModel {
  String? id;
  String? name;
  String? alias;
  String? icon;
  String? color;
  int? isshowandroid;
  int? isshowios;
  bool? isselected;

  MenuItemModel(
      {this.id,
        this.name,
        this.alias,
        this.icon,
        this.color,
        this.isshowandroid,
        this.isshowios,
        this.isselected,
      });

  MenuItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    icon = json['icon'];
    color = json['color'];
    isshowandroid = json['isshowandroid'];
    isshowios = json['isshowios'];
    isselected = json['isselected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['alias'] = this.alias;
    data['icon'] = this.icon;
    data['color'] = this.color;
    data['isshowandroid'] = this.isshowandroid;
    data['isshowios'] = this.isshowios;
    data['isselected'] = this.isselected;
    return data;
  }
}

// class ExploreMoreListClass {
//   String? id;
//   String? name;
//   String? alias;
//   String? icon;
//   String? color;
//   int? isshowandroid;
//   int? isshowios;
//
//   ExploreMoreListClass(
//       {this.id,
//         this.name,
//         this.alias,
//         this.icon,
//         this.color,
//         this.isshowandroid,
//         this.isshowios});
//
//   ExploreMoreListClass.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     alias = json['alias'];
//     icon = json['icon'];
//     color = json['color'];
//     isshowandroid = json['isshowandroid'];
//     isshowios = json['isshowios'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['alias'] = this.alias;
//     data['icon'] = this.icon;
//     data['color'] = this.color;
//     data['isshowandroid'] = this.isshowandroid;
//     data['isshowios'] = this.isshowios;
//     return data;
//   }
// }