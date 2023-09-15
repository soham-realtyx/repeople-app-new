import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/EmiCalculatorModal/EmiCalculatorModal.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';

import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/TextEditField.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class EmiCalculatorController extends GetxController {
  RxList<WidgetThemeListClass> arrAllThemeList = RxList<WidgetThemeListClass>();
  RxList<EmiStatistics> arrStatisticsList = RxList<EmiStatistics>();
  Rx<Future<List<EmiStatistics>>> futureData = Future.value(<EmiStatistics>[]).obs;
  RxList arrLoanList = RxList();
  RxDouble amountProgress = 24000000.0.obs;
  RxDouble myamount = 0.0.obs;
  RxDouble _value = 10.0.obs;
  // RxDouble interestProgress = 12.0.obs;
  RxDouble interestProgress = 8.5.obs;
  RxDouble loanyearsProgress = 20.0.obs;
  // RxInt selectedLoan = (-1).obs;   // this value for loan term selected index
  // RxInt selectedLoan = 0.obs;   // this value for loan term selected index

  RxString Emi="".obs;
  RxString TotalIntrest="".obs;
  RxString TotalAmountTopay="".obs;
  final EMI_STREAM = StreamController<List<EmiStatistics>>();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> Globalemipagekey = GlobalKey<ScaffoldState>();
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Rxn<TextEditingController> cate_name = new Rxn(TextEditingController());
  Rxn<TextEditingController> Intresr_cont = new Rxn(TextEditingController());

  String? price;

  String? moneyFormat() {
    if (price!.length > 2) {
      var value = price;
      value = value?.replaceAll(RegExp(r'\D'), '');
      value = value?.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
    return null;
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  //<editor-fold desc = "Statistics List">

  CreateStatisticsList() {
    arrStatisticsList=RxList([]);
    arrStatisticsList.add(EmiStatistics(IMG_INTEREST, "\u{20B9}  N.A", "Principal Amount", hex("fdcb6e")));
    arrStatisticsList.add(EmiStatistics(IMG_PAYMENT, "\u{20B9} N.A", "Interest Rate", hex("0984e3")));
    arrStatisticsList.add(EmiStatistics(IMG_PAYMENT, "\u{20B9} N.A", "Loan Term", ORANGE_YELLOW_COLOR));
    arrStatisticsList.add(EmiStatistics(IMG_INTEREST, "\u{20B9}  N.A", "Total Interest Payable", ORANGE_COLOR));
    arrStatisticsList.add(EmiStatistics(IMG_PAYMENT, "\u{20B9} N.A", "Total Payment", ORANGE_YELLOW_COLOR));
    arrLoanList=RxList([]);
    arrLoanList.add("1");
    arrLoanList.add("3");
    arrLoanList.add("5");
    arrLoanList.add("10");
    arrLoanList.add("15");
    arrLoanList.add("30");
    arrLoanList.refresh();

    EMI_STREAM.sink.add(arrStatisticsList);
    arrStatisticsList.refresh();

  }


  Updatelistafterchages(){
    arrStatisticsList=RxList([]);
    arrStatisticsList.add(EmiStatistics(IMG_PRINCIPALAMOUNT_SVG_NEW, "\u{20B9} ${numberFormat.format(double.parse(amountProgress.value.toStringAsFixed(2) ))?? "N.A"}".toString(),
        "Principal Amount", hex("00b894")));
    arrStatisticsList.add(EmiStatistics(IMG_INTERESTRATE_SVG_NEW, interestProgress.value.toStringAsFixed(2),
        "Interest Rate", hex("0984e3")));
    arrStatisticsList.add(EmiStatistics(IMG_LOANTERM_SVG_NEW, loanyearsProgress.value.toStringAsFixed(2),
        "Loan Term", hex("6c5ce7")));
    arrStatisticsList.add(EmiStatistics(IMG_TOTALINTERESTPAYABLE_SVG_NEW,
        "\u{20B9} ${numberFormat.format(int.parse(TotalIntrest.value) )?? "N.A"}",
        "Total Interest Payable", ORANGE_COLOR));
    arrStatisticsList.add(EmiStatistics(IMG_TOTALPAYMENT_SVG_NEW,
        "\u{20B9} ${numberFormat.format(int.parse(TotalAmountTopay.value)) ?? "N.A"}",
        "Total Payment", ORANGE_YELLOW_COLOR));
    EMI_STREAM.sink.add(arrStatisticsList);
    arrStatisticsList.refresh();
  }

  Stream<RxList<EmiStatistics>>? getNumber() async*{
    arrStatisticsList=RxList([]);
    arrStatisticsList.add(EmiStatistics(IMG_PAYMENT, "\u{20B9}${TotalAmountTopay.value ?? "N.A"}", "Total Payment", ORANGE_YELLOW_COLOR));
    arrStatisticsList.add(EmiStatistics(IMG_PAYMENT, "\u{20B9}${TotalAmountTopay.value ?? "N.A"}", "Total Payment", ORANGE_YELLOW_COLOR));
    arrStatisticsList.add(EmiStatistics(IMG_PAYMENT, "\u{20B9}${TotalAmountTopay.value ?? "N.A"}", "Total Payment", ORANGE_YELLOW_COLOR));
    arrStatisticsList.add(EmiStatistics(IMG_INTEREST, "\u{20B9} ${TotalIntrest.value ?? "N.A"}", "Total Interest Payable", ORANGE_COLOR));
    arrStatisticsList.add(EmiStatistics(IMG_PAYMENT, "\u{20B9}${TotalAmountTopay.value ?? "N.A"}", "Total Payment", ORANGE_YELLOW_COLOR));
    arrStatisticsList.refresh();
    yield  arrStatisticsList;
  }

  var _dollars = 0.obs;
  String getIndianCurrencyInShorthand({required double amount}) {
    final inrShortCutFormatInstance =
    NumberFormat.compactSimpleCurrency(locale: 'en_IN', name: "");
    // NumberFormat.currency(  name: "INR",
    //   locale: 'en_IN',
    //   decimalDigits: 0, // change it to get decimal places
    //   symbol: '',);
    var inrShortCutFormat = inrShortCutFormatInstance.format(amount);
    if (inrShortCutFormat.contains('T')) {
      return inrShortCutFormat.replaceAll(RegExp(r'T'), 'C');
    }
    return inrShortCutFormat;
  }

  EDIT_PRICE_EMI_PRINCIPLE_AMOUNT_WITH_BOTTOMSHEET(String Header,String label,String hinttext,String check) {
    cate_name.value!.text="${amountProgress.value}";
    Intresr_cont.value!.text="${interestProgress.value.toString()}";

    bottomSheetDialog(
      // context: Get.context,
      child: Edit_Emi_Price(hinttext,label,check),
      // context: context,
      message: Header,
      backgroundColor: APP_THEME_COLOR,
      // mainColor: AppColors.MENUBG,
      isCloseMenuShow: true,
    );

  }

  Widget Edit_Emi_Price(String hinttext,String label,String check) {
    return SingleChildScrollView(
      child: Container(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(contextCommon).viewInsets.bottom),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  0.0, 20.0, 0.0, 0.0), // content padding
              child: Form(
                key: _formKey,
                child: new Wrap(
                  children: <Widget>[



                    simpleTextFieldNewWithCustomization(
                        hintText: hinttext,

                        // imageIcon: IMG_PROFILEUSER_SVG_DASHBOARD,
                        imageIcon: IMG_USER_SVG_NEW,
                        controller:check=="0"? cate_name:Intresr_cont,
                        textInputType: TextInputType.numberWithOptions(decimal: true),
                        // inputformat: [FilteringTextInputFormatter.digitsOnly],
                        inputFormat: [
                          // WhitelistingTextInputFormatter(RegExp("\d*[.]\d*")),
                          // FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),

                        ],
                        labelText: label,
                        validator: (value) =>
                        check.toString()=="0"? Principle_validation(cate_name.value!.text): Intrest_value_validation(Intresr_cont.value!.text)),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: AddButton(check,140)),
                    ),
                  ],
                ),
              ))),
    );
  }


  Principle_validation(String? value) {

    if (value!.trim().isEmpty) {
      return "please enter valid value";
    }
    else if(double.parse(value)<1000000){
      return "please enter value greater than 1000000";
    }
    else if(double.parse(value)>100000000){
      return "please enter value less than 100000000";
    }
    else{
      return null;
    }
  }

  Intrest_value_validation(String? value) {

    if (value!.trim().isEmpty) {
      return "please enter valid value";
    } else if(double.parse(value)<3.0){
      return "please enter value greater 3.0";
    }
    else if(double.parse(value)>18.0){
      return "please enter value less than 18.0";
    }
    else{
      return null;
    }
  }



  Widget AddButton(String check,[double? width]) {
    return OnTapButton(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            if(check=="0"){
              amountProgress.value =double.parse(cate_name.value!.text) ;
              emiCalculation();
            }
            if(check=="1"){
              interestProgress.value = double.parse( Intresr_cont.value!.text);
              emiCalculation();
            }

            Navigator.of(contextCommon).pop();
          }

        },
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Edit",
        width: width,
        height: 45,
        style:
        TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w600)
      // TextStyle(color: WHITE)
    );
  }



  /*this is the counting mechanism*/

  emiCalculation() {
    if (amountProgress.value!=0
        && interestProgress.value!=0&& loanyearsProgress.value!=0
    ) {
      double principleamount = double.parse(amountProgress.value.toString());
      double intrestamount = double.parse(interestProgress.value.toString());
      // double year = double.parse( arrLoanList[selectedLoan.value].toString());
      double year = double.parse(loanyearsProgress.value.toString());
      double month = year*12;
      double rateintrest = (intrestamount / 100 / 12);
      var calculatedintresrt = (pow(1 + rateintrest, month));
      double emifinal = ((principleamount * rateintrest * calculatedintresrt) /
          (calculatedintresrt - 1));
      // print(emifinal);
      // print(emifinal.round().toString() + " this is final");
      Emi.value = emifinal.round().toString();
      double totalamount = (emifinal * month);
      double totalintrest = totalamount - principleamount;
      // TotalIntrest.value=totalintrest.toString();
      TotalIntrest.value = (totalintrest.round().toString());
      TotalAmountTopay.value = totalamount.round().toString();
      Updatelistafterchages();

    }
  }

}

