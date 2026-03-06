  import 'package:ecommerce_admin/core/themes/app_color.dart';
  import 'package:ecommerce_admin/features/order/provider/order_provider.dart';
  import 'package:ecommerce_admin/features/order/widget/order_widget.dart';
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';

  class OrederScreens extends StatelessWidget {
    const OrederScreens({super.key});

    @override
    Widget build(BuildContext context) {
      return  Scaffold(

        backgroundColor: AppColor.bagroundColor,


        body: SingleChildScrollView(
          child: Column(
            children: [
          Row(
            children: [
                  Expanded(child: OrderWidget.orderHeadercontainer(
            context,
            "Total Orders",
            1284,
            Icons.shopping_bag,
            "+12.5%",
            Colors.blue,
          ),),
                Expanded(child: OrderWidget.orderHeadercontainer(
            context,
            "Pending Orders",
            1284,
            Icons.pending_actions_outlined,
            "+12.5%",
            Color(0xFFF59E0B),
          ),),
                  Expanded(child: OrderWidget.orderHeadercontainer(
            context,
            "Delivered Orders",
            1284,
            Icons.check_circle_sharp,
            "+12.5%",
            Color(0XFF10B981), 
          ),),
                    Expanded(child: OrderWidget.orderHeadercontainer(
            context,
            "Cancelled",
            1284,
            Icons.cancel ,
            "+12.5%",
            Color(0xFFF43F5E),
          ),)
            ],
          ),
    SizedBox(height: 23,),
          
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.containerBaground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // ProductFilterTabs(),

                            Spacer(),
                            OrderWidget.searchDetails(),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(thickness: 0.2),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            OrderWidget.headerrow(),

                            SizedBox(height: 10),
                            Divider(thickness: 0.2),
                            SizedBox(height: 10),

                            Consumer<OrderProvider>(
    builder: (context, provider, child) {
      return StreamBuilder<List<Map<String, dynamic>>>(
        stream: provider.getOrders(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data ?? [];

          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (context, index) =>
                Divider(thickness: 0.2),
            itemBuilder: (context, index) {

              final data = orders[index];

              return OrderWidget.detailsRow(data, index, context);
            },
          );
        },
      );
    },
  )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
          
            ],
          ),
        ),
      );
    }
  }