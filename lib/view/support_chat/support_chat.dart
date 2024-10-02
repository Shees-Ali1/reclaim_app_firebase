import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:reclaim_firebase_app/helper/loading.dart';
import '../../const/color.dart';
import '../../controller/chat_controller.dart';
import '../../controller/order_controller.dart';
import '../../widgets/custom _backbutton.dart';
import '../../widgets/custom_text.dart';
import '../chat_screen/components/chat_message_container.dart';
import 'component/support_chat_message_container.dart';

class SupportChatScreen extends StatefulWidget {
  // final String image;
  // final String chatName;
  // final String chatId;
  // final String sellerId;
  // final String buyerId;
  // final String seller;
  // final String productId;
  // final String productName;
  // final String brand;
  // final int productPrice;
  const SupportChatScreen({
    super.key,
    // required this.image,
    // required this.chatName,
    // required this.chatId,
    // required this.sellerId,
    // required this.buyerId,
    // required this.seller,
    // required this.productId,
    // required this.productName,
    // required this.productPrice,
    // required this.brand,
  });

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final ChatController chatController = Get.find<ChatController>();
  final TextEditingController messageController = TextEditingController();
  final OrderController orderController = Get.find<OrderController>();
  bool seller = false;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        body: Column(children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25.r),
                    bottomLeft: Radius.circular(25.r)),
                color: primaryColor,
              ),
              child: SafeArea(
                  child: Column(children: [
                SizedBox(
                  height: 10.h,
                ),
                Row(children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  const CustomBackButtonMessage(),
                  SizedBox(
                    width: 13.w,
                  ),
                  Container(
                    height: 53.h,
                    width: 53.w,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(''),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  SizedBox(
                    width: 240.w,
                    child: InterCustomText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: "Chat with Admin",
                      textColor: Colors.white,
                      fontsize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
                SizedBox(
                  height: 10.h,
                ),
              ]))),
          Expanded(
              child: Stack(
            children: [
              SupportChatMessageContainer(
              ),
            ],
          )),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(29.5.r),
                  ),
                  width: 293.w,
                  height: 54.h,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 10.w, bottom: 5.h),
                            hintText: 'Type your message',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                GestureDetector(
                  onTap: () async{
                      if (messageController.text.trim().isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection('supportChat')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('messages')
                            .add({
                          "message": messageController.text.trim(),
                          "timestamp": DateTime.now(),
                          "userId": FirebaseAuth.instance.currentUser!.uid,
                        });
                        messageController.clear();
                        await FirebaseFirestore.instance.
                        collection('supportChat')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({"userId": FirebaseAuth.instance.currentUser!.uid},SetOptions(merge: true));
                      }


                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    height: 53.h,
                    width: 53.w,
                    child: Center(
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ]),
          SizedBox(
            height: 19.h,
          ),
        ]));
  }
}
