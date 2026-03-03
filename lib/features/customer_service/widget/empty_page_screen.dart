import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class EmptyPageScreen {

  static  Widget emptyChatPage(){

    return Center(
     child:  Column(
       children: [
         Container(child: Image.asset("assets/chat_empty_Screen/empty.png")),
         Text("Select a conversation",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.w800,fontSize: 28),),
         SizedBox(height: 20,),
         Text('''Choose a message from the left sidebar to view the full
conversation history. You can manage product approvals,
resolve seller issues, and handle account verification
requests.''',style: TextStyle(color: AppColor.greyColor),)
       ],
     ),
    );
  }
}