import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'notification_controller.dart';

class ChatController extends GetxController {
  NotificationController notificationController =
      Get.put(NotificationController());
  final TextEditingController messageController = TextEditingController();
  List<String> restrictedWords = [
    'fuck', 'fed', 'fing', 'shit', 'bitch', 'asshole', 'cunt', 'dick', 'dickhead', 'pussy',
    'motherfucker', 'tit', 'sex', 'porn', 'nudes', 'erotic', 'strip', 'masturbation', 'horny',
    'lustful', 'nsfw', 'xxx', 'kill', 'murder', 'rape', 'stab', 'slaughter', 'torture',
    'bomb', 'terrorist', 'assault', 'abuse', 'nigger', 'faggot', 'retard', 'bitch', 'slut',
    'cunt', 'racist slur', 'homophobic slur', 'islamophobic', 'anti-semitic', 'xenophobic slur',
    'transphobic slur', 'cocaine', 'heroin', 'meth', 'weed', 'marijuana', 'high', 'junkie',
    'dealer', 'stoned', 'ecstasy', 'lsd', 'scammer', 'cheat', 'fraud', 'bullshit', 'douche', 'thief'
  ];

  RxString errorText = ''.obs;
  @override
  void onInit() {
    super.onInit();
    messageController.addListener(() {
      String inputText = messageController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        messageController.clear();
        Get.snackbar('Error', 'Your message contains inappropriate content'); // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });

  }
  // Method to check for restricted words
  bool _containsRestrictedWords(String text) {
    for (var word in restrictedWords) {
      if (text.toLowerCase().contains(word.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }

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
        DocumentSnapshot chatSnap = await FirebaseFirestore.instance
            .collection("userMessages")
            .doc(chatId)
            .get();
        // if(chatSnap.exists){
        await FirebaseFirestore.instance
            .collection('userMessages')
            .doc(chatId)
            .collection('messages')
            .add({
          'message': messageController.text,
          'timeStamp': DateTime.now(),
          'userId': FirebaseAuth.instance.currentUser!.uid,
        });
        String message = messageController.text;
        messageController.clear();
        print("MEssage sent");
        notificationController.sendFcmMessage(
            "New Message", "${message}", sellerId);
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
      String productName, String sellerId,String productImage,int productPrice,String message,String brand) async {
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
        'productId': listingId,
        'sellerId': sellerId,
        'orderDate': DateTime.now(),
        'productName': productName,
        'buyerId': FirebaseAuth.instance.currentUser!.uid,
        'person': 'buyer',
        'productImage':productImage,
        'brand':brand,
        'productPrice':productPrice
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
        'productId': listingId,
        'sellerId': sellerId,
        'orderDate': DateTime.now(),
        'productName': productName,
        'buyerId': FirebaseAuth.instance.currentUser!.uid,
        'person': 'seller',
        'brand':brand,

        'productImage':productImage,
        'productPrice':productPrice

      }, SetOptions(merge: true));
      print("chat created");
      // creating a message with address
      await FirebaseFirestore.instance
          .collection('userMessages')
          .doc(orderId)
          .collection('messages')
          .add({
        'message': message,
        'timeStamp': DateTime.now(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
    } catch (e) {
      print("error creating conv $e");
    }
  }




RxBool isOrdered =false.obs;
  RxString sellerId = ''.obs;
  RxString buyerId = ''.obs;
  RxBool deliverystatus = false.obs;
  Future<void> getorderId(String productId) async {
  try{
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where("buyerId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("productId", isEqualTo: productId)
        .get();
    if(snapshot.docs.isNotEmpty){
      dynamic order =snapshot.docs.first;
      isOrdered.value = order['isOrdered'];
      sellerId.value = order['sellerId'];
      buyerId.value = order['buyerId'];
      deliverystatus.value = order['deliveryStatus'];
      print(isOrdered.value);
      print(sellerId.value);
      print(buyerId.value);
      update();
    }else{
      deliverystatus.value =true;
      isOrdered.value = false;

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
