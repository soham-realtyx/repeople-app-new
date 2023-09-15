import 'package:get/get.dart';

class DemandsModel {
  String? invoiceno;
  String? paymentduedate;
  String? amountdue;
  String? interest;
  String? demandstatus;
  String? scheduledue;
  String? projectid;
  String? outstandingdue;
  RxBool? isOpen=false.obs;
  DemandsModel(
      {this.invoiceno,
        this.paymentduedate,
        this.amountdue,
        this.interest,
        this.demandstatus,
        this.scheduledue,
        this.outstandingdue,
        this.isOpen,
        this.projectid,});

  DemandsModel.fromJson(Map<String, dynamic> json) {
    invoiceno = json['invoiceno'];
    paymentduedate = json['paymentduedate'];
    amountdue = json['amountdue'];
    interest = json['interest'];
    demandstatus = json['demandstatus'];
    scheduledue = json['scheduledue'];
    projectid = json['projectid'];
    outstandingdue = json['outstandingdue'];
    isOpen = json['isOpen']=false.obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceno'] = this.invoiceno;
    data['paymentduedate'] = this.paymentduedate;
    data['amountdue'] = this.amountdue;
    data['interest'] = this.interest;
    data['demandstatus'] = this.demandstatus;
    data['scheduledue'] = this.scheduledue;
    data['projectid'] = this.projectid;
    data['outstandingdue'] = this.outstandingdue;
    data['isOpen'] = this.isOpen=false.obs;
    return data;
  }
}