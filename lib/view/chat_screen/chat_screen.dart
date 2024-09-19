//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
//
// import '../../const/assets/image_assets.dart';
// import '../../const/color.dart';
// import '../../controller/chat_controller.dart';
// import '../../controller/order_controller.dart';
// import '../../widgets/custom _backbutton.dart';
// import '../../widgets/custom_text.dart';
// import 'components/action_button_row.dart';
// import 'components/chat_message_container.dart';
// import 'components/offer_dailog.dart';
//
// class ChatScreen extends StatefulWidget {
//   final dynamic messagedetail;
//   final String image;
//   final String chatName;
//   final String chatId;
//   final String sellerId;
//   final String buyerId;
//   final String seller;
//   final String bookId;
//   final String bookName;
//
//   const ChatScreen({
//     super.key,
//     required this.messagedetail,
//     required this.image,
//     required this.chatName,
//     required this.chatId,
//     required this.sellerId,
//     required this.buyerId,
//     required this.seller,
//     required this.bookId,
//     required this.bookName
//   });
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final ChatController chatController = Get.find<ChatController>();
//   final OrderController orderController = Get.find<OrderController>();
//   @override
//   void initState() {
//     // TODO: implement initState
//     // Chat id is our order Id
//     // orderController.checkOrderStatus(widget.chatId);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//           body: Column(children: [
//         Container(
//             //height: 160.h,
//             // padding: EdgeInsets.symmetric(vertical: 50.h),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(25.r),
//                     bottomLeft: Radius.circular(25.r)),
//                 color: primaryColor,
//                 image: DecorationImage(
//                     image: AssetImage(AppImages.appbardesign),
//                     fit: BoxFit.cover)),
//             child: SafeArea(
//                 child: Column(children: [
//               SizedBox(
//                 height: 10.h,
//               ),
//               Row(children: [
//                 SizedBox(
//                   width: 10.w,
//                 ),
//                 const CustomBackButtonMessage(),
//                 SizedBox(
//                   width: 13.w,
//                 ),
//                 Container(
//                   height: 53.h,
//                   width: 53.w,
//                   decoration: BoxDecoration(
//                       color: Colors.grey,
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                           image: AssetImage(AppImages.image1),
//                           fit: BoxFit.fill)),
//                 ),
//                 SizedBox(
//                   width: 8.w,
//                 ),
//                 SizedBox(
//                   width: 240.w,
//                   child: InterCustomText(
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     text: 'Adidas Japan Sneakers',
//                     textColor: Colors.white,
//                     fontsize: 20.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ]),
//               SizedBox(
//                 height: 10.h,
//               ),
//               Container(
//                 padding: EdgeInsets.only(right: 10),
//                 width: 331.w,
//                 decoration: BoxDecoration(
//                     color: Color(0xffF7EDEC),
//                     borderRadius: BorderRadius.circular(16.r)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                         // width: 89.w,
//                         height: 75.h,
//                         child: Image.asset(AppImages.image2)),
//                     SizedBox(
//                       width: 6.w,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         InterCustomText(
//                           text: 'Mango',
//                           textColor: Color(0xff9B9B9B),
//                           fontWeight: FontWeight.w400,
//                           fontsize: 11.sp,
//                         ),
//                         InterCustomText(
//                           text: 'T-Shirt SPANISH',
//                           textColor: Color(0xff222222),
//                           fontWeight: FontWeight.w600,
//                           fontsize: 16.sp,
//                         ),
//                         InterCustomText(
//                           text: '20 Aed',
//                           textColor: Color(0xff222222),
//                           fontWeight: FontWeight.w500,
//                           fontsize: 14.sp,
//                         ),
//                       ],
//                     ),
//                     Spacer(),
//                     Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
//                       width: 55.w,
//                       // height: 49.h,
//                       decoration: BoxDecoration(
//                           color: primaryColor,
//                           borderRadius: BorderRadius.circular(11.r)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           InterCustomText(
//                             text: 'Offer',
//                             textColor: Colors.white,
//                             fontWeight: FontWeight.w400,
//                             fontsize: 11.sp,
//                           ),
//                           FittedBox(
//                             child: InterCustomText(
//                               text: '20 Aed',
//                               textColor: Colors.white,
//                               fontWeight: FontWeight.w500,
//                               fontsize: 13.sp,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10.h,
//               ),
//             ]))),
//         Expanded(
//             child: Stack(
//           children: [
//             Obx(() => ListView.builder(
//                   shrinkWrap: true,
//                   padding: EdgeInsets.only(bottom: 80.h),
//                   itemCount: chatController.messages.length,
//                   itemBuilder: (context, index) {
//                     var message = chatController.messages[index];
//                     return ChatMessageContainer(
//                       role: message['sendby'] == 'me'
//                           ? 'me'
//                           : 'other', // Dynamic role assignment
//                       messageText: message['message'], // Message text
//                       shouldShowTime: true, // Optionally manage this
//                       formattedTime:
//                           '1 Feb 12:00', // Placeholder for time formatting
//                     );
//                   },
//                 )),
//             Positioned(
//               bottom: 10.h,
//               left: 0,
//               right: 0,
//               child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 70.0.w),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) {
//                           int currentOffer =
//                               19; // Example starting value for the offer
//                           return StatefulBuilder(
//                             builder: (context, setState) {
//                               return OfferDialog(
//                                 currentOffer: currentOffer,
//                                 onOfferChanged: (newOffer) {
//                                   setState(() {
//                                     currentOffer = newOffer;
//                                   });
//                                 },
//                               );
//                             },
//                           );
//                         },
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       maximumSize: Size(220.w, 80.h),
//                       minimumSize: Size(120.w, 52.h),
//                       backgroundColor: primaryColor,
//                       alignment: Alignment.center,
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 10.w, vertical: 10.h),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20.r),
//                       ),
//                     ),
//                     child: Obx(() {
//                       return orderController.isLoading.value == false
//                           ? LexendCustomText(
//                               text: "Make a new Offer",
//                               textColor: Colors.white,
//                               fontWeight: FontWeight.w400,
//                             )
//                           : CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 3,
//                             );
//                     }),
//                   )),
//             ),
//
//           ],
//         )),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Color(0xff29604E).withOpacity(0.10),
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.circular(29.5.r),
//               ),
//               width: 293.w,
//               height: 52.h,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 4.w,
//                   ),
//                   Expanded(
//                     child: TextField(
//                       controller: chatController.messageController,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             EdgeInsets.only(left: 10.w, bottom: 5.h),
//                         hintText: 'Type your message',
//                         hintStyle: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: 8.w,
//             ),
//             GestureDetector(
//               onTap: () {
//                 // Add a static message to the messages list
//                 chatController.messages.add({
//                   "sendby": 'me', // Static sender value
//                   "message": chatController.messageController.text.isEmpty
//                       ? ''
//                       : chatController.messageController
//                           .text, // If messageController is empty, send static message
//                 });
//
//                 // Clear the message input field after sending
//                 chatController.messageController.clear();
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: primaryColor,
//                 ),
//                 height: 53.h,
//                 width: 53.w,
//                 child: Center(
//                   child: Icon(
//                     Icons.send,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//         SizedBox(
//           height: 19.h,
//         ),
//       ])),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../const/assets/image_assets.dart';
import '../../const/color.dart';
import '../../controller/chat_controller.dart';
import '../../controller/order_controller.dart';
import '../../widgets/custom _backbutton.dart';
import '../../widgets/custom_text.dart';
import 'components/chat_message_container.dart';
import 'components/offer_dailog.dart';

class ChatScreen extends StatefulWidget {
  // final dynamic messagedetail;
  final String image;
  final String chatName;
  final String chatId;
  final String sellerId;
  final String buyerId;
  final String seller;
  final String productId;
  final String productName;
  final int productPrice;

  const ChatScreen(
      {super.key,
      // required this.messagedetail,
      required this.image,
      required this.chatName,
      required this.chatId,
      required this.sellerId,
      required this.buyerId,
      required this.seller,
      required this.productId,
      required this.productName,
      required this.productPrice});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController chatController = Get.find<ChatController>();
  final TextEditingController messageController = TextEditingController();
  final OrderController orderController = Get.find<OrderController>();
  late Stream<DocumentSnapshot> orderStream;
  late Stream<DocumentSnapshot> productsstream;
  @override
  void initState() {
    // TODO: implement initState
    // Chat id is our order Id
    orderStream = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.chatId)
        .snapshots();
    productsstream = FirebaseFirestore.instance
        .collection('productsListing')
        .doc(widget.productId)
        .snapshots();
    orderController.checkOrderStatus(widget.chatId);
    super.initState();
  }

  // void showYesNoDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: const Color(0xffFEFEFE),
  //         title: const Text("Confirmation"),
  //         content: Text(widget.seller == FirebaseAuth.instance.currentUser!.uid
  //             ? "Are you sure you delivered the book? Only mark the book as delivered if the buyer agrees. This will avoid disputes."
  //             : "Are you sure you received the book? Once you mark the book received, we will pay the seller. This cannot be undone."),
  //         actions: <Widget>[
  //           Container(
  //             width: 80.w,
  //             height: 40.h,
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10.r),
  //                 color: primaryColor),
  //             child: Center(
  //               child: TextButton(
  //                 child: const Text(
  //                   "No",
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context)
  //                       .pop(false); // Return false when No is pressed
  //                 },
  //               ),
  //             ),
  //           ),
  //           Container(
  //             width: 80.w,
  //             height: 40.h,
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10.r),
  //                 color: primaryColor),
  //             child: TextButton(
  //               child: const Text(
  //                 "Yes",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //               onPressed: () {
  //                 Get.back(); // Return true when Yes is pressed
  //                 orderController.orderStatus.value == false
  //                     ? orderController.changeOrderStatus(widget.chatId)
  //                     : null; //
  //               },
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   ).then((value) {
  //     if (value != null && value) {
  //       // Perform action if Yes is pressed
  //       print("Yes pressed");
  //     } else {
  //       // Perform action if No is pressed
  //       print("No pressed");
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        body: Column(children: [
          Container(
              //height: 160.h,
              // padding: EdgeInsets.symmetric(vertical: 50.h),
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
                            image: NetworkImage(widget.image),
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
                      text: widget.chatName,
                      textColor: Colors.white,
                      fontsize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  width: 331.w,
                  decoration: BoxDecoration(
                      color: Color(0xffF7EDEC),
                      borderRadius: BorderRadius.circular(16.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 89.w,
                          height: 75.h,
                          child: Image.network(
                            widget.image,
                            fit: BoxFit.cover,
                          )),
                      SizedBox(
                        width: 6.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InterCustomText(
                            text: 'Mango',
                            textColor: Color(0xff9B9B9B),
                            fontWeight: FontWeight.w400,
                            fontsize: 11.sp,
                          ),
                          InterCustomText(
                            text: widget.productName,
                            textColor: Color(0xff222222),
                            fontWeight: FontWeight.w600,
                            fontsize: 16.sp,
                          ),
                          InterCustomText(
                            text: '${widget.productPrice.toString()} Aed',
                            textColor: Color(0xff222222),
                            fontWeight: FontWeight.w500,
                            fontsize: 14.sp,
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 10.h),
                        width: 55.w,
                        // height: 49.h,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(11.r)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InterCustomText(
                              text: 'Offer',
                              textColor: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontsize: 11.sp,
                            ),
                            FittedBox(
                              child: InterCustomText(
                                text: '20 Aed',
                                textColor: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontsize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ]))),
          Expanded(
              child: Stack(
            children: [
              ChatMessageContainer(
                chatId: widget.chatId,
                image: widget.image,
              ),
              Positioned(
                bottom: 10.h,
                left: 0,
                right: 0,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70.0.w),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            int currentOffer =
                                19; // Example starting value for the offer
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return OfferDialog(
                                  currentOffer: currentOffer,
                                  onOfferChanged: (newOffer) {
                                    setState(() {
                                      currentOffer = newOffer;
                                    });
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        maximumSize: Size(220.w, 80.h),
                        minimumSize: Size(120.w, 52.h),
                        backgroundColor: primaryColor,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Obx(() {
                        return orderController.isLoading.value == false
                            ? LexendCustomText(
                                text: "Make a new Offer",
                                textColor: Colors.white,
                                fontWeight: FontWeight.w400,
                              )
                            : CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              );
                      }),
                    )),
              ),
            ],
          )),
          // Expanded(
          //     child: Stack(
          //   children: [
          //     ChatMessageContainer(
          //       image: widget.image,
          //       chatId: widget.chatId,
          //     ),
          //     StreamBuilder<DocumentSnapshot>(
          //         stream: productsstream,
          //         builder: (context, booksnapshot) {
          //           if (booksnapshot.connectionState ==
          //               ConnectionState.waiting) {
          //             return SizedBox.shrink();
          //           } else if (booksnapshot.data!.exists) {
          //             return StreamBuilder<DocumentSnapshot>(
          //                 stream: orderStream,
          //                 builder: (context, ordersnapshot) {
          //                   if (booksnapshot.connectionState ==
          //                       ConnectionState.waiting) {
          //                     return SizedBox.shrink();
          //                   } else if (ordersnapshot.hasError ||
          //                       !ordersnapshot.hasData) {
          //                     return SizedBox.shrink();
          //                   } else if (!ordersnapshot.data!.exists) {
          //                     return SizedBox.shrink();
          //                   }
          //                   dynamic order = ordersnapshot.data!.data();
          //                   orderController.orderStatus.value =
          //                       order['deliveryStatus'];
          //                   orderController.sellerApproval.value =
          //                       order['sellerApproval'];
          //                   orderController.buyerApproval.value =
          //                       order['buyerApproval'];
          //                   return Positioned(
          //                     bottom: 10.h,
          //                     left: 0,
          //                     right: 0,
          //                     child: Padding(
          //                       padding:
          //                           EdgeInsets.symmetric(horizontal: 18.0.w),
          //                       child: ElevatedButton(
          //                           onPressed: () {
          //                             if (widget.seller ==
          //                                 FirebaseAuth
          //                                     .instance.currentUser!.uid) {
          //                               if (orderController.orderStatus.value !=
          //                                   true) {
          //                                 if (orderController
          //                                         .sellerApproval.value !=
          //                                     true) {
          //                                   // showYesNoDialog(context);
          //                                 }
          //                               }
          //                             } else {
          //                               if (orderController.orderStatus.value !=
          //                                   true) {
          //                                 if (orderController
          //                                         .buyerApproval.value !=
          //                                     true) {
          //                                   // showYesNoDialog(context);
          //                                 }
          //                               }
          //                             }
          //                             // orderController.orderStatus.value == false
          //                             //     ? orderController.changeOrderStatus(
          //                             //         widget.chatId,
          //                             //         widget.buyerId,
          //                             //         widget.bookId,
          //                             //         widget.bookName,
          //                             //         widget.seller)
          //                             //     : null;
          //                           },
          //                           style: ElevatedButton.styleFrom(
          //                             maximumSize: Size(350.w, 80.h),
          //                             minimumSize: Size(327.w, 58.h),
          //                             backgroundColor: primaryColor,
          //                             alignment: Alignment.center,
          //                             padding: EdgeInsets.symmetric(
          //                                 horizontal: 10.w, vertical: 10.h),
          //                             shape: RoundedRectangleBorder(
          //                               borderRadius:
          //                                   BorderRadius.circular(20.r),
          //                             ),
          //                           ),
          //                           child: Obx(() {
          //                             return orderController.isLoading.value ==
          //                                     false
          //                                 ? LexendCustomText(
          //                                     text: orderController
          //                                                 .orderStatus.value ==
          //                                             true
          //                                         ? "Order Completed"
          //                                         : widget.seller ==
          //                                                 FirebaseAuth.instance
          //                                                     .currentUser!.uid
          //                                             ? orderController
          //                                                         .sellerApproval
          //                                                         .value ==
          //                                                     true
          //                                                 ? 'Waiting for buyer to approve'
          //                                                 : 'Click here to mark order delivered'
          //                                             : orderController
          //                                                         .buyerApproval
          //                                                         .value ==
          //                                                     true
          //                                                 ? 'Waiting for seller to approve'
          //                                                 : 'Click here to mark order received',
          //                                     textColor: Colors.white,
          //                                     fontWeight: FontWeight.w400,
          //                                   )
          //                                 : const CircularProgressIndicator(
          //                                     color: Colors.white,
          //                                     strokeWidth: 3,
          //                                   );
          //                           })),
          //                     ),
          //                   );
          //                 });
          //           } else {
          //             return SizedBox.shrink();
          //           }
          //         }),
          //   ],
          // )),
          // StreamBuilder<DocumentSnapshot>(
          //     stream: productsstream,
          //     builder: (context, booksnapshot) {
          //       if (booksnapshot.connectionState == ConnectionState.waiting) {
          //         return SizedBox.shrink();
          //       } else if (booksnapshot.data!.exists) {
          //         return StreamBuilder<DocumentSnapshot>(
          //             stream: orderStream,
          //             builder: (context, ordersnapshot) {
          //               if (booksnapshot.connectionState ==
          //                   ConnectionState.waiting) {
          //                 return SizedBox.shrink();
          //               } else if (ordersnapshot.hasError ||
          //                   !ordersnapshot.hasData) {
          //                 return SizedBox.shrink();
          //               } else if (!ordersnapshot.data!.exists) {
          //                 return SizedBox.shrink();
          //               } else {
          //                 dynamic orderdata = ordersnapshot.data!.data();
          //                 if (orderdata['deliveryStatus'] == false) {
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
                  onTap: () {
                    chatController.sendmessage(
                        messageController, widget.chatId, widget.sellerId);
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

          // else {
          //   return Container(
          //       height: 30.h,
          //       width: 310.w,
          //       decoration: BoxDecoration(
          //           color: primaryColor,
          //           borderRadius: BorderRadius.circular(12.r)),
          //       child: Center(
          //           child: LexendCustomText(
          //         text: 'You can\'t send messages to this group',
          //         textColor: whiteColor,
          //         fontWeight: FontWeight.w400,
          //       )));
          // }

          SizedBox(
            height: 19.h,
          ),
        ]));
  }
}
