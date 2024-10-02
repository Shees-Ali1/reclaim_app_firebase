import 'package:flutter/material.dart';
import 'package:reclaim_firebase_app/const/color.dart';

class PaymentSelectionScreen extends StatefulWidget {
  @override
  _PaymentSelectionScreenState createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  String selectedPayment = '';

  final List<Map<String, dynamic>> payments = [
    {
      'name': 'Stripe',
      'logo': Icons.account_balance,
      'checked': true,
    },
    {
      'name': 'Paypal',
      'logo': Icons.account_balance_wallet,
      'checked': false,
    },
    {
      'name': 'Apple card',
      'logo': Icons.account_balance_outlined,
      'checked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: payments.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selectedPayment == payments[index]['name']
                ? primaryColor
                : primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selectedPayment == payments[index]['name']
                  ? Colors.transparent
                  : primaryColor,
            ),
          ),
          child: RadioListTile<String>(
            value: payments[index]['name'],
            groupValue: selectedPayment,
            onChanged: (String? value) {
              setState(() {
                selectedPayment = value!;
              });
            },
            title: Row(
              children: [
                Text(
                  payments[index]['name'],
                  style: TextStyle(
                    color: selectedPayment == payments[index]['name']?Colors.white:Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            activeColor: Colors.white,
            controlAffinity: ListTileControlAffinity.trailing,
          ),
        );
      },
    );
  }
}
