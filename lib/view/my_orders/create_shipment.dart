import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../const/color.dart';
import '../../controller/home_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';

class CreateShipment extends StatefulWidget {
  const CreateShipment({super.key});

  @override
  State<CreateShipment> createState() => _CreateShipmentState();
}

class _CreateShipmentState extends State<CreateShipment> {
  final _formKey = GlobalKey<FormState>();
  final HomeController homeController = Get.find<HomeController>();
  final TextEditingController _deliveryTypeController = TextEditingController();
  final TextEditingController _loadTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _paymentTypeController = TextEditingController();
  final TextEditingController _numPiecesController = TextEditingController();
  final TextEditingController _originAddressNameController = TextEditingController();
  final TextEditingController _originAddressMobileController = TextEditingController();
  final TextEditingController _originAddressHouseController = TextEditingController();
  final TextEditingController _originAddressBuildingController = TextEditingController();
  final TextEditingController _originAddressAreaController = TextEditingController();
  final TextEditingController _originAddressCityController = TextEditingController();
  final TextEditingController _destinationAddressNameController = TextEditingController();
  final TextEditingController _destinationAddressMobileController = TextEditingController();
  final TextEditingController _destinationAddressHouseController = TextEditingController();
  final TextEditingController _destinationAddressBuildingController = TextEditingController();
  final TextEditingController _destinationAddressAreaController = TextEditingController();
  final TextEditingController _destinationAddressCityController = TextEditingController();
  DateTime? _pickupDate;

  bool _isLoading = false;
  Future<void> createShipment() async {
    if (!_formKey.currentState!.validate()) {
      // Collect validation errors
      String? errorMessage;
      if (_deliveryTypeController.text.isEmpty) {
        errorMessage = 'Delivery Type is required.';
      } else if (_loadTypeController.text.isEmpty) {
        errorMessage = 'Load Type is required.';
      } else if (_descriptionController.text.isEmpty) {
        errorMessage = 'Description is required.';
      } else if (_weightController.text.isEmpty) {
        errorMessage = 'Weight is required.';
      } else {
        final weight = double.tryParse(_weightController.text);
        if (weight == null || weight > 5) {
          errorMessage = 'Weight must be a valid number and not exceed 5 kg.';
        }
      }
      if (errorMessage == null && _paymentTypeController.text.isEmpty) {
        errorMessage = 'Payment Type is required.';
      } else if (errorMessage == null && _numPiecesController.text.isEmpty) {
        errorMessage = 'Number of Pieces is required.';
      } else if (errorMessage == null && _originAddressNameController.text.isEmpty) {
        errorMessage = 'Origin Address Name is required.';
      } else if (errorMessage == null && _originAddressMobileController.text.isEmpty) {
        errorMessage = 'Origin Address Mobile is required.';
      } else if (errorMessage == null && _originAddressHouseController.text.isEmpty) {
        errorMessage = 'Origin Address House No is required.';
      } else if (errorMessage == null && _originAddressBuildingController.text.isEmpty) {
        errorMessage = 'Origin Address Building is required.';
      } else if (errorMessage == null && _originAddressAreaController.text.isEmpty) {
        errorMessage = 'Origin Address Area is required.';
      } else if (errorMessage == null && _originAddressCityController.text.isEmpty) {
        errorMessage = 'Origin Address City is required.';
      } else if (errorMessage == null && _destinationAddressNameController.text.isEmpty) {
        errorMessage = 'Destination Address Name is required.';
      } else if (errorMessage == null && _destinationAddressMobileController.text.isEmpty) {
        errorMessage = 'Destination Address Mobile is required.';
      } else if (errorMessage == null && _destinationAddressHouseController.text.isEmpty) {
        errorMessage = 'Destination Address House No is required.';
      } else if (errorMessage == null && _destinationAddressBuildingController.text.isEmpty) {
        errorMessage = 'Destination Address Building is required.';
      } else if (errorMessage == null && _destinationAddressAreaController.text.isEmpty) {
        errorMessage = 'Destination Address Area is required.';
      } else if (errorMessage == null && _destinationAddressCityController.text.isEmpty) {
        errorMessage = 'Destination Address City is required.';
      } else if (errorMessage == null && _pickupDate == null) {
        errorMessage = 'Pickup Date is required.';
      }

      // Show the first validation error in a snackbar
      if (errorMessage != null) {
        Get.snackbar(
          'Validation Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        );
      }

      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Proceed with the API call
    final body = {
      "delivery_type": _deliveryTypeController.text,
      "load_type": _loadTypeController.text,
      "consignment_type": "FORWARD",
      "description": _descriptionController.text,
      "weight": _weightController.text,
      "payment_type": _paymentTypeController.text,
      "cod_amount": "0",
      "num_pieces": _numPiecesController.text,
      "customer_reference_number": "",
      "origin_address_name": _originAddressNameController.text,
      "origin_address_mob_no_country_code": "+971",
      "origin_address_mobile_number": _originAddressMobileController.text,
      "origin_address_alt_ph_country_code": "",
      "origin_address_alternate_phone": "",
      "origin_address_house_no": _originAddressHouseController.text,
      "origin_address_building_name": _originAddressBuildingController.text,
      "origin_address_area": _originAddressAreaController.text,
      "origin_address_landmark": "",
      "origin_address_city": _originAddressCityController.text,
      "origin_address_type": "Normal",
      "destination_address_name": _destinationAddressNameController.text,
      "destination_address_mob_no_country_code": "+971",
      "destination_address_mobile_number": _destinationAddressMobileController.text,
      "destination_details_alt_ph_country_code": "",
      "destination_details_alternate_phone": "",
      "destination_address_house_no": _destinationAddressHouseController.text,
      "destination_address_building_name": _destinationAddressBuildingController.text,
      "destination_address_area": _destinationAddressAreaController.text,
      "destination_address_landmark": "",
      "destination_address_city": _destinationAddressCityController.text,
      "destination_address_type": "Normal",
      "pickup_date": DateFormat('yyyy-MM-dd').format(_pickupDate!),
    };

    try {
      final response = await http.post(
        Uri.parse('https://demo.jeebly.com/customer/create_shipment'),
        headers: {
          'X-API-KEY': 'JjEeEeBbLlYy1200',
          'client_key': '672X240905121302Y416d69726153756c74616e',
          'Content-Type': 'application/json',
          'Cookie': 'ci_session=ra65vq634c0ff8tgngse4fc9v4mebqah',
        },
        body: jsonEncode(body),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final awbNumber = data['AWB No'];
        showSuccessDialog(data['message'], awbNumber);
        await saveAWBToFirebase(awbNumber);
      } else {
        Get.snackbar(
          'Error',
          'Failed to create shipment: ${response.body}',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'Exception',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }




  Future<void> saveAWBToFirebase(String awbNumber) async {
    final userId = FirebaseAuth.instance.currentUser!.uid; // Replace with current user ID
    final userRef = FirebaseFirestore.instance.collection('userDetails').doc(userId);

    await userRef.update({
      'awbNumbers': FieldValue.arrayUnion([awbNumber]),
    });
  }
  Future<void> generateLabel(String awbNumber) async {
    try {
      final response = await http.post(
        Uri.parse('https://demo.jeebly.com/customer/generate_shipment_label'),
        headers: {
          'X-API-KEY': 'JjEeEeBbLlYy1200',
          'client_key': '672X240905121302Y416d69726153756c74616e',
          'Content-Type': 'application/json',
          'Cookie': 'ci_session=ra65vq634c0ff8tgngse4fc9v4mebqah',
        },
        body: jsonEncode({
          "reference_number": awbNumber,
        }),
      );

      if (response.statusCode == 200) {
        // Save the PDF to Downloads
        final filePath = await savePDF(response.bodyBytes, awbNumber);

        print("PDF saved to: $filePath");

        // Optionally open the PDF (requires a PDF viewer installed)
        await openPDF(filePath);

        Get.snackbar(
          'Success',
          'Label saved to Downloads successfully!',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to generate label: ${response.body}',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Exception',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<String> savePDF(List<int> pdfBytes, String fileName) async {
    try {
      // Get the Documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create a file in the Documents directory
      final filePath = '${directory.path}/$fileName.pdf';
      final file = File(filePath);

      // Write the PDF bytes to the file
      await file.writeAsBytes(pdfBytes);

      // Return the file path
      return filePath;
    } catch (e) {
      throw Exception("Failed to save PDF: $e");
    }
  }

  Future<void> openPDF(String filePath) async {
    await OpenFile.open(filePath);
  }

  void showSuccessDialog(String message, String awbNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('$message\nAWB No: $awbNumber'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await generateLabel(awbNumber);
            },
            child: Text('Generate Label'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar1(
        homeController: homeController,
        text: 'Create Shipment',
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(controller: _deliveryTypeController, label: "Delivery Type"),
              CustomTextField(controller: _loadTypeController, label: "Load Type"),
              CustomTextField(controller: _descriptionController, label: "Description"),
              CustomTextField(controller: _weightController, label: "Weight"),
              CustomTextField(controller: _paymentTypeController, label: "Payment Type"),
              CustomTextField(controller: _numPiecesController, label: "Number of Pieces"),
              CustomTextField(controller: _originAddressNameController, label: "Origin Address Name"),
              CustomTextField(controller: _originAddressMobileController, label: "Origin Address Mobile"),
              CustomTextField(controller: _originAddressHouseController, label: "Origin Address House No"),
              CustomTextField(controller: _originAddressBuildingController, label: "Origin Address Building"),
              CustomTextField(controller: _originAddressAreaController, label: "Origin Address Area"),
              CustomTextField(controller: _originAddressCityController, label: "Origin Address City"),
              CustomTextField(controller: _destinationAddressNameController, label: "Destination Address Name"),
              CustomTextField(controller: _destinationAddressMobileController, label: "Destination Address Mobile"),
              CustomTextField(controller: _destinationAddressHouseController, label: "Destination Address House No"),
              CustomTextField(controller: _destinationAddressBuildingController, label: "Destination Address Building"),
              CustomTextField(controller: _destinationAddressAreaController, label: "Destination Address Area"),
              CustomTextField(controller: _destinationAddressCityController, label: "Destination Address City"),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _pickupDate = pickedDate;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(16.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    _pickupDate == null
                        ? "Select Pickup Date"
                        : DateFormat('yyyy-MM-dd').format(_pickupDate!),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: _isLoading ? null : createShipment, // Call the relevant method
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLoading ? Colors.grey : primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Create Shipment', style: TextStyle(fontSize: 16.sp,color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
