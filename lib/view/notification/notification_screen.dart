import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../const/assets/image_assets.dart';
import '../../const/assets/svg_assets.dart';
import '../../const/color.dart';
import '../../controller/home_controller.dart';
import '../../controller/notification_controller.dart';
import '../../controller/order_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';
import '../chat_screen/chat_screen.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenViewState();
}

class _NotificationScreenViewState extends State<NotificationScreen> {
  final NotificationController notificationController = Get.find();
  final HomeController homeController = Get.find<HomeController>();
  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,

        appBar: CustomAppBar2(
          homeController: homeController,
          text: 'Notifications',
        ),
        body: SingleChildScrollView(
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 57.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 23.5.w),
                child: SoraCustomText(
                  text: 'Latest',
                  textColor: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontsize: 14.sp,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('userNotifications')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('notifications')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ));
                    } else if (snapshot.hasError) {
                      return const Text("Snapshot Error");
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 180.h,
                              ),
                              Text(
                                "No Notifications",
                                style: TextStyle(
                                    fontSize: 15.sp, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ));
                    } else {
                      dynamic notification = snapshot.data!.docs;
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: notification.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            String time =
                            notificationController.formatNotificationTime(
                                notification[index]['time']);
                            String? price =
                            notification[index].data().containsKey('price')
                                ? "\$${notification[index]['price'].toString()}"
                                : '';
                            return ListTile(
                              contentPadding:
                              EdgeInsets.only(left: 23.5, right: 24.w),
                              horizontalTitleGap: 8,
                              onTap: () async {
                                if (notification[index]['notificationType'] == 'seller') {
                                  showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20.r)),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          width: double.infinity,
                                          // height: 241.h,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                              Container(
                                                width: 30.w,
                                                height: 4.h,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                    BorderRadius.circular(4.r)),
                                              ),
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                              Center(
                                                  child: WorkSansCustomText(
                                                    text:
                                                    'Seller has marked this sale as complete,\n     did you finish this transaction?”',
                                                    textColor: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontsize: 16.sp,
                                                  )),
                                              Spacer(),
                                              CustomButton(
                                                text: 'Yes',
                                                onPressed: () async {
                                                  // Fetch the current order document
                                                  DocumentSnapshot orderSnapshot =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('orders')
                                                      .doc(notification[index]
                                                  ['orderId'])
                                                      .get();
                                                  dynamic orderData =
                                                  orderSnapshot.data();

                                                  // Check if sellerApproval, buyerApproval, and deliveryStatus are all true
                                                  if (orderData['sellerApproval'] ==
                                                      true &&
                                                      orderData['buyerApproval'] ==
                                                          true &&
                                                      orderData['deliveryStatus'] ==
                                                          true) {
                                                    // Exit the function early if all are true
                                                    print('alldata');
                                                    Get.back();
                                                    return;
                                                  } else {
                                                    // First true statuses both
                                                    await FirebaseFirestore.instance
                                                        .collection('orders')
                                                        .doc(notification[index]
                                                    ['orderId'])
                                                        .update({
                                                      'buyerApproval': true,
                                                      'deliveryStatus': true,
                                                      'sellerApproval': true
                                                    });

                                                    // Store notification in seller id for successful purchase
                                                    DocumentSnapshot docref =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                        'userNotifications')
                                                        .doc(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid)
                                                        .collection(
                                                        'notifications')
                                                        .doc(notification[index]
                                                    ['notificationId'])
                                                        .get();
                                                    dynamic data = docref.data();
                                                    String sellerId =
                                                    data['userId'];
                                                    DocumentReference docRefs =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                        'userNotifications')
                                                        .doc(sellerId)
                                                        .collection(
                                                        'notifications')
                                                        .add({
                                                      'bookId': notification[index]
                                                      ['bookId'],
                                                      'orderId': notification[index]
                                                      ['orderId'],
                                                      // 'price':price,
                                                      'time': DateTime
                                                          .now(), // Corrected from DateTime.timestamp() to DateTime.now()
                                                      'title':
                                                      "Buyer has marked book order as delivered",
                                                      'userId': FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      'notificationType': 'buyer',
                                                    });
                                                    await FirebaseFirestore.instance
                                                        .collection(
                                                        'userNotifications')
                                                        .doc(sellerId)
                                                        .collection('notifications')
                                                        .doc(docRefs.id)
                                                        .update({
                                                      'notificationId': docRefs.id,
                                                    });

                                                    // Update the seller's wallet balance
                                                    DocumentSnapshot
                                                    walletSnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('wallet')
                                                        .doc(sellerId)
                                                        .get();
                                                    dynamic sellerWallet =
                                                    walletSnapshot.data();
                                                    int sellerNewBalance =
                                                        sellerWallet['balance'] +
                                                            orderData['finalPrice'];

                                                    await FirebaseFirestore.instance
                                                        .collection('wallet')
                                                        .doc(sellerId)
                                                        .update({
                                                      'balance': sellerNewBalance,
                                                    });
                                                  }

                                                  Get.back();
                                                },
                                                backgroundColor: primaryColor,
                                                textColor: whiteColor,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              CustomButton(
                                                text: 'No, I have not received.',
                                                onPressed: () async {
                                                  // Fetch the current order document
                                                  DocumentSnapshot orderSnapshot =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('orders')
                                                      .doc(notification[index]
                                                  ['orderId'])
                                                      .get();
                                                  dynamic orderData =
                                                  orderSnapshot.data();

                                                  // Check if sellerApproval, buyerApproval, and deliveryStatus are all false
                                                  if (orderData != null &&
                                                      orderData['sellerApproval'] ==
                                                          false &&
                                                      orderData['buyerApproval'] ==
                                                          false &&
                                                      orderData['deliveryStatus'] ==
                                                          false) {
                                                    // Exit the function early if all are false
                                                    print(
                                                        "All conditions false, function will not proceed.");
                                                    Get.back();

                                                    return;
                                                  }

                                                  // First false statuses both
                                                  await FirebaseFirestore.instance
                                                      .collection('orders')
                                                      .doc(notification[index]
                                                  ['orderId'])
                                                      .update({
                                                    'buyerApproval': false,
                                                    'deliveryStatus': false,
                                                    'sellerApproval': false,
                                                  });

                                                  // Store notification in seller id for unsuccessful purchase
                                                  DocumentSnapshot docref =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                      'userNotifications')
                                                      .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                      .collection(
                                                      'notifications')
                                                      .doc(notification[index]
                                                  ['notificationId'])
                                                      .get();
                                                  dynamic data = docref.data();
                                                  String sellerId = data['userId'];
                                                  DocumentReference docRefs =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                      'userNotifications')
                                                      .doc(sellerId)
                                                      .collection(
                                                      'notifications')
                                                      .add({
                                                    'bookId': notification[index]
                                                    ['bookId'],
                                                    'orderId': notification[index]
                                                    ['orderId'],
                                                    'time': DateTime.now(),
                                                    'title':
                                                    "Buyer has marked book order as not delivered",
                                                    'userId': FirebaseAuth
                                                        .instance.currentUser!.uid,
                                                    'notificationType': 'buyer',
                                                  });
                                                  await FirebaseFirestore.instance
                                                      .collection(
                                                      'userNotifications')
                                                      .doc(sellerId)
                                                      .collection('notifications')
                                                      .doc(docRefs.id)
                                                      .update({
                                                    'notificationId': docRefs.id,
                                                  });

                                                  // Update the seller's wallet balance
                                                  DocumentSnapshot walletSnapshot =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('wallet')
                                                      .doc(sellerId)
                                                      .get();
                                                  dynamic sellerWallet =
                                                  walletSnapshot.data();
                                                  int sellerNewBalance =
                                                      sellerWallet['balance'] -
                                                          orderData['finalPrice'];

                                                  await FirebaseFirestore.instance
                                                      .collection('wallet')
                                                      .doc(sellerId)
                                                      .update({
                                                    'balance': sellerNewBalance,
                                                  });

                                                  Get.back();
                                                },
                                                backgroundColor:
                                                primaryColor.withOpacity(0.2),
                                                textColor: whiteColor,
                                              ),
                                              SizedBox(
                                                height: 14.h,
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                } else if ((notification[index]
                                ['notificationType'] == 'purchased')) {String? bookId = notification[index]['bookId'];
                                  print("Book ID from notification: $bookId");

                                  // if (bookId != null) {
                                  //   try {
                                  //     // Fetch the chat details from Firestore
                                  //     QuerySnapshot bookChatDetails =
                                  //     await FirebaseFirestore.instance
                                  //         .collection('chats')
                                  //         .doc(FirebaseAuth
                                  //         .instance.currentUser!.uid)
                                  //         .collection('convo')
                                  //         .where('bookId', isEqualTo: bookId)
                                  //         .get();
                                  //
                                  //     print(
                                  //         "Query executed. Number of documents found: ${bookChatDetails.docs.length}");
                                  //
                                  //     if (bookChatDetails.docs.isNotEmpty) {
                                  //       var chatData = bookChatDetails.docs.first
                                  //           .data() as Map<String, dynamic>;
                                  //
                                  //       // Extract necessary details from the chatData with null checks
                                  //       String? image = chatData['bookImage'];
                                  //       String? bookName = chatData['bookName'];
                                  //       String? chatId = chatData['chatId'];
                                  //       String? sellerId = chatData['sellerId'];
                                  //       String? buyerId = chatData['buyerId'];
                                  //       String? seller = chatData['person'];
                                  //       String? chatName = chatData['sellerId'] ==
                                  //           FirebaseAuth
                                  //               .instance.currentUser!.uid
                                  //           ? chatData['bookName']
                                  //           : "You Bought ${chatData['bookName']}";
                                  //       if (image != null &&
                                  //           chatName != null &&
                                  //           chatId != null &&
                                  //           sellerId != null &&
                                  //           buyerId != null &&
                                  //           seller != null) {
                                  //         // Navigate to the ChatScreen
                                  //         Get.to(ChatScreen(
                                  //           image: image,
                                  //           chatName: chatName,
                                  //           chatId: chatId,
                                  //           sellerId: sellerId,
                                  //           buyerId: buyerId,
                                  //           seller: sellerId, productId: '', productName: '', productPrice: 0, brand: '',
                                  //
                                  //         ));
                                  //       } else {
                                  //         // Handle the case where some fields are missing
                                  //         print(
                                  //             "Some required chat details are missing.");
                                  //       }
                                  //     } else {
                                  //       // Handle the case where no chat details are found
                                  //       print(
                                  //           "No chat details found for the given bookId.");
                                  //     }
                                  //   } catch (e) {
                                  //     print("Error fetching chat details: $e");
                                  //   }
                                  // } else {
                                  //   // Handle the case where bookId is null
                                  //   print("Book ID is null.");
                                  // }
                                } else {
                                  print('no seller notification');
                                }
                              },
                              leading: Image.asset(
                                AppImages.notification,
                                height: 32.h,
                                width: 32.w,
                              ),
                              title: LexendCustomText(
                                text: notification[index]['title'].toString(),
                                textColor: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontsize: 12.sp,
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  LexendCustomText(
                                    text: time,
                                    textColor: const Color(0xff78838D),
                                    fontWeight: FontWeight.w400,
                                    fontsize: 12.sp,
                                  ),
                                  const Spacer(),
                                  LexendCustomText(
                                    text: price,
                                    textColor: const Color(0xffD85454),
                                    fontWeight: FontWeight.w400,
                                    fontsize: 12.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  notification[index]['notificationType'] !=
                                      'bookApproval'
                                      ? SvgPicture.asset(AppIcons.arrowIcon)
                                      : SizedBox.shrink()
                                ],
                              ),
                            );
                          });
                    }
                  }),
              SizedBox(
                height: 20.h,
              )
            ])));
  }
}

