import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reclaim_firebase_app/helper/loading.dart';
import '../../const/color.dart';
import '../../controller/chat_controller.dart';
import '../../controller/order_controller.dart';
import '../../controller/paymentController.dart';
import '../../helper/paypal_payment.dart';
import '../../helper/stripe_purchasing.dart';
import '../../widgets/custom _backbutton.dart';
import '../../widgets/custom_text.dart';
import 'components/action_button_row.dart';
import 'components/chat_message_container.dart';
import 'components/offer_dailog.dart';

class ChatScreen extends StatefulWidget {
  final String image;
  final String chatName;
  final String chatId;
  final String sellerId;
  final String buyerId;
  final String seller;
  final String productId;
  final String productName;
  final String brand;
  final int productPrice;

  const ChatScreen({
    super.key,
    required this.image,
    required this.chatName,
    required this.chatId,
    required this.sellerId,
    required this.buyerId,
    required this.seller,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.brand,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController chatController = Get.find<ChatController>();
  final TextEditingController messageController = TextEditingController();
  final OrderController orderController = Get.find<OrderController>();
  late Stream<DocumentSnapshot> orderStream;
  late Stream<DocumentSnapshot> productsstream;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool seller = false;

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

  Future<void> orderStatusBySeller(
    dynamic order,
  ) async {
    try {
      if (order['sellerApproval'] == false) {
        orderController.isLoading.value = true;

        // mark delivery by seller has true
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(order['orderId'])
            .update({
          'sellerApproval': true,
        });

        // then store the notification to buyer that seller has marked delivered
        DocumentReference notiId = await FirebaseFirestore.instance
            .collection('userNotifications')
            .doc(order['buyerId'])
            .collection('notifications')
            .add({
          'productId': widget.productId,
          'orderId': order['orderId'],
          // 'price':price,
          'time': DateTime.timestamp(),
          'title': "Seller has marked ${widget.productName} as delivered",
          'userId': order['sellerId'],
          'notificationType': 'seller'
        });
        await FirebaseFirestore.instance
            .collection('userNotifications')
            .doc(order['buyerId'])
            .collection('notifications')
            .doc(notiId.id)
            .set({'notificationId': notiId.id}, SetOptions(merge: true));

        order['sellerApproval'] = true;
        await markDeliveryTrue(order);
      }
    } catch (e) {
      print("error changing order status by seller $e");
    } finally {
      orderController.isLoading.value = false;
    }
  }

  Future<String?> uploadImageToFirebase(XFile image) async {
    try {
      // Create a reference to Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child(
          'chatImages/${DateTime.now().millisecondsSinceEpoch}_${image.name}');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(File(image.path));

      // Wait until the file is uploaded
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> orderStatusByBuyer(
    dynamic order,
  ) async {
    try {
      if (order['buyerApproval'] == false) {
        orderController.isLoading.value = true;

        // mark delivery by buyer has true
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(order['orderId'])
            .update({
          'buyerApproval': true,
        });

        // then store the notification to seller that buyer has marked recieved
        DocumentReference notiId = await FirebaseFirestore.instance
            .collection('userNotifications')
            .doc(order['sellerId'])
            .collection('notifications')
            .add({
          'productId': widget.productId,
          'orderId': order['orderId'],
          // 'price':price,
          'time': DateTime.timestamp(),
          'title': "Buyer has marked ${widget.productName} as delivered",
          'userId': order['buyerId'],
          'notificationType': 'buyer'
        });

        await FirebaseFirestore.instance
            .collection('userNotifications')
            .doc(order['sellerId'])
            .collection('notifications')
            .doc(notiId.id)
            .set({'notificationId': notiId.id}, SetOptions(merge: true));

        order['buyerApproval'] = true;
        await markDeliveryTrue(order);
      }
    } catch (e) {
      print("error changing order status by buyer $e");
    } finally {
      orderController.isLoading.value = false;
    }
  }

  Future<void> markDeliveryTrue(dynamic order) async {
    // check that the status by seller and buyer are true then mark order as complete
    if (order['sellerApproval'] == true && order['buyerApproval'] == true) {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order['orderId'])
          .update({
        'deliveryStatus': true,
      });
      int appFees = (order['buyingprice'] * 0.05).round();
      int finalPrice = order['buyingprice'] - appFees;
      await walletController.sendBalanceToSeller(finalPrice, order['sellerId']);
      // String userId =
      //     'RnGCPonCj5VSwgoJxxoxtpOIm8I2'; // Replace with your actual admin user ID
      // DocumentSnapshot adminWalletSnapshot = await FirebaseFirestore.instance
      //     .collection('adminWallet')
      //     .doc(userId)
      //     .get();
      // dynamic adminWallet = adminWalletSnapshot.data();
      // int adminBalance = adminWallet['balance'] + appFees;
      // await FirebaseFirestore.instance
      //     .collection('adminWallet')
      //     .doc(userId)
      //     .update({'balance': adminBalance});
      print("order  completed ");
    } else {
      print("order not complete yet");
    }
  }

  final StripePaymentPurchasing stripePaymentPurchasing =
      StripePaymentPurchasing();

  @override
  Widget build(BuildContext context) {
    print(userController.userPurchases);
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
                if (widget.seller != FirebaseAuth.instance.currentUser!.uid)
                  Obx(
                    () => !userController.userPurchases
                            .contains(widget.productId)
                        ? Container(
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
                                      text: widget.brand,
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
                                      text:
                                          '${widget.productPrice.toString()} Aed',
                                      textColor: Color(0xff222222),
                                      fontWeight: FontWeight.w500,
                                      fontsize: 14.sp,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                StreamBuilder<DocumentSnapshot>(
                                  stream: orderStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      var orderData = snapshot.data!.data()
                                          as Map<String, dynamic>?;
                                      var offerPrice = orderData?['offers']
                                              ?['offerPrice'] ??
                                          0;

                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 10.h),
                                        width: 55.w,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(11.r),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InterCustomText(
                                              text: 'Offer',
                                              textColor: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontsize: 11.sp,
                                            ),
                                            FittedBox(
                                              child: InterCustomText(
                                                text: offerPrice.toString(),
                                                // Convert offerPrice to String
                                                textColor: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontsize: 13.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return SizedBox(); // Add a fallback widget for when there's no data
                                    }
                                  },
                                )
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
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
              StreamBuilder<DocumentSnapshot>(
                stream: orderStream,
                builder: (context, ordersnapshot) {
                  if (!ordersnapshot.hasData) {
                    return Center(
                        child:
                            CircularProgressIndicator()); // Handle loading state
                  }
                  dynamic order = ordersnapshot.data!.data();
                  bool isAccepted =
                      order?['offers']?['isAccepted'] == 'accepted';
                  bool isOrdered = order?['isOrdered'] ?? false;

                  return isOrdered == false
                      ? Stack(
                          children: [
                            if (widget.seller !=
                                FirebaseAuth.instance.currentUser!.uid)
                              order['isReturning'] == true
                                  ? SizedBox()
                                  : Positioned(
                                      bottom: 10.h,
                                      left: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 70.0.w),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              isAccepted
                                                  ? null
                                                  : showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        int currentOffer = widget
                                                            .productPrice; // Example starting value for the offer
                                                        return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                            return OfferDialog(
                                                              orderId:
                                                                  widget.chatId,
                                                              currentOffer:
                                                                  currentOffer,
                                                              onOfferChanged:
                                                                  (newOffer) {
                                                                setState(() {
                                                                  currentOffer =
                                                                      newOffer;
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
                                                  horizontal: 10.w,
                                                  vertical: 10.h),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                              ),
                                            ),
                                            child: isAccepted
                                                ? GestureDetector(
                                                    onTap: () {
                                                      if (productsListingController
                                                              .isLoading
                                                              .value ==
                                                          false) {
                                                        showModalBottomSheet(
                                                          // isScrollControlled: true,
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.r),
                                                          ),
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return GetBuilder<
                                                                PaymentController>(
                                                              init:
                                                                  PaymentController(),
                                                              // Initialize the controller
                                                              builder:
                                                                  (controller) {
                                                                return Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              20.w),
                                                                  width: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      SizedBox(
                                                                          height:
                                                                              20.h),
                                                                      Container(
                                                                        width:
                                                                            30.w,
                                                                        height:
                                                                            4.h,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.black,
                                                                          borderRadius:
                                                                              BorderRadius.circular(4.r),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              10.h),
                                                                      MontserratCustomText(
                                                                        text:
                                                                            'Payment Methods',
                                                                        textColor:
                                                                            Colors.black,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        fontsize:
                                                                            16.sp,
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              50.h),

                                                                      // Payment method ListView.builder inside the BottomSheet
                                                                      ListView
                                                                          .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: controller
                                                                            .payments
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return Container(
                                                                            margin:
                                                                                EdgeInsets.symmetric(
                                                                              vertical: 4.h,
                                                                              horizontal: 12.w,
                                                                            ),
                                                                            padding:
                                                                                EdgeInsets.all(4),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: controller.selectedPayment == controller.payments[index]['name'] ? primaryColor : primaryColor.withOpacity(0.1),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              border: Border.all(
                                                                                color: controller.selectedPayment == controller.payments[index]['name'] ? Colors.transparent : primaryColor,
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                RadioListTile<String>(
                                                                              value: controller.payments[index]['name']!,
                                                                              groupValue: controller.selectedPayment,
                                                                              onChanged: (String? value) {
                                                                                controller.selectPayment(value!);
                                                                              },
                                                                              title: Text(
                                                                                controller.payments[index]['name']!,
                                                                                style: TextStyle(
                                                                                  color: controller.selectedPayment == controller.payments[index]['name'] ? Colors.white : Colors.black,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                              activeColor: Colors.white,
                                                                              controlAffinity: ListTileControlAffinity.trailing,
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),

                                                                      Spacer(),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          Navigator.pop(
                                                                              context);
                                                                          // Navigate based on the selected payment method
                                                                          if (controller.selectedPayment ==
                                                                              controller.payments[0][
                                                                                  'name']) {
                                                                            await stripePaymentPurchasing.paymentPurchasing(
                                                                                widget.productPrice.toString(),
                                                                                widget.productId,
                                                                                widget.seller,
                                                                                widget.brand,
                                                                                context,
                                                                                widget.productName,
                                                                                widget.productPrice,
                                                                                widget.image,
                                                                                false,
                                                                                order,0.0,'');
                                                                            // Get.back();
                                                                          } else if (controller.selectedPayment ==
                                                                              controller.payments[1][
                                                                                  'name']) {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => PaypalPayment(
                                                                                        amount: widget.productPrice.toString(),
                                                                                      )),
                                                                            );
                                                                          } else if (controller.selectedPayment ==
                                                                              controller.payments[2]['name']) {
                                                                            await productsListingController.buyProductWithWalletChat(
                                                                                widget.productId,
                                                                                widget.seller,
                                                                                widget.brand,
                                                                                context,
                                                                                widget.productName,
                                                                                widget.productPrice,
                                                                                widget.image);
                                                                            // Navigate to PayPal screen
                                                                            // Navigator.push(
                                                                            //   context,
                                                                            //   MaterialPageRoute(builder: (context) => PayPalScreen()),
                                                                            // );
                                                                          } else {
                                                                            // Handle other payment methods if necessary
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 10),
                                                                          height:
                                                                              58.h,
                                                                          width:
                                                                              300.w,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                primaryColor,
                                                                            borderRadius:
                                                                                BorderRadius.circular(20.r),
                                                                          ),
                                                                          child:
                                                                              MontserratCustomText(
                                                                            text:
                                                                                'Continue',
                                                                            textColor:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontsize:
                                                                                16.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              30.h),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                        // productsListingController
                                                        //     .buyProduct1(
                                                        //         widget.productId,
                                                        //         widget.seller,
                                                        //         widget.brand,
                                                        //         context,
                                                        //         widget.productName,
                                                        //         order['offers']
                                                        //             ['offerPrice'],
                                                        //         widget.image,
                                                        //         order['orderId']);
                                                      }
                                                    },
                                                    child: LexendCustomText(
                                                      text:
                                                          'Offer Accepted ${order['offers']['offerPrice'].toString()} Aed\n        Purchase Now',
                                                      textColor: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                : LexendCustomText(
                                                    text: "Make a new Offer",
                                                    textColor: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                      ),
                                    ),
                            if (widget.seller ==
                                FirebaseAuth.instance.currentUser!.uid)
                              order['isReturning'] == true
                                  ? SizedBox()
                                  : Positioned(
                                      bottom: 10.h,
                                      left: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40.0.w),
                                        child: isAccepted
                                            ? Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                                width: 60,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.r),
                                                  color: primaryColor,
                                                ),
                                                child: Center(
                                                  child: LexendCustomText(
                                                    text: "Offer accepted",
                                                    textColor: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ))
                                            : ActionButtonsRow(
                                                onAccept: () async {
                                                  try {
                                                    productsListingController
                                                        .isLoading.value = true;
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('orders')
                                                        .doc(widget
                                                            .chatId) // Use the chatId to locate the specific order
                                                        .update({
                                                      'offers.isAccepted':
                                                          'accepted',
                                                      // Update the offer's status to 'accepted'
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Offer accepted')),
                                                    );
                                                    productsListingController
                                                        .isLoading
                                                        .value = false;
                                                  } catch (error) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Error accepting offer: $error')),
                                                    );
                                                    productsListingController
                                                        .isLoading
                                                        .value = false;
                                                  }
                                                },
                                                onDecline: () async {
                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('orders')
                                                        .doc(widget
                                                            .chatId) // Use the chatId to locate the specific order
                                                        .update({
                                                      'offers.isAccepted':
                                                          'rejected',
                                                      // Update the offer's status to 'rejected'
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Offer declined')),
                                                    );
                                                  } catch (error) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Error declining offer: $error')),
                                                    );
                                                  }
                                                },
                                                amount: order != null &&
                                                        order['offers'] != null
                                                    ? order['offers']
                                                            ['offerPrice']
                                                        .toString()
                                                    : "0",
                                                currency: 'Aed',
                                              ),
                                      ),
                                    )
                          ],
                        )
                      : Positioned(
                          bottom: 10.h,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (order['refund'] == false) {
                                    if (widget.seller ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
                                      if (orderController.isLoading.value ==
                                          false) {
                                        await orderStatusBySeller(order);
                                      }
                                    } else {
                                      if (orderController.isLoading.value ==
                                          false) {
                                        await orderStatusByBuyer(order);
                                      }
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  maximumSize: Size(350.w, 80.h),
                                  minimumSize: Size(327.w, 58.h),
                                  backgroundColor: primaryColor,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                                child: Obx(() {
                                  return orderController.isLoading.value ==
                                          false
                                      ? order['refund'] == false
                                          ? LexendCustomText(
                                              text: order['deliveryStatus'] ==
                                                      true
                                                  ? "Order Completed"
                                                  : widget.seller ==
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                      ? order['sellerApproval'] ==
                                                              true
                                                          ? 'Waiting for buyer to approve'
                                                          : 'Click here to mark order delivered'
                                                      : order['buyerApproval'] ==
                                                              true
                                                          ? 'Waiting for seller to approve'
                                                          : 'Click here to mark order received',
                                              textColor: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            )
                                          : LexendCustomText(
                                              text: "Refunded",
                                              textColor: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            )
                                      : const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        );
                                })),
                          ),
                        );
                },
              ),
            ],
          )),
          StreamBuilder<DocumentSnapshot>(
              stream: orderStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink();
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return SizedBox.shrink();
                } else if (!snapshot.data!.exists) {
                  return SizedBox.shrink();
                } else {
                  dynamic orderdata = snapshot.data!.data();
                  // if (orderdata['deliveryStatus'] == true || orderdata['refund'] == false) {
                  //   return Row(
                  //     mainAxisSize: MainAxisSize.max,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           color: primaryColor.withOpacity(0.1),
                  //           shape: BoxShape.rectangle,
                  //           borderRadius: BorderRadius.circular(29.5.r),
                  //         ),
                  //         width: 245.w,
                  //         height: 54.h,
                  //         child: Row(
                  //           children: [
                  //             SizedBox(width: 4.w),
                  //
                  //             // Check if an image is selected and display it
                  //             if (_selectedImage != null)
                  //               Padding(
                  //                 padding: EdgeInsets.only(left: 4.w),
                  //                 child: Image.file(
                  //                   File(_selectedImage!.path),
                  //                   width: 40.w,
                  //                   height: 40.h,
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //               ),
                  //             SizedBox(width: 8.w),
                  //
                  //             // TextField for message input
                  //             Expanded(
                  //               child: TextField(
                  //                 controller: messageController,
                  //                 decoration: InputDecoration(
                  //                   contentPadding: EdgeInsets.only(
                  //                       left: 10.w, bottom: 5.h),
                  //                   hintText: 'Type your message',
                  //                   hintStyle: TextStyle(
                  //                     fontSize: 14.sp,
                  //                     fontWeight: FontWeight.w400,
                  //                   ),
                  //                   border: InputBorder.none,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       SizedBox(width: 8.w),
                  //
                  //       // Icon to open the gallery and pick an image
                  //       orderdata['deliveryStatus'] == true
                  //           ? GestureDetector(
                  //               onTap: () async {
                  //                 final XFile? image = await _picker.pickImage(
                  //                     source: ImageSource.gallery);
                  //                 if (image != null) {
                  //                   // Update the selected image variable
                  //                   _selectedImage = image;
                  //                   // Rebuild the widget to show the image
                  //                   setState(() {});
                  //                 }
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
                  //                     Icons.image,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //               ),
                  //             )
                  //           : SizedBox.shrink(),
                  //       SizedBox(width: 8.w),
                  //
                  //       // Send message icon
                  //       GestureDetector(
                  //         onTap: () async {
                  //           if (_selectedImage != null) {
                  //             // Upload the image to Firebase Storage and get the download URL
                  //             String? imageUrl =
                  //                 await uploadImageToFirebase(_selectedImage!);
                  //
                  //             if (imageUrl != null) {
                  //               if (messageController.text.trim().isEmpty) {
                  //                 // Show Snackbar if no text is added with the image
                  //                 ScaffoldMessenger.of(context).showSnackBar(
                  //                   SnackBar(
                  //                     content: Text(
                  //                         'You have sent an image without text.'),
                  //                     duration: Duration(seconds: 2),
                  //                   ),
                  //                 );
                  //               }
                  //
                  //               // Send the message with the image URL
                  //               await chatController.sendmessage(
                  //                 messageController,
                  //                 widget.chatId,
                  //                 widget.sellerId,
                  //                 'image',
                  //                 imageUrl, // Send the image URL as part of the message
                  //               );
                  //             }
                  //             await FirebaseFirestore.instance
                  //                 .collection('orders')
                  //                 .doc(orderdata['orderId'])
                  //                 .set({'returnedDate': DateTime.now()});
                  //             SetOptions(merge: true);
                  //           }
                  //           else {
                  //             // Send the message without an image
                  //             if (messageController.text.trim().isEmpty) {
                  //               // Show Snackbar if no text or image is provided
                  //               ScaffoldMessenger.of(context).showSnackBar(
                  //                 SnackBar(
                  //                   content: Text(
                  //                       'Please enter a message or select an image.'),
                  //                   duration: Duration(seconds: 2),
                  //                 ),
                  //               );
                  //             } else {
                  //               await chatController.sendmessage(
                  //                 messageController,
                  //                 widget.chatId,
                  //                 widget.sellerId,
                  //                 'text',
                  //                 '',
                  //               );
                  //             }
                  //           }
                  //
                  //           // Clear the message field and selected image after sending
                  //           messageController.clear();
                  //           _selectedImage = null;
                  //           setState(
                  //               () {}); // Rebuild the widget to clear the image preview
                  //         },
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             color: primaryColor,
                  //           ),
                  //           height: 53.h,
                  //           width: 53.w,
                  //           child: Center(
                  //             child: Icon(
                  //               Icons.send,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   );
                  // } else {
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
                  if (orderdata['deliveryStatus'] == false || orderdata['refund'] == false) {
                    // Check if orderDate is greater than 48 hours
                    DateTime orderDate = orderdata['orderDate'].toDate(); // Convert to DateTime if it's a Timestamp
                    bool isOlderThan48Hours = DateTime.now().difference(orderDate).inHours > 48;

                    if (isOlderThan48Hours || orderdata['isReturning'] == true) {
                      // Do not show the text field if order is older than 48 hours
                      return Container(
                        height: 30.h,
                        width: 310.w,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Center(
                            child: LexendCustomText(
                          text:
                              'You can\'t send messages to this group',
                          textColor: whiteColor,
                          fontWeight: FontWeight.w400,
                        )),
                      );
                    } else {
                      // Show the text field
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(29.5.r),
                            ),
                            width: 245.w,
                            height: 54.h,
                            child: Row(
                              children: [
                                SizedBox(width: 4.w),

                                // Check if an image is selected and display it
                                if (_selectedImage != null)
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.w),
                                    child: Image.file(
                                      File(_selectedImage!.path),
                                      width: 40.w,
                                      height: 40.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                SizedBox(width: 8.w),

                                // TextField for message input
                                Expanded(
                                  child: TextField(
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 10.w, bottom: 5.h),
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
                          SizedBox(width: 8.w),

                          // Icon to open the gallery and pick an image
                          orderdata['deliveryStatus'] == true
                              ? GestureDetector(
                                  onTap: () async {
                                    final XFile? image = await _picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (image != null) {
                                      // Update the selected image variable
                                      _selectedImage = image;
                                      // Rebuild the widget to show the image
                                      setState(() {});
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
                                        Icons.image,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          SizedBox(width: 8.w),

                          // Send message icon
                          GestureDetector(onTap: () async {
                            if (_selectedImage != null) {
                              // Upload the image to Firebase Storage and get the download URL
                              String? imageUrl =
                                  await uploadImageToFirebase(_selectedImage!);

                              if (imageUrl != null) {
                                if (messageController.text.trim().isEmpty) {
                                  // Show Snackbar if no text is added with the image
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'You have sent an image without text.'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }

                                // Send the message with the image URL
                                await chatController.sendmessage(
                                  messageController,
                                  widget.chatId,
                                  widget.sellerId,
                                  'image',
                                  imageUrl, // Send the image URL as part of the message
                                );
                              }
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(orderdata['orderId'])
                                  .update({
                                'returnedDate': DateTime.now(),
                                'isReturning': true
                              });

                            } else {
                              // Send the message without an image
                              if (messageController.text.trim().isEmpty) {
                                // Show Snackbar if no text or image is provided
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please enter a message or select an image.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                await chatController.sendmessage(
                                  messageController,
                                  widget.chatId,
                                  widget.sellerId,
                                  'text',
                                  '',
                                );
                              }
                            }

                            // Clear the message field and selected image after sending
                            messageController.clear();
                            _selectedImage = null;
                            setState(
                                () {}); // Rebuild the widget to clear the image preview
                          }, child: Obx(() {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                              height: 53.h,
                              width: 53.w,
                              child: chatController.isLoading.value == true
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: whiteColor,
                                    ))
                                  : Center(
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                    ),
                            );
                          })),
                        ],
                      );
                    }
                  } else {
                    return Container(
                        // height: 30.h,
                        width: 310.w,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Center(
                            child: LexendCustomText(
                          text:
                              'You can\'t send messages to this group\n                      Returned Item',
                          textColor: whiteColor,
                          fontWeight: FontWeight.w400,
                        )));
                  }
                }
              }),
          SizedBox(
            height: 19.h,
          ),
        ]));
  }
}
