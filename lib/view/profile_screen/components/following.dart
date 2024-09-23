import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reclaim_firebase_app/const/color.dart';

import '../../../helper/loading.dart';
import '../../../widgets/custom_appbar.dart';

class FollowingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar1(
        homeController: homeController,
        text: 'Followings',
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userDetails')
            .where('userId',
                isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
              color: primaryColor,
            ));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user['userName']),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['userImage']),
                ),
                trailing: FollowButton(userId: user.id),
              );
            },
          );
        },
      ),
    );
  }
}

class FollowButton extends StatefulWidget {
  final String userId;

  FollowButton({required this.userId});

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    checkFollowingStatus();
  }

  Future<void> checkFollowingStatus() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(currentUserId)
        .get();

    if (currentUserDoc.exists) {
      List followingList = currentUserDoc['following'] ?? [];
      setState(() {
        isFollowing = followingList.contains(widget.userId);
      });
    }
  }

  void followUser() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(currentUserId)
        .update({
      'following': FieldValue.arrayUnion([widget.userId]),
    });
    setState(() {
      isFollowing = true; // Update the state after following
    });
  }

  void unfollowUser() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(currentUserId)
        .update({
      'following': FieldValue.arrayRemove([widget.userId]),
    });
    setState(() {
      isFollowing = false; // Update the state after unfollowing
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(primaryColor),
      ),
      onPressed: isFollowing ? unfollowUser : followUser,
      child: Text(
        isFollowing ? 'Following' : 'Follow',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
