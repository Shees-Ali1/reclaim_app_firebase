import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../const/color.dart';
import '../../../helper/loading.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_text.dart';

class ReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar1(
        homeController: homeController,
        text: 'Reviews',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ratings Overview
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Text('Seller Review',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBarIndicator(
                        rating: 4.5,
                        itemBuilder: (context, index) =>
                            Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 30.0,
                        direction: Axis.horizontal,
                      ),
                      SizedBox(width: 10),
                      Text('4.5 out of 5', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Rating Breakdown
                  RatingBreakdown(),
                ],
              ),
            ),
            SizedBox(height: 10),

            Text('User Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            Divider(),
            SizedBox(height: 5),

            // User Reviews
            Expanded(child: UserReviewsList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () {},
        label: InterCustomText(
          text: 'Write Review',
          textColor: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        icon: Icon(Icons.edit),
      ),
    );
  }
}

class RatingBreakdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildRatingRow(5, 60),
        buildRatingRow(4, 35),
        buildRatingRow(3, 15),
        buildRatingRow(2, 10),
        buildRatingRow(1, 25),
      ],
    );
  }

  Widget buildRatingRow(int starCount, int percentage) {
    return Row(
      children: [
        Text('$starCount star'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(12),
              minHeight: 10,
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              color: Colors.amber,
            ),
          ),
        ),
        Text('$percentage%'),
      ],
    );
  }
}

class UserReviewsList extends StatelessWidget {
  final List<Map<String, String>> reviews = [
    {
      'name': 'Ryosuke Tanaka',
      'date': 'August 5, 2023',
      'review':
      'This app offers an impressive array of features and resources.',
    },
    // Add more reviews here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // User image URL
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reviews[index]['name']!),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: 5.0,
                          itemBuilder: (context, index) =>
                              Icon(Icons.star, color: Colors.amber),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(reviews[index]['date']!,
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(reviews[index]['review']!),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.thumb_up, size: 24),
                SizedBox(width: 5),
                Text('36'),
                SizedBox(width: 10),
                Icon(Icons.reply, size: 24),
                SizedBox(width: 5),
                Text('Reply'),
                Spacer(),
                Icon(Icons.favorite_border, size: 24),
                SizedBox(width: 5),



              ],
            ),
          ],
        );
      },
    );
  }
}
void _showReplyDialog(BuildContext context, String productId, String reviewId) {
  TextEditingController _replyController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Reply to Review'),
        content: TextField(
          controller: _replyController,
          decoration: InputDecoration(hintText: 'Write your reply...'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Call the function to submit the reply
              await submitReplyToReview(productId, reviewId, _replyController.text);
              Navigator.of(context).pop();
            },
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}

Future<void> submitReplyToReview(String productId, String reviewId, String reply) async {
  await FirebaseFirestore.instance
      .collection('productReviews')
      .doc(productId)
      .collection('reviews')
      .doc(reviewId)
      .update({'reply': reply});
}

Widget reviewList(String productId) {
  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: productsListingController.fetchProductReviews(productId),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      if (!snapshot.hasData) {
        return CircularProgressIndicator();
      }
      final reviews = snapshot.data!;

      return ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];

          return ListTile(
            title: Text('Rating: ${review['rating']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review['reviewText']),
                if (review['reply'] != null && review['reply'] != '')
                  Text('Seller Reply: ${review['reply']}'),
                TextButton(
                  onPressed: () {
                    _showReplyDialog(context, productId, review['reviewId']);
                  },
                  child: Text('Reply'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
