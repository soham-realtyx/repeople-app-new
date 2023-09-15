class FacilitiesBookingHistoryModal{
  late String name;
  late List<FacilitiesBookingHistoryDetailsModel> booking_history_date_list;
  FacilitiesBookingHistoryModal({
    required this.name,
    required this.booking_history_date_list,
  });
}

class FacilitiesBookingHistoryDetailsModel{
  late String bookingdate;
  //late bool is_open=false;
  late List<FacilitiesBookingHistoryDateDetailsModel> booking_history_date_details_list_;
  FacilitiesBookingHistoryDetailsModel({
    required this.bookingdate,
    required this.booking_history_date_details_list_,
    //required this.is_open,
  });
}
class FacilitiesBookingHistoryDateDetailsModel{
  late String name;
  late String fromdate;
  late String todate;
  late String amount;
  late String bookingcategoryname;
  late String bookingperiod;
  FacilitiesBookingHistoryDateDetailsModel({
    required this.name,
    required this.fromdate,
    required this.todate,
    required this.amount,
    required this.bookingcategoryname,
    required this.bookingperiod,
  });
}

