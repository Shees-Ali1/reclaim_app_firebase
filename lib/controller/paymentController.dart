import 'dart:io';

import 'package:get/get.dart';

class PaymentController extends GetxController {
  String selectedPayment = '';
  List<Map<String, String>> payments = [
    {'name': 'Card '},

    {'name': 'Wallet'},
    if (Platform.isIOS) {'name': 'Apple card'},
  ];

  // Method to update the selected payment
  void selectPayment(String paymentName) {
    selectedPayment = paymentName;
    update(); // This triggers the GetBuilder to rebuild
  }
}
