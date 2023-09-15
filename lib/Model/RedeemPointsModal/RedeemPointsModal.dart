class RedeemPointsModal{
  late String name;
  late List<RedeemListDetailsModel> redeem_details_list;

  RedeemPointsModal({
    required this.name,
    required this.redeem_details_list,
  });
}

class RedeemListDetailsModel{
  late String redeemdetailslistimage;
  late String redeemdetailslistname;
  late String redeemdetailslistdescription;

  //late bool is_open=false;
  // late List<FacilitiesBookingHistoryDateDetailsModel> booking_history_date_details_list_;
  RedeemListDetailsModel({
    required this.redeemdetailslistimage,
    required this.redeemdetailslistname,
    required this.redeemdetailslistdescription
    // required this.booking_history_date_details_list_,
    //required this.is_open,
  });
}

