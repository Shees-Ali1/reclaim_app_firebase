import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../const/color.dart';
import '../../../controller/chat_controller.dart';
import '../../../widgets/custom_text.dart';

class SupportChatMessageContainer extends StatefulWidget {
  // final String chatId;
  // final String image;

  const  SupportChatMessageContainer({
    super.key,
    // required this.chatId,
    // required this.image,
  });

  @override
  State<SupportChatMessageContainer> createState() => _SupportChatMessageContainerState();
}

class _SupportChatMessageContainerState extends State<SupportChatMessageContainer> {
late Stream<QuerySnapshot> messageSnap;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageSnap = FirebaseFirestore.instance
        .collection('supportChat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser?.uid;
    final ScrollController scrollController = ScrollController();
    final ChatController chatController = ChatController();
    return StreamBuilder<QuerySnapshot>(
        stream:messageSnap,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text("Snapshot Error");
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(child: const Text("No Chat Yet"));
          } else {
            dynamic messages = snapshot.data!.docs;
            DateTime? lastShownTimestamp;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
              );
            });
            return  ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              addAutomaticKeepAlives: true,
              scrollDirection: Axis.vertical,
              itemCount: messages.length,
              padding: EdgeInsets.only(bottom: 80.h),
              itemBuilder: (context, index) {
                final role = messages[index]['userId'];
                var timestamp = messages[index]['timestamp'] as Timestamp;
                var messageTime = timestamp.toDate();
                var formattedTime = chatController.formatMessageTimestamp(timestamp);

                // Check if the message field exists
                final messageText = messages[index].data().containsKey('message')
                    ? messages[index]['message']
                    : ""; // Fallback text if the message doesn't exist

                return Container(
                  alignment: role == currentUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: RobotoCustomText(
                          text: formattedTime,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w400,
                          textColor: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Row(
                          mainAxisAlignment: role == currentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                role == currentUser
                                    ? const SizedBox.shrink()
                                    : Padding(
                                  padding: EdgeInsets.only(top: 10.sp),
                                  child:
                                  // image != ''
                                  //     ? Container(
                                  //   height: 24.h,
                                  //   width: 24.w,
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.grey,
                                  //     shape: BoxShape.circle,
                                  //     image: DecorationImage(
                                  //       image: NetworkImage(image),
                                  //       fit: BoxFit.cover,
                                  //     ),
                                  //   ),
                                  // )
                                  //     :
                                  const CircleAvatar(),
                                ),
                                Container(
                                  margin: role == currentUser
                                      ? EdgeInsets.symmetric(horizontal: 14.sp)
                                      : EdgeInsets.only(left: 5.sp),
                                  padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 4.h),
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width / 1.3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: role == currentUser ? primaryColor : primaryColor.withOpacity(0.08),
                                  ),
                                  child: SelectableText(
                                    messageText,
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: role == currentUser ? whiteColor : Colors.black,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );

          }
        });
  }
}
