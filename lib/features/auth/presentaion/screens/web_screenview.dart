
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/auth/domain/login_reporistory/login_user.dart';
import 'package:ecommerce_admin/features/auth/presentaion/widget/elevated_Costome.dart';
import 'package:ecommerce_admin/features/auth/presentaion/widget/textform_Costome.dart';
import 'package:flutter/material.dart';

class WebScreenview extends StatelessWidget {
  const WebScreenview({super.key});

  @override
  Widget build(BuildContext context) {

    LoginUser loginUser =LoginUser();
    TextEditingController admincontroller = TextEditingController();
    TextEditingController passswordcontroller = TextEditingController();
    
  
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: AppColor.bagroundColor,
              child: Center(child:Text("Admin Panel",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
            ),
          ),
          Expanded(
            child: Container(
              color: AppColor.bagroundColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextFormField(
                      labelText: "Admin Id",
                      controller: admincontroller,
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      labelText: "password",
                      controller: passswordcontroller,
                    ),
                    SizedBox(height: 20),
 CustomButton(onPressed: ()async{
       await loginUser.login(context, admincontroller, passswordcontroller);
                 }, text:  "logi in")
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
