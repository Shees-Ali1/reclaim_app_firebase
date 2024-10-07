import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
            // Ratings Overview (Show Seller's Average Rating)
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: productsListingController.fetchProductReviews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No seller ratings available.'));
                }

                final reviews = snapshot.data!;
                double totalRating = reviews.fold(
                  0.0,
                  (sum, review) => sum + (review['rating']?.toDouble() ?? 5.0),
                );
                double averageRating = totalRating / reviews.length;

                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Seller Review',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBarIndicator(
                            rating: averageRating,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 30.0,
                            direction: Axis.horizontal,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${averageRating.toStringAsFixed(1)} out of 5',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 10),

            // User Reviews Section
            Text('User Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            SizedBox(height: 5),

            // User Reviews List
            Expanded(
                child: UserReviewsList(
              sellerId: FirebaseAuth.instance.currentUser!.uid,
            )),
          ],
        ),
      ),
    );
  }
}

class UserReviewsList extends StatelessWidget {
  final String sellerId; // Pass the sellerId to this widget

  UserReviewsList({required this.sellerId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: productsListingController.fetchProductReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(
            color: primaryColor,

          ));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No reviews available.'));
        }

        final reviews = snapshot.data!;

        return ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            Timestamp timestamp = review['timestamp'];
            DateTime date = timestamp.toDate();
            String formattedDate = DateFormat('yyyy-MM-dd').format(date);

            // Check if the current user has liked this review
            final currentUserId = FirebaseAuth.instance.currentUser!.uid;
            final bool isLiked = review['likedBy'].contains(currentUserId);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        review['buyerImage'] ??
                            'https://via.placeholder.com/150',
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review['buyerName'] ?? 'Anonymous'),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: review['rating']?.toDouble() ?? 5.0,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                            SizedBox(width: 10),
                            Text(formattedDate,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(review['reviewText']!),
                SizedBox(height: 10),
                Row(
                  children: [
                    // Like button
                    IconButton(
                      onPressed: () async {
                        if (isLiked) {
                          await productsListingController.unlikeReview(
                              sellerId, review['reviewId']);
                        } else {
                          await productsListingController.likeReview(
                              sellerId, review['reviewId']);
                        }
                      },
                      icon: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        size: 20,
                        color: isLiked ? Colors.blue : Colors.grey,
                      ),
                    ),
                    SizedBox(width: 2),
                    Text(review['likeCount'].toString()), // Display like count
                    SizedBox(width: 10),
                    // Icon(Icons.reply, size: 24),
                    // SizedBox(width: 5),
                    // Text('Reply'),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
