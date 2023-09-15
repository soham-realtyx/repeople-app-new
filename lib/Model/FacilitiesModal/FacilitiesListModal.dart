class FacilitiesListModal{
  late String name;
  late List<FacilitiesListDetailsModel> facilities_details_list;

  FacilitiesListModal({
    required this.name,
    required this.facilities_details_list,
  });
}

class FacilitiesListDetailsModel{
  late String facilityimage;
  late String facilityname;
  late String facilitydescription;

  //late bool is_open=false;
  // late List<FacilitiesBookingHistoryDateDetailsModel> booking_history_date_details_list_;
  FacilitiesListDetailsModel({
    required this.facilityimage,
    required this.facilityname,
    required this.facilitydescription
    // required this.booking_history_date_details_list_,
    //required this.is_open,
  });
}

