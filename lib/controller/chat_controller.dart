import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'notification_controller.dart';

class ChatController extends GetxController {
  NotificationController notificationController =
      Get.put(NotificationController());

  RxList<dynamic> messages = [
    {
      "sendby": 'me',
      "message": 'how are you',
    },
    {
      "sendby": 'other',
      "message": 'I am fine',
    }
  ].obs;
  Future<void> sendmessage(TextEditingController messageController,
      String chatId, String sellerId) async {
    try {
      if (messageController.text.isNotEmpty) {
        // DocumentSnapshot chatSnap = await FirebaseFirestore.instance
        //     .collection("userMessages")
        //     .doc(chatId)
        //     .get();
        // // if(chatSnap.exists){
        // await FirebaseFirestore.instance
        //     .collection('userMessages')
        //     .doc(chatId)
        //     .collection('messages')
        //     .add({
        //   'message': messageController.text,
        //   'timeStamp': DateTime.now(),
        //   'userId': FirebaseAuth.instance.currentUser!.uid,
        // });
        String message = messageController.text;
        messageController.clear();
        print("MEssage sent");
        // notificationController.sendFcmMessage(
        //     "New Message", "${message}", sellerId);
      }
    } catch (e) {
      print("Error sending message $e");
    }
  }

  // Convert timestamp to DateTime hour minute
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat.Hm().format(dateTime);
    return formattedTime;
  }

//   Create chat with seller when buy book
  Future<void> createChatConvo(String listingId, String orderId,
      String bookName, String sellerId,String bookImage) async {
    try {
      // On buyer side chat creation

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("convo")
          .doc(orderId)
          .set({
        // Order id is our chat id
        'chatId': orderId,
        'bookId': listingId,
        'sellerId': sellerId,
        'orderDate': DateTime.now(),
        'bookName': bookName,
        'buyerId': FirebaseAuth.instance.currentUser!.uid,
        'person': 'buyer',
        'bookImage':bookImage
      }, SetOptions(merge: true));
      print("chat created");
      // On seller side chat creation
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(sellerId)
          .collection("convo")
          .doc(orderId)
          .set({
        // Order id is our chat id
        'chatId': orderId,
        'bookId': listingId,
        'sellerId': sellerId,
        'orderDate': DateTime.now(),
        'bookName': bookName,
        'buyerId': FirebaseAuth.instance.currentUser!.uid,
        'person': 'seller',
        'bookImage':bookImage
      }, SetOptions(merge: true));
      print("chat created");
      // creating a message with address
      await FirebaseFirestore.instance
          .collection('userMessages')
          .doc(orderId)
          .collection('messages')
          .add({
        'message': "You Got the Order on ${bookName}",
        'timeStamp': DateTime.now(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
    } catch (e) {
      print("error creating conv $e");
    }
  }




RxString orderId =''.obs;
  RxString sellerId = ''.obs;
  RxString buyerId = ''.obs;
  RxBool deliverystatus = false.obs;
  Future<void> getorderId(String bookId) async {
  try{
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where("buyerId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("bookId", isEqualTo: bookId)
        .get();
    if(snapshot.docs.isNotEmpty){
      dynamic order =snapshot.docs.first;
      orderId.value = order['orderId'];
      sellerId.value = order['sellerId'];
      buyerId.value = order['buyerId'];
      deliverystatus.value = order['deliveryStatus'];
      print(orderId.value);
      print(sellerId.value);
      print(buyerId.value);
      update();
    }else{
      deliverystatus.value =true;
      print('There is no order');
    }



  }catch(e){
    print('Error fetching orderID$e');
  }
  }



//   formT MEESAGE TIME
  String formatMessageTimestamp(Timestamp timestamp) {
    var date = timestamp.toDate();
    return DateFormat('d MMM HH:mm').format(date);
  }

  bool shouldShowTimestamp(DateTime current, DateTime? previous) {
    if (previous == null)
      return true;
    return current.difference(previous).inMinutes >= 10;
  }
}
