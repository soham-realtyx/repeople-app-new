import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant.dart';
import 'ApiResponse.dart';

Future<void> NotificationCountHandler(String notificationid)async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  GetPendingNotificationList().then((value) {

      AddNotificationInPendingList(value ,notificationid);

  });
}

Future<String> GetPendingNotificationList() async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  var pendigNotification=sp.getString(NOTIFICATION_LIST) ?? "";
  return pendigNotification;
}


 Future<void> AddNotificationInPendingList(String value,String id) async{
   SharedPreferences sp = await SharedPreferences.getInstance();
  List<dynamic> pendingNotificationList=[];
  if(value !=null && value !=""){
    pendingNotificationList=json.decode(value);
  }

    pendingNotificationList.add(id);
  print(pendingNotificationList.toString()+ "    THis is List");
   var setNotificationlist=json.encode(pendingNotificationList);
    await sp.setString(NOTIFICATION_LIST, setNotificationlist);
 }

Future<void> GetReadAllNotificationLists() async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  var pendigNotification=sp.getString(NOTIFICATION_LIST) ?? "";
  if(pendigNotification !=null && pendigNotification !=""){
    sp.setString(NOTIFICATION_LIST, '');
  }
}

Future<void> GetRemoveAnyParticularNotification(String notificationid) async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  var pendigNotificationList=sp.getString(NOTIFICATION_LIST).toString() ?? "";
  if(pendigNotificationList != "" && pendigNotificationList !=null){
    var pendingNotifications =json.decode(pendigNotificationList);
    for(int i=0;i<pendingNotifications.length;i++){
      if(i.toString().trim()==notificationid.toString().trim()){
        pendingNotifications.remove(i);
      }
    }
    var setNotificationlist=json.encode(pendingNotifications);
    await sp.setString(NOTIFICATION_LIST, setNotificationlist);
  }

}

 ReadNotificationApiCall({String notificationid=''}) async {
  try{
    SharedPreferences sp = await SharedPreferences.getInstance();


    var data = {
      'action': 'readnotification',
      'n_id' : notificationid

    };

    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_NOTIFICATION,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {

    }
  }catch(e){}


}







