import 'package:shared_preferences/shared_preferences.dart';

import '../Constant.dart';

class UserSimplePreference{
  static SharedPreferences? _preferences;
  static const  _keyUserName='username';

  static Future init() async=>
      _preferences=await SharedPreferences.getInstance();

  static Future setusername(String username) async =>
      await _preferences?. setString(_keyUserName, username);
  static String? getUserName()=>_preferences?.getString(_keyUserName);  //this is simple methode


  static Future setstring(String key,String value) async=>
      await _preferences?.setString(key, value);
  static String? getString(key)=>_preferences?.getString(key);     //this is methode on wich single methode need to call only for every data

  static Future setbool(String key,bool value) async=>
      await _preferences?.setBool(key, value);
  static bool? getbool(key)=>_preferences?.getBool(key);

  static Future setint(String key,int value) async=>
      await _preferences?.setInt(key, value);
  static int? getint(key)=>_preferences?.getInt(key);



}

Future<void> storeCustomerLoginSessionData(Map<String, dynamic> responseData) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setBool(ISLOGIN, true);
  sp.setString(SESSION_UID, responseData[SESSION_UID]);
  sp.setString(SESSION_CMPID, responseData[SESSION_CMPID]);
  if(responseData[SESSION_CUSTOMER_ID]!=null) {
    sp.setString(SESSION_CUSTOMER_ID, responseData[SESSION_CUSTOMER_ID]);
  }
  sp.setString(SESSION_KEY, responseData[SESSION_KEY]);
  sp.setString(SESSION_UNQKEY, responseData[SESSION_UNQKEY]);
  sp.setString(SESSION_ISS, responseData[SESSION_ISS]);
  sp.setString(SESSION_PERSONNAME, responseData[SESSION_PERSONNAME]);
  sp.setString(SESSION_EMAIL, responseData[SESSION_EMAIL]);
  sp.setString(SESSION_CONTACT, responseData[SESSION_CONTACT]);
  if(responseData[SESSION_ALTERNATE_MOBILE]!=null) {
    sp.setString(
        SESSION_ALTERNATE_MOBILE, responseData[SESSION_ALTERNATE_MOBILE]);
  }
  sp.setString(SESSION_PROFILEPIC, responseData[SESSION_PROFILEPIC]);
  sp.setString(SESSION_FIRSTNAME, responseData[SESSION_FIRSTNAME]??"");
  sp.setString(SESSION_LASTNAME, responseData[SESSION_LASTNAME]??"");
  sp.setString(SESSION_USERLOGINTYPE, responseData[SESSION_USERLOGINTYPE].toString());
  sp.setString(SESSION_USERLOGINTYPENAME, responseData[SESSION_USERLOGINTYPENAME].toString());
  sp.setString(SESSION_USERPROFESSIONNAME, responseData[SESSION_USERPROFESSIONNAME].toString());
  sp.setString(SESSION_ISREGISTERED, responseData[SESSION_ISREGISTERED].toString() ?? "");
  sp.setString(SESSION_TOTALREDEEM_POINT, responseData[SESSION_TOTALREDEEM_POINT].toString() ?? "");
  sp.setString(CURRENT_LOGIN, CUSTOMER_ACCESS);
  sp.setBool(IS_CUSTOMER_DATA_AVAILABLE, true);


  sp.commit();
}

Future<void> storeManagerLoginSessionData(Map<String, dynamic> responseData) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setBool(ISLOGIN, true);
  sp.setString(SESSION_UID, responseData[SESSION_UID]);
  sp.setString(SESSION_CMPID, responseData[SESSION_CMPID]);
  sp.setString(SESSION_CUSTOMER_ID, responseData[SESSION_CUSTOMER_ID]);
  sp.setString(SESSION_KEY, responseData[SESSION_KEY]);
  sp.setString(SESSION_UNQKEY, responseData[SESSION_UNQKEY]);
  sp.setString(SESSION_ISS, responseData[SESSION_ISS]);
  sp.setString(SESSION_PERSONNAME, responseData[SESSION_PERSONNAME]);
  sp.setString(SESSION_EMAIL, responseData[SESSION_EMAIL]);
  sp.setString(SESSION_CONTACT, responseData[SESSION_CONTACT]);
  sp.setString(SESSION_ALTERNATE_MOBILE, responseData[SESSION_ALTERNATE_MOBILE]);
  sp.setString(SESSION_PROFILEPIC, responseData[SESSION_PROFILEPIC]);
  sp.setString(SESSION_FIRSTNAME, responseData[SESSION_FIRSTNAME]??"");
  sp.setString(SESSION_LASTNAME, responseData[SESSION_LASTNAME]??"");
  sp.setString(SESSION_USERLOGINTYPE, responseData[SESSION_USERLOGINTYPE].toString());
  sp.setString(SESSION_USERPROFESSIONNAME, responseData[SESSION_USERPROFESSIONNAME]??"");
  sp.setString(SESSION_USERLOGINTYPENAME, responseData[SESSION_USERLOGINTYPENAME].toString());
  sp.setString(SESSION_ISREGISTERED, responseData[SESSION_ISREGISTERED].toString() ?? "");
  sp.setString(SESSION_TOTALREDEEM_POINT, responseData[SESSION_TOTALREDEEM_POINT].toString() ?? "");
  sp.setString(CURRENT_LOGIN, MANAGER_ACCESS);
  sp.setBool(IS_MANAGER_DATA_AVAILABLE, true);


  sp.commit();
}

Future setNotificationCount(int count) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setInt(NOTIFICATION_COUNT, count);
  sp.commit();
}

Future<int> getNotificationCount() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getInt(NOTIFICATION_COUNT) ?? 0;
}