import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class BrandList {


//^ Brand heading + search
  static Widget brandHeading(
    TextEditingController controller,
    ValueChanged<String> onSearch,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            "Brand List",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 300,
            height: 42,
            child: TextFormField(
              controller: controller,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: "Search Brand...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColor.primaryColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColor.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
//^brand List Name

  static Widget brandDetailsHeading() {
    return Container(
      color: AppColor.primaryColor,
      child: Row(
        children: [
          SizedBox(width: 20),
          SizedBox(height: 50,),

          Expanded(
            child: Text(
              "S.No",
              style: TextStyle(color: AppColor.whiteColor),
            ),
          ),
          Expanded(
            child: Text(
              "Brand Name",
              style: TextStyle(color: AppColor.whiteColor),
            ),
          ),
        
          Expanded(
            child: Text("Logo", style: TextStyle(color: AppColor.whiteColor)),
          ),
          
          Expanded(
            child: Text("Status", style: TextStyle(color: AppColor.whiteColor)),
          ),
          Expanded(
            child: Text(
              "Created At",
              style: TextStyle(color: AppColor.whiteColor),
            ), 
          ),
             
          Expanded(
            child: Row(
              children: [
                 SizedBox(width: 80,),
                Text("Action", style: TextStyle(color: AppColor.whiteColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // ^firestoregetData



  static  Stream  <List<Map<String, dynamic>>> getingBradnDetails(){


    return FirebaseFirestore.instance.collection('brand').snapshots().map((snapshot){

        return snapshot.docs.map((doc){

          return {

             'id': doc.id,
           ...doc.data(),
          };
        }).toList();
      });
   }  
 
//  ^data row details

  static Widget  datarow(int index ,Map<String, dynamic> brand){
 
 return  Container(
      color: AppColor.contentbg,
      child: Row(
        
        children: [
          SizedBox(width: 20),
          SizedBox(height: 50,),
           Expanded(
            child: Text( '$index',style: TextStyle(color: AppColor.whiteColor),),
          ),
            Expanded(
            child: Text(brand['brandName'] ?? '',style: TextStyle(color: AppColor.whiteColor),),
          ),
     Expanded(
  child: Center(
    child: CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white, // makes logos visible on dark bg
      child: ClipOval(
        child: brand['imageUrl'] != null && brand['imageUrl'].isNotEmpty
            ? Image.network(
                brand['imageUrl'],
                width: 45,   // slightly smaller than CircleAvatar diameter
                height: 45,
                fit: BoxFit.contain, // ✅ full logo visible (no crop)
              )
            : Icon(
                Icons.image,
                color: AppColor.greyColor,
                size: 28,
              ),
      ),
    ),
  ),
),

          Expanded(
            child: Text(brand['status'] ?? '',style: TextStyle(color: AppColor.whiteColor),),
          ),
        Expanded(
  child: Text(
    brand['createdAt'] != null
        ? (brand['createdAt'] as Timestamp)
            .toDate()
            .toString() 
        : '',
    style: TextStyle(color: AppColor.whiteColor),
  ),
),

          Expanded(
            child:  IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: AppColor.whiteColor,))
          ),
        ],
      ),
    );


 }

  




}