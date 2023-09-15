import 'package:flutter/cupertino.dart';

import '../Config/utils/Strings.dart';
import '../Config/utils/styles.dart';

class Timming_System_Message_Chat_Screen extends StatelessWidget{
  final String?  message;
  final bool? mtype;
  Timming_System_Message_Chat_Screen({this.message,this.mtype});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        child:Container(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cornarradius),
                gradient: const LinearGradient(
                    colors:[
                      Color(0xffe1f5fe),
                      Color(0xffe1f5fe),

                    ]
                )),
            child: Padding(
              padding: const EdgeInsets.only(left: 5,right: 5),
              child: Text(message!,textAlign: TextAlign.center,
                style: regularTextStyle(txtColor:const Color(0XFF58666e),fontSize: 12 )
              // TextStyle(color:Colors.red[800],fontSize: 12),
            ),)


        ),),
    );
  }

}