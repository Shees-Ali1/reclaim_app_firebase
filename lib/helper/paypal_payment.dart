import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:get/get.dart';

class PaypalPayment extends StatefulWidget {
  final String amount;
  const PaypalPayment({super.key, required this.amount});

  @override
  State<PaypalPayment> createState() => _PaypalPaymentState();
}

class _PaypalPaymentState extends State<PaypalPayment> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: PaypalCheckoutView(
        sandboxMode: true,
        clientId: "",
        secretKey: "",
        transactions:  [
          {
            "amount": {
              "total": widget.amount,
              "currency": "Aed",
              "details": {
                "subtotal": widget.amount,
                "tax": '0', // Assuming the VAT is included in the total amount
                "shipping": '0',
                "shipping_discount": '0'
              }
            },
            "description": "Annual Subscription for Euro Jobs",
            "item_list": {
              "items": [
                {"name": "Annual Subscription", "quantity": 1, "price": widget.amount, "currency": "Aed"}
              ],
            }
          }
        ],
        note: "Contact Us for any Questions",
        onSuccess: (Map params) async {
          Get.snackbar("Success", "Payment Done");
       // await handleSuccess();

          Navigator.pop(context);
        },
        onError: (error) {
          Get.snackbar("Error", "$error");
          debugPrint("Error $error");
          Navigator.pop(context);
        },
        onCancel: () {
          Get.snackbar("Error", "Payment Cancelled");
          Navigator.pop(context);
        },
      ),
    );
  }
}
