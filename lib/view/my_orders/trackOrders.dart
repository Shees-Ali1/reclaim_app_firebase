import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../../const/color.dart';
import '../../helper/loading.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';

class TrackOrders extends StatefulWidget {
  const TrackOrders({super.key});

  @override
  State<TrackOrders> createState() => _TrackOrdersState();
}

class _TrackOrdersState extends State<TrackOrders> {
  Map<String, dynamic>? trackingData;
  bool isLoading = true;

  // API Call Function
  Future<void> fetchTrackingData() async {
    const String apiUrl = "https://demo.jeebly.com/customer/track_shipment";
    const Map<String, String> headers = {
      "X-API-KEY": "JjEeEeBbLlYy1200",
      "client_key": "435X230720100046Y497266616e4a6565626c79",
      "Content-Type": "application/json",
    };
    const Map<String, dynamic> body = {
      "reference_number": "JB304509",
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data["success"] == "true") {
          setState(() {
            trackingData = data["Tracking"];
            isLoading = false;
          });
        } else {
          // Handle API error response
          setState(() {
            isLoading = false;
          });
          showErrorSnackBar("Failed to fetch tracking data.");
        }
      } else {
        // Handle HTTP error
        setState(() {
          isLoading = false;
        });
        showErrorSnackBar("Server error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle network or parsing errors
      setState(() {
        isLoading = false;
      });
      showErrorSnackBar("An error occurred: $e");
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchTrackingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar1(
        homeController: homeController,
        text: 'Track Orders',
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : trackingData == null
          ? Center(child: Text("No tracking data available."))
          : ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        children: [
          // Reference Number
          InterCustomText(
            text: "Reference No: ${trackingData!['reference_no']}",
            textColor: Colors.black,
            fontsize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 8.h),

          // Last Status
          InterCustomText(
            text: "Last Status: ${trackingData!['last_status']}",
            textColor: Colors.grey[700]!,
            fontsize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 8.h),

          // Pickup Date
          InterCustomText(
            text: "Pickup Date: ${trackingData!['pickup_date']}",
            textColor: Colors.grey[700]!,
            fontsize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 16.h),

          // Events
          InterCustomText(
            text: "Events:",
            textColor: Colors.black,
            fontsize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 8.h),

          // List of Events
          ...List.generate(
            trackingData!['events'].length,
                (index) {
              final event = trackingData!['events'][index];
              return Card(
                margin: EdgeInsets.only(bottom: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InterCustomText(
                        text: "Status: ${event['status']}",
                        textColor: Colors.black87,
                        fontsize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 4.h),
                      InterCustomText(
                        text: "Description: ${event['desc']}",
                        textColor: Colors.grey[700]!,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 4.h),
                      InterCustomText(
                        text:
                        "Event Time: ${DateTime.parse(event['event_date_time']).toLocal()}",
                        textColor: Colors.grey[700]!,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
