import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';


import '../Auth/login_view.dart';
import 'home_controller.dart';

class UserController extends GetxController {
  RxString userName = ''.obs;
  RxString userImage = ''.obs;
  RxString userEmail = ''.obs;
  RxString userSchool = ''.obs;
  RxString userPassword = ''.obs;
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  RxBool isLoading = false.obs;
  RxBool verified = false.obs;

  RxList<dynamic> userPurchases = [].obs;
  final HomeController homeController = Get.put(HomeController());
  File? imageFile;
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
    }
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value =true;
      if (FirebaseAuth.instance.currentUser != null) {
        // Reference to the users collection
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('userDetails');

        // Query to get the document with the specified UID
        DocumentSnapshot userInfo = await usersCollection
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (userInfo.exists) {
          userPurchases.clear();
          userName.value = userInfo["userName"] ?? "";
          userEmail.value = userInfo["userEmail"] ?? "";
          verified.value = userInfo["verified"] ?? false;
          userPurchases.value = userInfo['userPurchases'];

          homeController.classOption.value = userInfo["userSchool"] ?? "";
          userPassword.value = userInfo['userPassword'];

          userImage.value = userInfo["userImage"] ?? "";

          print(  homeController.classOption.value);
          update();
        } else {
          // User not found
        }
      } else {
        print("User not login");
      }
      isLoading.value =false;

    } catch (e) {
      print('Error fetching user data: $e');
      isLoading.value =false;

    } finally {
      update();
    }
  }

  // Future<void> profileUpdate(TextEditingController nameController) async {
  //   try {
  //     isLoading.value = true;
  //     await FirebaseFirestore.instance
  //         .collection('userDetails')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update({
  //       'userName': nameController.text.trim(),
  //       'userSchool': homeController.classOption.value,
  //     });
  //     if (imageFile != null) {
  //       String img =
  //           await updateUserImage(FirebaseAuth.instance.currentUser!.uid);
  //       await FirebaseFirestore.instance
  //           .collection('userDetails')
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .update({'userImage': img});
  //       userImage.value = img;
  //     }
  //     userName.value = nameController.text;
  //
  //     Get.back();
  //     Get.back();
  //     isLoading.value = false;
  //   } catch (e) {
  //     print('Error Updateing Profile $e');
  //   }
  // }
  Future<void> approveProfileUpdate(String userId) async {
    try {
      // Get pending updates
      DocumentSnapshot pendingUpdates = await FirebaseFirestore.instance
          .collection('pendingUserUpdates')
          .doc(userId)
          .get();
      if (pendingUpdates.exists) {
        Map<String, dynamic> update =
            pendingUpdates.data() as Map<String, dynamic>;
        bool approval = update['pendingApproval'];
        if (approval == true) {
          await FirebaseFirestore.instance
              .collection('userDetails')
              .doc(userId)
              .update(
            {
              'userName': update['pendingUserName'],
              'userSchool':update['pendinguserSchool']

            },
          );
          if (update.containsKey('pendingUserImage') &&
              update['pendingUserImage'] != '') {
            await FirebaseFirestore.instance
                .collection('userDetails')
                .doc(userId)
                .update(
              {
                'userImage': update['pendingUserImage'],

              },
            );
          }

          // Remove the pending updates after approval
          await FirebaseFirestore.instance
              .collection('pendingUserUpdates')
              .doc(userId)
              .delete();
        }
      }
    } catch (e) {
      print('Error Approving Profile Update $e');
    }
  }

  Future<void> profileUpdate(TextEditingController nameController) async {
    try {
      isLoading.value = true;
      // Save pending changes for approval
      await FirebaseFirestore.instance
          .collection('pendingUserUpdates')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'pendingUserName': nameController.text.trim(),
        'pendinguserSchool': homeController.classOption.value,


        'pendingApproval': false, // Mark for approval
        'timestamp': FieldValue.serverTimestamp(),
      });

      // If there's an image, add it to the pending updates as well
      if (imageFile != null) {
        String img =
            await updateUserImage(FirebaseAuth.instance.currentUser!.uid);
        await FirebaseFirestore.instance
            .collection('pendingUserUpdates')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'pendingUserImage': img});
      }
      Get.back();
      Get.back();



      isLoading.value = false;
    } catch (e) {
      print('Error Updating Profile $e');
      isLoading.value = false;
    }
  }

  Future<String> updateUserImage(String userId) async {
    try {
      isLoading.value = true;

      // Get a reference to the Firebase Storage location
      Reference storageReference = await FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg'); // You can customize the file name as needed

      // Upload the image
      UploadTask uploadTask = storageReference.putFile(imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      isLoading.value = false;

      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      throw e;
    }
  }

//   ************Get user history sell
  RxInt saleSum = 0.obs;

  Future<void> getSellHistory() async {
    try {
      QuerySnapshot orderData = await FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (orderData.docs.isNotEmpty) {
        saleSum.value = orderData.docs.length;
        print('total sale $saleSum');
      } else {
        print("NO orders or data");
      }
    } catch (e) {
      print("error fetchnig user sale history");
    }
  }
//   List<dynamic> bookId = [];
//   List<dynamic> booksSale = [];
//   Future<void> getSellHistory() async {
//     try {
//       bookId.clear();
//       booksSale.clear();
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('booksListing')
//           .where('sellerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//           .get();
//       if (querySnapshot.docs.isNotEmpty) {
//         querySnapshot.docs.forEach((booksList) async {
//           bookId.add(booksList['listingId']);
//         });
//         bookId.forEach((ids) async {
//           QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//               .collection('booksListing')
//               .doc(ids)
//               .collection('orders')
//               .get();
//           if (querySnapshot.docs.isNotEmpty) {
//             // print(querySnapshot.docs.length);
//             booksSale.add(querySnapshot.docs.length);
//             print(booksSale);
//             saleSum.value = booksSale.reduce((a, b) => a + b);
//             update();
//           } else {
//             print('no orders');
//           }
//         });
//       } else {
//         print('no listing or seller listing found');
//       }
//     } catch (e) {
//       print("error getting sales $e");
//     }
//   }

  Future<void> changePassword(TextEditingController password) async {
    try {
      isLoading.value = true;
      final AuthCredential credential = EmailAuthProvider.credential(
        email: userEmail.value,
        password: userPassword.value,
      );

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return;
      }

      UserCredential reauthenticatedUser =
          await currentUser.reauthenticateWithCredential(credential);

      User? user = reauthenticatedUser.user;
      if (user == null) {
        return;
      }

      await user.updatePassword(password.text);
      await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(user.uid)
          .update({
        'userPassword': password.text,
      });
      // await FirebaseAuth.instance.signOut();
      isLoading.value = false;
      Get.snackbar("Success", "Password updated successfully");
    } catch (error) {
      print('Error updating password');
    }
  }

  Future<void> deleteAccont() async {
    try {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: userEmail.value,
        password: userPassword.value,
      );

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return;
      }

      UserCredential reauthenticatedUser =
          await currentUser.reauthenticateWithCredential(credential);

      User? user = reauthenticatedUser.user;
      if (user == null) {
        return;
      }
      await FirebaseAuth.instance.currentUser?.delete();
      Get.offAll(LoginView());
    } catch (e) {
      print('Error Deleting Account$e');
    }
  }

  checkIfAccountIsDeleted() async {
    try {
      IdTokenResult? idTokenResult =
          await FirebaseAuth.instance.currentUser?.getIdTokenResult(true);

      if (idTokenResult == null || idTokenResult.token == null) {
        print("User is deleted");
        await FirebaseAuth.instance.signOut();
        Get.offAll(LoginView());
        // do logout stuff here...
      } else {
        print("User is available");
      }
    } catch (er) {
      print("User is deleted");
      // await FirebaseAuth.instance.signOut();
      // Get.offAll(LoginView());
    }
  }

  // // *****************Check if user online
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  // void updateUserPresence(bool isOnline) async {
  //   try {
  //     User? user = _auth.currentUser;
  //     if (user != null) {
  //       DocumentReference userRef =
  //           _firestore.collection('userDetails').doc(user.uid);
  //       await userRef.update({'online': isOnline});
  //       print("USer online status $isOnline");
  //     }
  //   } catch (e) {
  //     print('Error updating user presence: $e');
  //   }
  // }

  String? token;

  Future<void> getDeviceStoreToken() async {
    try {
      if (Platform.isIOS) {
        token = await FirebaseMessaging.instance.getAPNSToken();
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseFirestore.instance
              .collection('userDetails')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({'fcmToken': token}, SetOptions(merge: true));
        }
      } else if (Platform.isAndroid) {
        token = await FirebaseMessaging.instance.getToken();
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseFirestore.instance
              .collection('userDetails')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({'fcmToken': token}, SetOptions(merge: true));
        }
      }
    } catch (e) {
      print('Error Storing token');
    }
  }
  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   approveProfileUpdate(FirebaseAuth.instance.currentUser!.uid);
  //   fetchUserData();
  //   checkIfAccountIsDeleted();
  //
  // }
}
