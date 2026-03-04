import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/customer_service/widget/chatscreen_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String sellerUid;

  const ChatScreen({super.key, required this.sellerUid});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final adminUid = FirebaseAuth.instance.currentUser!.uid;

    final chatId = ChatscreenWidget. generateChatId(adminUid, widget.sellerUid);

print(" this is admin id $adminUid");
print("this is chatid $chatId");
  return Scaffold(
  backgroundColor: AppColor.productBaground,
  body: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20), // 👈 LEFT & RIGHT 20
    child: Column(
      children: [

        /// MESSAGES
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat_rooms')
                .doc(chatId)
                .collection('messages')
                .orderBy('createdAt')
                .snapshots(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return const SizedBox();
              }

              final messages = snapshot.data!.docs;

              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {

                  final message = messages[index];

                  final isMe =
                      message['senderId'] == adminUid;

                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue :Color(0xFF212830),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isMe
                              ? const Radius.circular(16)
                              : const Radius.circular(0),
                          bottomRight: isMe
                              ? const Radius.circular(0)
                              : const Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        message['text'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        /// INPUT AREA
        Row(
          children: [
            Expanded(
              child: TextField(
                textInputAction: TextInputAction.send ,
                onSubmitted: (value) async {   // 👈 triggers when Enter is pressed
      if (value.trim().isEmpty) return;

      await sendMessage();   // call reusable function
    },
                controller: controller,style: TextStyle(color: AppColor.greyColor ),
                decoration: InputDecoration(
                  hintText: "Type message...",
                  hintStyle: TextStyle(color: AppColor.greyColor),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF334154), // 👈 border color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF334154),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// SEND BUTTON
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF3D84F5), // 👈 button background
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () async {

                  if (controller.text.trim().isEmpty) return;

                  await FirebaseFirestore.instance
                      .collection('chat_rooms')
                      .doc(chatId)
                      .set({
                        'adminId': adminUid,
                        'sellerId': widget.sellerUid,
                        'lastMessage': controller.text,
                        'lastMessageTime': FieldValue.serverTimestamp(),
                      }, SetOptions(merge: true));

                  await FirebaseFirestore.instance
                      .collection('chat_rooms')
                      .doc(chatId)
                      .collection('messages')
                      .add({
                        'senderId': adminUid,
                        'text': controller.text,
                        'createdAt': FieldValue.serverTimestamp()
                      });

                  controller.clear();
                },
              ),
            )
          ],
        ),

        const SizedBox(height: 15),
      ],
    ),
  ),
);
  }
  
  Future<void> sendMessage() async {
  final adminUid = FirebaseAuth.instance.currentUser!.uid;
  final chatId =
      ChatscreenWidget.generateChatId(adminUid, widget.sellerUid);

  if (controller.text.trim().isEmpty) return;

  await FirebaseFirestore.instance
      .collection('chat_rooms')
      .doc(chatId)
      .set({
        'adminId': adminUid,
        'sellerId': widget.sellerUid,
        'lastMessage': controller.text,
        'lastMessageTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  await FirebaseFirestore.instance
      .collection('chat_rooms')
      .doc(chatId)
      .collection('messages')
      .add({
        'senderId': adminUid,
        'text': controller.text,
        'createdAt': FieldValue.serverTimestamp()
      });

  controller.clear();
}
}