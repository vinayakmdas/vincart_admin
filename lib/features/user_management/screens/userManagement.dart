import 'package:ecommerce_admin/features/user_management/widget/user_widget.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/user_management/provider/user_provider.dart';
import 'package:provider/provider.dart';


class UserManagement extends StatelessWidget {
  const UserManagement({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.bagroundColor,
      body: Column(
        children: [

          const SizedBox(height: 20),

          /// USER COUNT
          StreamBuilder<int>(
            stream: provider.getUserCount(),
            builder: (context, snapshot) {

              int count = snapshot.data ?? 0;

              return  UserContainer.userCountContainer(
                count,
                context,
                const Text(
                  "Total Users",
                  style: TextStyle(color: Colors.white),
                ),
                Icons.people,
                AppColor.orangeColor,
              );
            },
          ),

          const SizedBox(height: 20),

          /// USER LIST
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [

                  UserContainer.userHeading(),

                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: provider.getUserStream(),
                      builder: (context, snapshot) {

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text("NO USERS FOUND"),
                          );
                        }

                        final users = snapshot.data!.docs;

                        return ListView.separated(
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemCount: users.length,
                          itemBuilder: (context, index) {

                            var data = users[index].data()
                                as Map<String, dynamic>;

                            return UserContainer.userRow(data);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}