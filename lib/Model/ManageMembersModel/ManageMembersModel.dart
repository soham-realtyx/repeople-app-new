

class ManageMembersModel {
  int? id;
  String? memberName;
  String? memberType;
  String? seenType;
  String? memberEmail;
  String? memberImages;
  String? buttonText;
  String? mobileno;
  bool? isActive = false;


  ManageMembersModel(
      {this.id,
        this.memberName,
        this.memberType,
        this.seenType,
        this.memberEmail,
        this.memberImages,
        this.buttonText,

        this.isActive,
        this.mobileno,

      });

  ManageMembersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberName = json['memberName'];
    memberType = json['memberType'];
    seenType = json['seenType'];
    memberEmail = json['memberEmail'];
    memberImages = json['memberImages'];
    buttonText = json['buttonText'];
    mobileno = json['mobileno'];
    isActive = json['isActive']=false;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['memberName'] = this.memberName;
    data['memberType'] = this.memberType;
    data['seenType'] = this.seenType;
    data['memberEmail'] = this.memberEmail;
    data['memberImages'] = this.memberImages;
    data['buttonText'] = this.buttonText;
    data['mobileno'] = this.mobileno;
    data['isActive'] = this.isActive=false;

    return data;
  }
}