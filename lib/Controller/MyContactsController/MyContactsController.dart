import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

class MyContactsController extends GetxController{
  // GlobalKey<ScaffoldState> GlobalMyContactPagekey =
  // GlobalKey<ScaffoldState>();
  Rxn<TextEditingController> txtSearch = Rxn(TextEditingController());
  RxList<Contact> mycontacts = RxList<Contact>([]);
  Rx<Future<List<Contact>>> futureContactList =
      Future.value(<Contact>[]).obs;
  TextEditingController searchController = new TextEditingController();
  RxBool permissionDenied = false.obs;
  List<Contact> contactsFiltered = [];

  Future<List<Contact>> fetchContacts() async {
    mycontacts=RxList([]);
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      permissionDenied.value = true;
    } else {
      final contacts = await FlutterContacts.getContacts();
      mycontacts.value = contacts;
    }
    mycontacts.refresh();
    update(mycontacts.value);
    return mycontacts;
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

}