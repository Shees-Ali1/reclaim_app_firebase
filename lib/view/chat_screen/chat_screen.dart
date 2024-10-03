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

  Future<void> orderStatusBySeller(dynamic order,) async{
    try{
      if(order['sellerApproval']==false){

        orderController.isLoading.value=true;

        // mark delivery by seller has true
        await FirebaseFirestore.instance.collection('orders').doc(order['orderId']).update({
          'sellerApproval': true,
        });

        // then store the notification to buyer that seller has marked delivered
        DocumentReference notiId  = await FirebaseFirestore.instance.collection('userNotifications').doc(order['buyerId']).collection('notifications')
            .add({
          'productId': widget.productId,
          'orderId': order['orderId'],
          // 'price':price,
          'time': DateTime.timestamp(),
          'title': "Seller has marked ${widget.productName} as delivered",
          'userId': order['sellerId'],
          'notificationType':'seller'
        });
        await FirebaseFirestore.instance.collection('userNotifications')
            .doc(order['buyerId']).collection('notifications').doc(notiId.id).set({
          'notificationId':notiId.id
        },SetOptions(merge: true));

        await markDeliveryTrue(order);
      }
    }catch(e){
      print("error changing order status by seller $e");
    }finally{
      orderController.isLoading.value=false;
    }
  }
  Future<void> orderStatusByBuyer(dynamic order,) async{
 try{
   if(order['buyerApproval']==false){

     orderController.isLoading.value=true;

     // mark delivery by buyer has true
     await FirebaseFirestore.instance.collection('orders').doc(order['orderId']).update({
       'buyerApproval': true,
     });

     // then store the notification to seller that buyer has marked recieved
     DocumentReference notiId  = await FirebaseFirestore.instance.collection('userNotifications').doc(order['sellerId']).collection('notifications')
         .add({
       'productId': widget.productId,
       'orderId': order['orderId'],
       // 'price':price,
       'time': DateTime.timestamp(),
       'title': "Buyer has marked ${widget.productName} as delivered",
       'userId': order['buyerId'],
       'notificationType':'buyer'
     });

     await FirebaseFirestore.instance.collection('userNotifications')
         .doc(order['sellerId']).collection('notifications').doc(notiId.id).set({
       'notificationId':notiId.id
     },SetOptions(merge: true));

     await markDeliveryTrue(order);
   }

 }catch(e){
   print("error changing order status by buyer $e");
 }finally{
   orderController.isLoading.value=false;
 }

  }
  Future<void> markDeliveryTrue(dynamic order) async{
  // check that the status by seller and buyer are true then mark order as complete
      if (order['sellerApproval'] && order['buyerApproval'] == true) {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(order['orderId'])
            .update({
          'deliveryStatus': true,
        });
        print("order  completed ");

    }else{
        print("order not complete yet");
      }


  }

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
                if(widget.seller != FirebaseAuth.instance.currentUser!.uid)
                Obx(
                  () => !userController.userPurchases.contains(widget.productId)
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
                                              text: offerPrice
                                                  .toString(), // Convert offerPrice to String
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
                            if (widget.seller != FirebaseAuth.instance.currentUser!.uid)
                              Positioned(
                                bottom: 10.h,
                                left: 0,
                                right: 0,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 70.0.w),
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
                                                    builder:
                                                        (context, setState) {
                                                      return OfferDialog(
                                                        orderId: widget.chatId,
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
                                            horizontal: 10.w, vertical: 10.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                      ),
                                      child: isAccepted
                                          ? GestureDetector(
                                              onTap: () {
                                                if (productsListingController
                                                        .isLoading.value ==
                                                    false) {
                                                  productsListingController
                                                      .buyProduct1(
                                                          widget.productId,
                                                          widget.seller,
                                                          widget.brand,
                                                          context,
                                                          widget.productName,
                                                          order['offers']
                                                              ['offerPrice'],
                                                          widget.image,
                                                          order['orderId']);
                                                }
                                              },
                                              child: LexendCustomText(
                                                text:
                                                    'Offer Accepted ${order['offers']['offerPrice'].toString()} Aed\n        Purchase Now',
                                                textColor: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          : LexendCustomText(
                                              text: "Make a new Offer",
                                              textColor: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            )),
                                ),
                              ),
                            if (widget.seller == FirebaseAuth.instance.currentUser!.uid)
                              Positioned(
                                bottom: 10.h,
                                left: 0,
                                right: 0,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 40.0.w),
                                  child: isAccepted
                                      ? Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          width: 60,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
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
                                              await FirebaseFirestore.instance
                                                  .collection('orders')
                                                  .doc(widget
                                                      .chatId) // Use the chatId to locate the specific order
                                                  .update({
                                                'offers.isAccepted':
                                                    'accepted', // Update the offer's status to 'accepted'
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content:
                                                        Text('Offer accepted')),
                                              );
                                              productsListingController
                                                  .isLoading.value = false;
                                            } catch (error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Error accepting offer: $error')),
                                              );
                                              productsListingController
                                                  .isLoading.value = false;
                                            }
                                          },
                                          onDecline: () async {
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('orders')
                                                  .doc(widget
                                                      .chatId) // Use the chatId to locate the specific order
                                                  .update({
                                                'offers.isAccepted':
                                                    'rejected', // Update the offer's status to 'rejected'
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content:
                                                        Text('Offer declined')),
                                              );
                                            } catch (error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Error declining offer: $error')),
                                              );
                                            }
                                          },
                                          amount: order != null &&
                                                  order['offers'] != null
                                              ? order['offers']['offerPrice']
                                                  .toString()
                                              : "0",
                                          currency: 'Aed',
                                        ),
                                ),
                              ),


                          ],
                        )
                      : Positioned(
                    bottom: 10.h,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                      child: ElevatedButton(
                          onPressed: () async{
                            if(widget.seller==FirebaseAuth.instance.currentUser!.uid){
                              if(orderController.isLoading.value==false) {
                                await orderStatusBySeller(order);
                              }
                            }else{
                              if(orderController.isLoading.value==false) {
                                await orderStatusByBuyer(order);
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
                            return orderController.isLoading.value == false
                                ? LexendCustomText(
                              text: order['deliveryStatus']==true
                                  ? "Order Completed"
                                  : widget.seller == FirebaseAuth.instance.currentUser!.uid
                                  ?  order['sellerApproval']==true
                                  ? 'Waiting for buyer to approve'
                                  : 'Click here to mark order delivered'
                                  : order['buyerApproval']==true
                                  ? 'Waiting for seller to approve'
                                  : 'Click here to mark order received',
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
                  if (orderdata['deliveryStatus'] == false) {
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
                          SizedBox(
                            width: 8.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              chatController.sendmessage(messageController,
                                  widget.chatId, widget.sellerId);
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
                        ]);
                  } else {
                    return Container(
                        height: 30.h,
                        width: 310.w,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Center(
                            child: LexendCustomText(
                          text: 'You can\'t send messages to this group',
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
