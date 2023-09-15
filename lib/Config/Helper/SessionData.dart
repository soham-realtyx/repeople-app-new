import 'dart:convert';

import 'package:Repeople/Config/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';




Future storeSessionArray(Map<String , dynamic> responseData)async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString(SESSION_ARRAY, jsonEncode(responseData));
  sp.commit();
}

Future<String> getData(String key)async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  Map<String,dynamic> data = jsonDecode(sp.getString(SESSION_ARRAY) ?? "");
  if(data.containsKey(key)){
    return data[key].toString();
  }else{
    return data[key].toString();
  }
}

Future<void> updateData(String key,String value)async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  Map<String,dynamic> data = jsonDecode(sp.getString(SESSION_ARRAY) ?? "");
  data[key] = value;
  print(data);
  sp.setString(SESSION_ARRAY, jsonEncode(data));
}

Future clearSessionData()async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.clear();
}

Future<void> StoreIsUpdateNotNowSessionData(bool flag) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setBool(ISUPDATENOTNOW, flag);

  sp.commit();
}

Future<bool> getIsUpdateNotNow() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool value = sp.getBool(ISUPDATENOTNOW) ?? false;
  return value;
}


