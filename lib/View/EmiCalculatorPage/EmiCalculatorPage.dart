import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/EmiCalculatorController/EmiCalculatorController.dart';
import 'package:Repeople/Model/EmiCalculatorModal/EmiCalculatorModal.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class EmiCalculatorPage extends StatefulWidget {
  const EmiCalculatorPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EmiCalculatorPageState createState() => _EmiCalculatorPageState();
}

class _EmiCalculatorPageState extends State<EmiCalculatorPage> {

  EmiCalculatorController cntEmiController = Get.put(EmiCalculatorController());
  CommonHeaderController cntCommonHeader = Get.put(CommonHeaderController());

  @override
  Widget build(BuildContext context) {
    cntEmiController.arrLoanList.clear();
    cntEmiController.arrAllThemeList.clear();
    cntEmiController.arrStatisticsList.clear();
    cntEmiController.CreateStatisticsList();
    cntEmiController.emiCalculation();
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cntEmiController.Globalemipagekey,
      endDrawer: CustomDrawer(
        animatedOffset: const Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: const Offset(-1.0, 0),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: APPBAR_HEIGHT,),
                  emiLoanTitle(),
                  emiStatistic(),
                  emiCalculate(),
                ],
              ),
            ),
            cntCommonHeader.commonAppBar(EMI_CALCULATOR, cntEmiController.Globalemipagekey,color: white),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: BottomNavigationBarClass(),
            // )
          ],
        ),
      ),
    );
  }
  // loan title 1
  Widget emiLoanTitle() {
    return Obx(() =>   Container(
      padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lblEmiYourEmi,
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
                fontFamily: fontFamily,
                color: new_black_color),
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(cntEmiController.Emi.value!=""?"\u{20B9} ${cntEmiController.numberFormat.format(int.parse(cntEmiController.Emi.value))}" : "N.A",
                style:TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: fontFamily,
                    color: new_black_color),
              ),
              const SizedBox(width: 8,),
              Padding(
                padding:  const EdgeInsets.only(top: 10.0),
                child: Text(lblEmiPerMonth,
                  style:TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: fontFamily,
                      color: new_black_color),
                  textAlign: TextAlign.end,

                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget emiStatistic() {
    return
      StreamBuilder(
          stream: cntEmiController.EMI_STREAM.stream,
          builder: (context, AsyncSnapshot<List<EmiStatistics>> snapshot,) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {}
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              // height: 300,
              width: Get.width,
              margin: const EdgeInsets.only(left: LEFT_PADDING),
              child:
              GridView.builder(
                padding: const EdgeInsets.only(bottom: 15),
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cntEmiController.arrStatisticsList.isNotEmpty ? cntEmiController.arrStatisticsList.length : 0,
                itemBuilder: (context, i) {
                  return  wdGenerateStatistic(i);
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    // crossAxisSpacing: 5,
                    childAspectRatio: 3.0
                ),),
            );
          }
      );
  }

  Widget wdGenerateStatistic(int index) {
    EmiStatistics obj = cntEmiController.arrStatisticsList[index];
    return SizedBox(
      width: Get.width / 2 - 10,
      child: Row(
        children: [
          ImageWithBackGround(
              image: obj.imgIcon,
              height: 40,
              width: 40,
              imgColor: white,
              backgroundColor: obj.backfgroundColor,
              radius: 30,
              elevetion: 3,
              padding: 10),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  obj.paymentDesc,
                  style: TextStyle(fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: fontFamily,
                      color: LIGHT_GREY_COLOR),
                ),
                Text(
                  obj.paymentValue,
                  style: TextStyle(fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: fontFamily,
                      color: DARK_BLUE),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }

  Widget emiCalculate() {
    return
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
        child: Container(
          margin: const EdgeInsets.only(top: 0, bottom: 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Obx(() =>  Container(
                  child: Sf_SliderIndicator(
                    title: "$lblEmiPrincipalTitle(\u{20B9})",
                    value: cntEmiController.amountProgress.value,
                    max: 30000000,
                    min: 0,
                    enableTooltip: true,
                      showLabels: true,
                    showTicks: true,
                    tooltipShape: const SfPaddleTooltipShape(),
                    interval: 3000000,
                    thumbIcon: CustomTooltip(value: cntEmiController.amountProgress.value),
                    labelPlacement: LabelPlacement.onTicks,
                    labelFormatterCallback: (value, formattedText) {
                      if(value == 0){
                        return '0';
                      }else if(value == 3000000){
                        return '30 Lac';
                      }else if(value == 6000000){
                        return '60 Lac';
                      }else if(value == 9000000){
                        return '90 Lac';
                      }else if(value == 12000000){
                        return '1.2 Cr';
                      }else if(value == 15000000){
                        return '1.5 Cr';
                      }else if(value == 18000000){
                        return '1.8 Cr';
                      }else if(value == 21000000){
                        return '2.1 Cr';
                      }else if(value == 24000000){
                        return '2.4 Cr';
                      }else if(value == 27000000){
                        return '2.7 Cr';
                      }else if(value == 30000000){
                        return '3.0 Cr';
                      }else{
                        return '';
                      }
                    },
                    stepSize: 0,
                    // tooltipTextFormatterCallback: (actualValue, formattedText) {
                    //   return '${(actualValue / 10000000).toStringAsFixed(1)} cr';
                    // },
                    minorTicksPerInterval: 0,
                    onChanged: (value) {
                      if(value==0){
                        cntEmiController.Emi.value="0";
                        cntEmiController.TotalIntrest.value="0";
                        cntEmiController.TotalAmountTopay.value="0";
                        cntEmiController.Updatelistafterchages();
                      }
                      cntEmiController.amountProgress.value = value;
                      cntEmiController.emiCalculation();
                    },
                    edit_option: true,
                    editwidget: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1,color: DARK_BLUE)
                      ),
                      child: Center(
                        child: Text(
                          cntEmiController.numberFormat.format(double.parse(cntEmiController.amountProgress.value.toStringAsFixed(2))),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: DARK_BLUE,
                            fontWeight: FontWeight.w700,
                            fontFamily: fontFamily,
                            fontSize: 8.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),


                const SizedBox(height: 10,),

                Obx(() =>  Sf_SliderIndicator(
                  width: Get.width,
                  title: lblEmiInterestTitle+("(%)"),
                  value: cntEmiController.interestProgress.value,

                  max: 14,
                  min: 4,
                  enableTooltip: true,
                  tooltipShape: const SfPaddleTooltipShape(),
                  shouldAlwaysShowTooltip: false,
                  showTicks: true,
                  showLabels: true,
                  interval: 1,
                  onChanged: (value) {
                    if(value==0){
                      cntEmiController.Emi.value="0";
                      cntEmiController.TotalIntrest.value="0";
                      cntEmiController.TotalAmountTopay.value="0";
                      cntEmiController.Updatelistafterchages();
                    }
                    cntEmiController.interestProgress.value = value;
                    cntEmiController.emiCalculation();
                  },
                  edit_option: true,
                  editwidget: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1,color: DARK_BLUE)
                    ),
                    child: Center(
                      child: Text(
                        cntEmiController.interestProgress.value.toStringAsFixed(2),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: DARK_BLUE,
                          fontWeight: FontWeight.w700,
                          fontFamily: fontFamily,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 10,),

                Obx(() =>  Sf_SliderIndicator(
                  title: "$lblEmiLoanTitle(Years)",
                  value: cntEmiController.loanyearsProgress.value,
                  max: 30,
                  min: 0,
                  enableTooltip: true,
                  tooltipShape: const SfPaddleTooltipShape(),
                  shouldAlwaysShowTooltip: false,
                  showTicks: true,
                  showLabels: true,
                  interval: 3,
                  onChanged: (value) {
                    if(value==0){
                      cntEmiController.Emi.value="0";
                      cntEmiController.TotalIntrest.value="0";
                      cntEmiController.TotalAmountTopay.value="0";
                      cntEmiController.Updatelistafterchages();
                    }
                    cntEmiController.loanyearsProgress.value = value;
                    cntEmiController.emiCalculation();
                  },
                  edit_option: true,
                  editwidget: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1,color: DARK_BLUE)
                    ),
                    child: Center(
                      child: Text(
                        "${cntEmiController.loanyearsProgress.value.round()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: DARK_BLUE,
                          fontWeight: FontWeight.w700,
                          fontFamily: fontFamily,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 50),
              ]),
        ),
      );

  }
}

class CustomTooltip extends StatelessWidget {
  final double value;

  CustomTooltip({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10.0), // Customize the tooltip shape border radius
      ),
      padding: EdgeInsets.all(8.0),
      child: Text(
        value.toStringAsFixed(1),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
