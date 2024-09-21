// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../const/assets/image_assets.dart';
// import '../../../controller/chat_controller.dart';
// import '../../../widgets/custom_route.dart';
// import '../../../widgets/custom_text.dart';
// import '../chat_screen.dart';
//
//
// class ChatMessageList extends StatelessWidget {
//   const ChatMessageList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final ChatController chatController = Get.find<ChatController>();
//
//     // return StreamBuilder<QuerySnapshot>(
//     //     stream: FirebaseFirestore.instance
//     //         .collection('chats')
//     //         .doc(FirebaseAuth.instance.currentUser!.uid)
//     //         .collection('convo')
//     //         .snapshots(),
//     //     builder: (context, snapshot) {
//     //       if (snapshot.connectionState == ConnectionState.waiting) {
//     //         return Center(child: CircularProgressIndicator());
//     //       } else if (snapshot.hasError) {
//     //         return SizedBox.shrink();
//     //       } else if (snapshot.data!.docs.isEmpty) {
//     //         return Center(
//     //             child: Column(
//     //           children: [
//     //             SizedBox(
//     //               height: 180.h,
//     //             ),
//     //             Text(
//     //               "No Chats",
//     //               style:
//     //                   TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
//     //             ),
//     //           ],
//     //         ));
//     //       } else {
//     return ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         padding: EdgeInsets.zero,
//         itemCount: 3,
//         shrinkWrap: true,
//         itemBuilder: (context, index) {
//           // final chat = snapshot.data!.docs[index];
//           return ListTile(
//             onTap: () {
//               // CustomRoute.navigateTo(
//               //     context,
//               //     ChatScreen(
//               //       // image:
//               //       // chat['bookImage'] ?? '',
//               //       // chatName: chat['buyerId'] !=
//               //       //     FirebaseAuth
//               //       //         .instance
//               //       //         .currentUser!
//               //       //         .uid
//               //       //     ? chat['bookName']
//               //       //     : "You Bought ${chat['bookName']}",
//               //       // chatId: chat['chatId'],
//               //       // sellerId: chat[
//               //       // 'sellerId'] ==
//               //       //     FirebaseAuth
//               //       //         .instance
//               //       //         .currentUser!
//               //       //         .uid
//               //       //     ? chat['buyerId']
//               //       //     : chat['sellerId'],
//               //       // buyerId: chat['buyerId'],
//               //       // seller: chat['sellerId'],
//               //       // bookId: chat['bookId'],
//               //       // bookName: chat['bookName'],
//               //     ));
//               CustomRoute.navigateTo(context, ChatScreen());
//             },
//             leading: Container(
//               alignment: Alignment.bottomRight,
//               height: 62.h,
//               width: 62.w,
//               decoration: BoxDecoration(
//                   color: Colors.black26,
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                     image: AssetImage(AppImages.image1),
//                     fit: BoxFit.fill,
//                   )),
//               // child: Padding(
//               //   padding:
//               //   const EdgeInsets.all(4.0),
//               //   child: userStatus['online']
//               //       ? Image.asset(
//               //     AppImages.onlinedot,
//               //     height: 10.h,
//               //     width: 10.w,
//               //   )
//               //       : SizedBox.shrink(),
//               // ),
//             ),
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   width: 200.w,
//                   child: LexendCustomText(
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     text: 'Adidas Japan Sneakers',
//                     // text: chat['sellerId'] !=
//                     //     FirebaseAuth
//                     //         .instance
//                     //         .currentUser!
//                     //         .uid
//                     //     ? "YOU bought ${chat['bookName']}"
//                     //     : chat['bookName'],
//                     textColor: Colors.black,
//                     fontWeight: FontWeight.w700,
//                     fontsize: 16.sp,
//                   ),
//                 ),
//                 LexendCustomText(
//                   text: '26/1/24',
//                   textColor: Colors.black,
//                   fontWeight: FontWeight.w400,
//                   fontsize: 12.sp,
//                 ),
//               ],
//             ),
//             subtitle: LexendCustomText(
//               text: 'Hello there',
//               textColor: Colors.black,
//               fontWeight: FontWeight.w400,
//               fontsize: 12.sp,
//             ),
//           );
//           // return StreamBuilder<DocumentSnapshot>(
//           //     stream: FirebaseFirestore.instance
//           //         .collection('booksListing')
//           //         .doc(chat['bookId'])
//           //         .snapshots(),
//           //     builder: (context, snapshot) {
//           //       if (snapshot.connectionState ==
//           //           ConnectionState.waiting) {
//           //         return SizedBox.shrink();
//           //       } else if (snapshot.hasError) {
//           //         return SizedBox.shrink();
//           //       } else if (snapshot.data == null) {
//           //         return SizedBox.shrink();
//           //       } else {
//           //         dynamic bookData = snapshot.data!.data();
//           //         return StreamBuilder<DocumentSnapshot>(
//           //             stream: FirebaseFirestore.instance
//           //                 .collection('userDetails')
//           //                 .doc(chat['sellerId'] ==
//           //                         FirebaseAuth.instance.currentUser!.uid
//           //                     ? chat['buyerId']
//           //                     : chat['sellerId'])
//           //                 .snapshots(),
//           //             builder: (context, snapshot) {
//           //               if (snapshot.connectionState ==
//           //                   ConnectionState.waiting) {
//           //                 return SizedBox.shrink();
//           //               } else if (snapshot.hasError) {
//           //                 return SizedBox.shrink();
//           //               } else {
//           //                 dynamic userStatus = snapshot.data!.data();
//           //
//           //                 return StreamBuilder<QuerySnapshot>(
//           //                     stream: FirebaseFirestore.instance
//           //                         .collection('userMessages')
//           //                         .doc(chat['chatId'])
//           //                         .collection('messages')
//           //                         .orderBy('timeStamp',
//           //                             descending: true)
//           //                         .snapshots(),
//           //                     builder: (context, latestMsgSnapshot) {
//           //                       if (latestMsgSnapshot.connectionState ==
//           //                           ConnectionState.waiting) {
//           //                         return SizedBox.shrink();
//           //                       } else if (latestMsgSnapshot.hasError) {
//           //                         return SizedBox.shrink();
//           //                       } else {
//           //                         dynamic latestMessage =
//           //                             latestMsgSnapshot.data!.docs;
//           //                         String formattedTime = chatController
//           //                             .formatTimestamp(latestMessage[0]
//           //                                 ['timeStamp']);
//           //
//           //                         return ListTile(
//           //                           onTap: () {
//           //                             CustomRoute.navigateTo(
//           //                                 context,
//           //                                 ChatScreen(
//           //                                   image:
//           //                                       chat['bookImage'] ?? '',
//           //                                   chatName: chat['buyerId'] !=
//           //                                           FirebaseAuth
//           //                                               .instance
//           //                                               .currentUser!
//           //                                               .uid
//           //                                       ? chat['bookName']
//           //                                       : "You Bought ${chat['bookName']}",
//           //                                   chatId: chat['chatId'],
//           //                                   sellerId: chat[
//           //                                               'sellerId'] ==
//           //                                           FirebaseAuth
//           //                                               .instance
//           //                                               .currentUser!
//           //                                               .uid
//           //                                       ? chat['buyerId']
//           //                                       : chat['sellerId'],
//           //                                   buyerId: chat['buyerId'],
//           //                                   seller: chat['sellerId'],
//           //                                   bookId: chat['bookId'],
//           //                                   bookName: chat['bookName'],
//           //                                 ));
//           //                             //    CustomRoute.navigateTo(context, ChatScreen(receiverUserID: chat['sellerId']));
//           //                           },
//           //                           leading: Container(
//           //                             alignment: Alignment.bottomRight,
//           //                             height: 62.h,
//           //                             width: 62.w,
//           //                             decoration: BoxDecoration(
//           //                                 color: Colors.black26,
//           //                                 shape: BoxShape.circle,
//           //                                 image: DecorationImage(
//           //                                     image: NetworkImage(
//           //                                   chat['bookImage'] ?? '',
//           //                                 ))),
//           //                             child: Padding(
//           //                               padding:
//           //                                   const EdgeInsets.all(4.0),
//           //                               child: userStatus['online']
//           //                                   ? Image.asset(
//           //                                       AppImages.onlinedot,
//           //                                       height: 10.h,
//           //                                       width: 10.w,
//           //                                     )
//           //                                   : SizedBox.shrink(),
//           //                             ),
//           //                           ),
//           //                           title: Row(
//           //                             mainAxisAlignment:
//           //                                 MainAxisAlignment
//           //                                     .spaceBetween,
//           //                             children: [
//           //                               SizedBox(
//           //                                 width: 200.w,
//           //                                 child: LexendCustomText(
//           //                                   maxLines: 1,
//           //                                   overflow:
//           //                                       TextOverflow.ellipsis,
//           //                                   text: chat['sellerId'] !=
//           //                                           FirebaseAuth
//           //                                               .instance
//           //                                               .currentUser!
//           //                                               .uid
//           //                                       ? "YOU bought ${chat['bookName']}"
//           //                                       : chat['bookName'],
//           //                                   textColor: Colors.black,
//           //                                   fontWeight: FontWeight.w700,
//           //                                   fontsize: 16.sp,
//           //                                 ),
//           //                               ),
//           //                               LexendCustomText(
//           //                                 text: formattedTime,
//           //                                 textColor: Colors.black,
//           //                                 fontWeight: FontWeight.w400,
//           //                                 fontsize: 12.sp,
//           //                               ),
//           //                             ],
//           //                           ),
//           //                           subtitle: LexendCustomText(
//           //                             text: latestMessage[0]['message'],
//           //                             textColor: Colors.black,
//           //                             fontWeight: FontWeight.w400,
//           //                             fontsize: 12.sp,
//           //                           ),
//           //                         );
//           //                       }
//           //                     });
//           //               }
//           //             });
//           //       }
//           //     });
//         });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../const/assets/image_assets.dart';
import '../../../controller/chat_controller.dart';
import '../../../widgets/custom_route.dart';
import '../../../widgets/custom_text.dart';
import '../chat_screen.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('convo')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerCovo();
          } else if (snapshot.hasError) {
            return ShimmerCovo();
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Column(
              children: [
                SizedBox(
                  height: 180.h,
                ),
                Text(
                  "No Chats",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ));
          } else {
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final chat = snapshot.data!.docs[index];
                  return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('productsListing')
                          .doc(chat['productId'])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ShimmerCovo();
                        } else if (snapshot.hasError) {
                          return ShimmerCovo();
                        } else if (snapshot.data == null) {
                          return ShimmerCovo();
                        } else {
                          dynamic bookData = snapshot.data!.data();
                          return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('userDetails')
                                  .doc(chat['sellerId'] ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? chat['buyerId']
                                      : chat['sellerId'])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ShimmerCovo();
                                } else if (snapshot.hasError) {
                                  return ShimmerCovo();
                                } else {
                                  dynamic userStatus = snapshot.data!.data();

                                  return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('userMessages')
                                          .doc(chat['chatId'])
                                          .collection('messages')
                                          .orderBy('timeStamp',
                                              descending: true)
                                          .snapshots(),
                                      builder: (context, latestMsgSnapshot) {
                                        if (latestMsgSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ShimmerCovo();
                                        } else if (latestMsgSnapshot.hasError) {
                                          return ShimmerCovo();
                                        }
                                        else {
                                          dynamic latestMessage =
                                              latestMsgSnapshot.data!.docs;
                                          String formattedTime = chatController
                                              .formatTimestamp(latestMessage[0]
                                                  ['timeStamp']);

                                          return ListTile(
                                            onTap: () {
                                              CustomRoute.navigateTo(
                                                  context,
                                                  ChatScreen(
                                                    image:
                                                        chat['productImage'] ??
                                                            '',
                                                    chatName: chat['buyerId'] !=
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                        ? chat['productName']
                                                        : "You Bought ${chat['productName']}",
                                                    chatId: chat['chatId'],
                                                    sellerId: chat[
                                                                'sellerId'] ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                        ? chat['buyerId']
                                                        : chat['sellerId'],
                                                    buyerId: chat['buyerId'],
                                                    seller: chat['sellerId'],
                                                    productId:
                                                        chat['productId'],
                                                    productName:
                                                        chat['productName'],
                                                    productPrice:
                                                        chat['productPrice'],
                                                  ));
                                              //    CustomRoute.navigateTo(context, ChatScreen(receiverUserID: chat['sellerId']));
                                            },
                                            leading: Container(
                                              alignment: Alignment.bottomRight,
                                              height: 62.h,
                                              width: 62.w,
                                              decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                    chat['productImage'] ?? '',
                                                  ))),
                                              // child: Padding(
                                              //   padding:
                                              //   const EdgeInsets.all(4.0),
                                              //   child: userStatus['online']
                                              //       ? Image.asset(
                                              //     AppImages.onlinedot,
                                              //     height: 10.h,
                                              //     width: 10.w,
                                              //   )
                                              //       : const SizedBox.shrink(),
                                              // ),
                                            ),
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 200.w,
                                                  child: LexendCustomText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    text: chat['sellerId'] !=
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                        ? "You bought ${chat['productName']}"
                                                        : chat['productName'],
                                                    textColor: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontsize: 16.sp,
                                                  ),
                                                ),
                                                LexendCustomText(
                                                  text: formattedTime,
                                                  textColor: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontsize: 12.sp,
                                                ),
                                              ],
                                            ),
                                            subtitle: LexendCustomText(
                                              text: latestMessage[0]['message']?? '',
                                              textColor: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontsize: 12.sp,
                                            ),
                                          );
                                        }
                                      });
                                }
                              });
                        }
                      });
                });
          }
        });
  }
}

class ShimmerCovo extends StatelessWidget {
  const ShimmerCovo({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: ListTile(
        leading: Container(
          alignment: Alignment.bottomRight,
          height: 62.h,
          width: 62.w,
          decoration: BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 10.h,
              width: 200.w,
              color: Colors.white,
            ),
            LexendCustomText(
              text: '',
              textColor: Colors.black,
              fontWeight: FontWeight.w400,
              fontsize: 12.sp,
            ),
          ],
        ),
        subtitle: LexendCustomText(
          text: '',
          textColor: Colors.black,
          fontWeight: FontWeight.w400,
          fontsize: 12.sp,
        ),
      ),
    );
  }
}
