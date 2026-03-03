import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/customer_service/screen/chat_screen.dart';
import 'package:ecommerce_admin/features/customer_service/screen/chat_list_scren.dart';
import 'package:ecommerce_admin/features/customer_service/widget/empty_page_screen.dart';
import 'package:flutter/material.dart';

class ChatLayoutScreen extends StatefulWidget {
  const ChatLayoutScreen({super.key});

  @override
  State<ChatLayoutScreen> createState() => _ChatLayoutScreenState();
}

class _ChatLayoutScreenState extends State<ChatLayoutScreen> {

  String? selectedSellerUid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.chatbagroundColor,
      body: Row(
        children: [

          /// LEFT SIDE - SELLER LIST
          Expanded(
            flex: 2,
            child: ChatListSCreen(
              onSellerSelected: (uid) {
                setState(() {
                  selectedSellerUid = uid;
                });
              },
            ),
          ),

          /// RIGHT SIDE - CHAT
          Expanded(
            flex: 4,
            child: selectedSellerUid == null
                ?   EmptyPageScreen.emptyChatPage()
                : ChatScreen(sellerUid: selectedSellerUid!),
          ),
        ],
      ),
    );
  }
}