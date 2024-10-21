//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
//
//
// import '../../../const/assets/image_assets.dart';
// import '../../../const/color.dart';
// import '../../../controller/chat_controller.dart';
// import '../../../widgets/custom_text.dart';
//
// class ChatMessageContainer extends StatelessWidget {
//   final String role;
//   final String messageText;
//   final bool shouldShowTime;
//   final String formattedTime;
//
//   const ChatMessageContainer({
//     super.key,
//     required this.role,
//     required this.messageText,
//     required this.shouldShowTime,
//     required this.formattedTime,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     var currentUser = 'me'; // Assuming 'Me' is the current user
//     return Container(
//       alignment: role == currentUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment: role == currentUser ? CrossAxisAlignment.center : CrossAxisAlignment.center,
//         children: [
//           if (shouldShowTime)
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: RobotoCustomText(
//                 text: formattedTime, // Display the formatted time properly
//                 fontsize: 12.sp,
//                 fontWeight: FontWeight.w400,
//                 textColor: Colors.black,
//               ),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(7.0),
//             child: Row(
//               mainAxisAlignment: role == currentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//               children: [
//                 // Only show user image for other users (not current user)
//                 role == currentUser
//                     ? const SizedBox.shrink()
//                     : Padding(
//                   padding: EdgeInsets.only(top: 10.sp),
//                   child: Container(
//                     height: 24.h,
//                     width: 24.w,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: AssetImage(AppImages.image1),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Display the message text with styling
//                 Container(
//                   margin: role == currentUser
//                       ? EdgeInsets.symmetric(horizontal: 14.sp)
//                       : EdgeInsets.only(left: 5.sp),
//                   padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 4.h),
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width / 1.3,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20.r),
//                     color: role == currentUser
//                         ? primaryColor
//                         : Color(0xff29604E).withOpacity(0.10)
//                   ),
//                   child: SelectableText(
//                     messageText, // Display the actual passed message text
//                     style: GoogleFonts.roboto(
//                       textStyle: TextStyle(
//                         color: role == currentUser ? Colors.white : Colors.black,
//                         fontSize: 13.sp,
//                         fontWeight: FontWeight.w300,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// // return StreamBuilder<QuerySnapshot>(
// //     stream: FirebaseFirestore.instance
// //         .collection('userMessages')
// //         .doc(chatId)
// //         .collection('messages')
// //         .orderBy('timeStamp', descending: false)
// //         .snapshots(),
// //     builder: (context, snapshot) {
// //       if (snapshot.connectionState == ConnectionState.waiting) {
// //         return Center(child: CircularProgressIndicator());
// //       } else if (snapshot.hasError) {
// //         return Text("Snapshot Error");
// //       } else if (snapshot.data!.docs.isEmpty) {
// //         return Text("NO Data");
// //       } else {
// //         dynamic messages = snapshot.data!.docs;
// //         DateTime? lastShownTimestamp;
// //
// //         WidgetsBinding.instance!.addPostFrameCallback((_) {
// //           scrollController.animateTo(
// //             scrollController.position.maxScrollExtent,
// //             duration: const Duration(milliseconds: 350),
// //             curve: Curves.easeOut,
// //           );
// //         });
// // return ListView.builder(
// //   controller: scrollController,
// //   shrinkWrap: true,
// //   addAutomaticKeepAlives: true,
// //   scrollDirection: Axis.vertical,
// //   itemCount: messages.length,  // Make sure itemCount matches your list length
// //   padding: EdgeInsets.only(bottom: 80.h),
// //   itemBuilder: (context, index) {
// //     final role = messages[index]['userId'];
// //     var timestamp = messages[index]['timeStamp'] as Timestamp;
// //     var messageTime = timestamp.toDate();
// //
// //     // Determine if we should show the time based on message time
// //     var shouldShowTime = chatController.shouldShowTimestamp(
// //         messageTime, lastShownTimestamp);
// //
// //     if (shouldShowTime) {
// //       lastShownTimestamp = messageTime;
// //     }
// //
// //     // Format the timestamp
// //     var formattedTime = chatController.formatMessageTimestamp(timestamp);
// //
// //     // Get the actual message content (Ensure messages list is not null)
// //     var messageText = messages[index]['messageText'] ?? '';
// //
// //     return
// //       Container(
// //       alignment: role == currentUser
// //           ? Alignment.centerRight
// //           : Alignment.centerLeft,
// //       child: Column(
// //         crossAxisAlignment: role == currentUser
// //             ? CrossAxisAlignment.end
// //             : CrossAxisAlignment.start,
// //         children: [
// //           if (shouldShowTime)
// //             Padding(
// //               padding: const EdgeInsets.all(12.0),
// //               child: RobotoCustomText(
// //                 text: formattedTime,  // Display the formatted time
// //                 fontsize: 12.sp,
// //                 fontWeight: FontWeight.w400,
// //                 textColor: Colors.black,
// //               ),
// //             ),
// //           Padding(
// //             padding: const EdgeInsets.all(7.0),
// //             child: Row(
// //               mainAxisAlignment: role == currentUser
// //                   ? MainAxisAlignment.end
// //                   : MainAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   crossAxisAlignment: CrossAxisAlignment.end,
// //                   children: [
// //                     // Show user image for other users, not for current user
// //                     role == currentUser
// //                         ? const SizedBox.shrink()
// //                         : Padding(
// //                       padding: EdgeInsets.only(top: 10.sp),
// //                       child: Container(
// //                         height: 24.h,
// //                         width: 24.w,
// //                         decoration: BoxDecoration(
// //                           color: Colors.grey,
// //                           shape: BoxShape.circle,
// //                           image: DecorationImage(
// //                             image: AssetImage(AppImages.image1),
// //                             fit: BoxFit.cover,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     Container(
// //                       margin: role == currentUser
// //                           ? EdgeInsets.symmetric(horizontal: 14.sp)
// //                           : EdgeInsets.only(left: 5.sp),
// //                       padding: EdgeInsets.symmetric(
// //                           horizontal: 17.w, vertical: 4.h),
// //                       constraints: BoxConstraints(
// //                         maxWidth: MediaQuery.of(context).size.width / 1.3,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(10.r),
// //                         color: role == currentUser
// //                             ? primaryColor
// //                             : primaryColor.withOpacity(0.08),
// //                       ),
// //                       child: SelectableText(
// //                         messageText,  // Display the actual message text
// //                         style: GoogleFonts.roboto(
// //                           textStyle: TextStyle(
// //                             color: role == currentUser
// //                                 ? whiteColor
// //                                 : Colors.black,
// //                             fontSize: 13.sp,
// //                             fontWeight: FontWeight.w300,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   },
// // );

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../const/color.dart';
import '../../../controller/chat_controller.dart';
import '../../../widgets/custom_text.dart';

class ChatMessageContainer extends StatefulWidget {
  final String chatId;
  final String image;

  const ChatMessageContainer({
    super.key,
    required this.chatId,
    required this.image,
  });

  @override
  State<ChatMessageContainer> createState() => _ChatMessageContainerState();
}

class _ChatMessageContainerState extends State<ChatMessageContainer> {
  late Stream<QuerySnapshot> messageSnap;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageSnap = FirebaseFirestore.instance
        .collection('userMessages')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser?.uid;
    final ScrollController scrollController = ScrollController();
    final ChatController chatController = ChatController();
    return StreamBuilder<QuerySnapshot>(
        stream: messageSnap,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text("Snapshot Error");
          } else if (snapshot.data!.docs.isEmpty) {
            return const Text("NO Data");
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
            return ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              addAutomaticKeepAlives: true,
              scrollDirection: Axis.vertical,
              itemCount: messages.length,
              padding: EdgeInsets.only(bottom: 80.h),
              itemBuilder: (context, index) {
                final role = messages[index]['userId'];
                var timestamp = messages[index]['timeStamp'] as Timestamp;
                var messageTime = timestamp.toDate();
                var formattedTime =
                    chatController.formatMessageTimestamp(timestamp);

                // Check if the message field exists
                final messageText =
                    messages[index].data().containsKey('message')
                        ? messages[index]['message']
                        : ""; // Fallback text if the message doesn't exist

                return Container(
                  alignment: role == currentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
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
                          mainAxisAlignment: role == currentUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                role == currentUser
                                    ? const SizedBox.shrink()
                                    : Padding(
                                        padding: EdgeInsets.only(top: 10.sp),
                                        child: widget.image != ''
                                            ? Container(
                                                height: 24.h,
                                                width: 24.w,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        widget.image),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : const CircleAvatar(),
                                      ),
                                Container(
                                    margin: role == currentUser
                                        ? EdgeInsets.symmetric(
                                            horizontal: 14.sp)
                                        : EdgeInsets.only(left: 5.sp),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 17.w, vertical: 4.h),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width /
                                              1.3,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: role == currentUser
                                          ? primaryColor
                                          : primaryColor.withOpacity(0.08),
                                    ),
                                    child: Column(
                                      children: [
                                        if (messages[index]['type'] == "image")
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.h),
                                            child: CachedNetworkImage(
                                              imageUrl: messages[index]
                                                      ['image'] ??
                                                  '',
                                              width: 200
                                                  .w, // Set a desired width for the image
                                              height: 200
                                                  .h, // Set a desired height for the image
                                              fit: BoxFit
                                                  .cover, // Ensure the image fits within the box
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                color: primaryColor,
                                              )), // Show a loading spinner while the image is loading
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Icon(Icons
                                                      .error), // Show an error icon if the image fails to load
                                            ),
                                          ),
                                        if (messageText != null &&
                                            messageText
                                                .isNotEmpty) // Check if text exists
                                          SelectableText(
                                            messageText,
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                color: role == currentUser
                                                    ? whiteColor
                                                    : Colors.black,
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ))
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
