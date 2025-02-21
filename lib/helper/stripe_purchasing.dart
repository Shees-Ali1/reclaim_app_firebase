import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reclaim_firebase_app/controller/productsListing_controller.dart';
import '../const/color.dart';
import '../controller/sign_up_controller.dart';
import '../controller/wallet_controller.dart';
import '../controller/wishlist_controller.dart';

class StripePaymentPurchasing {
  final WalletController walletController = Get.put(WalletController());
  final SignUpController signUpController = Get.put(SignUpController());
  final ProductsListingController productsListingController =
      Get.put(ProductsListingController());

  Map<String, dynamic>? paymentIntents;
  String secretKey =
      "sk_test_51PF3XJBD4iwEMWA7nvI3hZ14p1gCIEI4dWzkhTliZkYafzBkm67TkPNwtn6vWwXXFPBaTZlchZpEdeRKICFZURj100ikoXKwel";
  String calculateAmount(String amount) {
    try {

      // Trim any leading or trailing whitespaces
      amount = amount.trim();

      // Remove any non-numeric characters
      amount = amount.replaceAll(RegExp(r'[^0-9.]'), '');

      // Parse the amount as a double
      final doubleAmount = double.parse(amount);

      // Convert the amount to cents (multiply by 100)
      final result = (doubleAmount * 100).toInt().toString();

      return result;
    } catch (e) {
      print('Error parsing amount: $e');
      // Handle the error appropriately (e.g., return a default value or throw an exception)
      return '0';
    }
  }

  Future<void> paymentPurchasing(
      String amount,
      String listingId,
      String sellerId,
      String brand,
      BuildContext context,
      String productName,
      int purchasePrice,
      String productImage,
      bool isdirectPurchase,
      dynamic order,
      double shippingAmount,
      String address,
      ) async {
    print('Payment method called');

    try {
      signUpController.isLoading.value = true;

      int appFees = (purchasePrice * 0.1).round();
      int shippingAmountTotal = shippingAmount.toInt();
      int finalPrice = purchasePrice + appFees + shippingAmountTotal;

      Map<String, dynamic> body = {
        'amount': calculateAmount(finalPrice.toString()),
        'currency': 'AED',
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey', // Use actual secret key
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create payment intent: ${response.body}');
      }

      Map<String, dynamic> paymentIntents = jsonDecode(response.body);
      print("Payment Intents: $paymentIntents");

      /// Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: secretKey,
          paymentIntentClientSecret: paymentIntents['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'Reclaim',
          appearance: const PaymentSheetAppearance(
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                dark: PaymentSheetPrimaryButtonThemeColors(
                  background: primaryColor,
                  text: whiteColor,
                ),
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: primaryColor,
                  text: whiteColor,
                ),
              ),
            ),
            colors: PaymentSheetAppearanceColors(
              background: whiteColor,
            ),
            shapes: PaymentSheetShape(
              borderRadius: BorderSide.strokeAlignCenter,
            ),
          ),
        ),
      )
          .catchError((error) {
        throw Exception('Error initializing payment sheet: $error');
      });

      /// Display Payment Sheet
      await Stripe.instance.presentPaymentSheet().then((value) async {
        if (isdirectPurchase) {
          productsListingController.buyProduct(
            listingId,
            sellerId,
            brand,
            context,
            productName,
            purchasePrice,
            productImage,
            finalPrice,
            address, shippingAmount,
          );
        } else {
          productsListingController.buyProduct1(
            listingId,
            sellerId,
            brand,
            context,
            productName,
            order['offers']['offerPrice'],
            productImage,
            order['orderId'],
          );
        }

        Get.snackbar("Success", "Payment completed successfully");
      }).catchError((e) {
        throw Exception("Payment Sheet Error: $e");
      });
    } catch (e) {
      print('Payment Error: $e');
    } finally {
      signUpController.isLoading.value = false;
    }
  }
}
