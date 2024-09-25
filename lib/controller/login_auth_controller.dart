import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Auth/login_view.dart';
import '../helper/loading.dart';
import '../view/nav_bar/app_nav_bar.dart';
import '../view/on_boarding/on_boarding_screens.dart';
import 'sign_up_controller.dart';

class LoginAuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  List<String> restrictedWords = [
    'fuck', 'fed', 'fing', 'shit', 'bitch', 'asshole', 'cunt', 'dick', 'dickhead', 'pussy',
    'motherfucker', 'tit', 'sex', 'porn', 'nudes', 'erotic', 'strip', 'masturbation', 'horny',
    'lustful', 'nsfw', 'xxx', 'kill', 'murder', 'rape', 'stab', 'slaughter', 'torture',
    'bomb', 'terrorist', 'assault', 'abuse', 'nigger', 'faggot', 'retard', 'bitch', 'slut',
    'cunt', 'racist slur', 'homophobic slur', 'islamophobic', 'anti-semitic', 'xenophobic slur',
    'transphobic slur', 'cocaine', 'heroin', 'meth', 'weed', 'marijuana', 'high', 'junkie',
    'dealer', 'stoned', 'ecstasy', 'lsd', 'scammer', 'cheat', 'fraud', 'bullshit', 'douche', 'thief'
  ];

  RxString errorText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      String inputText = emailController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        emailController.clear();
        Get.snackbar('Error', 'Your message contains inappropriate content'); // Clear the text field if restricted word is found
        // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });
    passwordController.addListener(() {
      String inputText = passwordController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        passwordController.clear();
        Get.snackbar('Error', 'Your message contains inappropriate content'); // Clear the text field if restricted word is found
        // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });
  }
  // Method to check for restricted words
  bool _containsRestrictedWords(String text) {
    for (var word in restrictedWords) {
      if (text.toLowerCase().contains(word.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  final SignUpController signUpController = Get.find<SignUpController>();
  RxBool loginObscure = false.obs;

  void eyeIconLogin() {
    loginObscure.value = !loginObscure.value;
  }

  void loginUser() async {
    try {
      signUpController.isLoading.value = true;

      if (emailController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty) {
        signUpController.isLoading.value = false;

        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      if (FirebaseAuth.instance.currentUser!.uid != null) {
        // SharedPreferences prefs  = await SharedPreferences.getInstance();
        // await prefs.setString('email', emailController.text);
        // await prefs.setString('password', passwordController.text);
      await  userController.fetchUserData();
        // await homeController.fetchAllListings();
        await productsListingController.fetchUserProductListing();
        await userController.checkForProfileUpdate(FirebaseAuth.instance.currentUser!.uid);
        await userController.checkIfAccountIsDeleted();
        await  wishlistController.fetchuserwallet();
        Get.snackbar('Success', 'Login Success');
      signUpController.isLoading.value = false;


        Get.offAll(const BottomNavBar());
        emailController.clear();
        passwordController.clear();

      } else {
        signUpController.isLoading.value = false;

        Get.snackbar("Error", "Incorrect OTP");
      }
    } on FirebaseAuthException catch (e) {
      signUpController.isLoading.value = false;
      if (e.code == 'user-not-found') {
        Get.snackbar("Error", "No user found for that email.");
        signUpController.isLoading.value = false;

      } else if (e.code == 'invalid-credential') {

        Get.snackbar("Error", "Wrong password provided for that user.");
        signUpController.isLoading.value = false;


      } else {
        Get.snackbar("Error", "Login failed. Error code: ${e.code}");
        signUpController.isLoading.value = false;

      }
    } catch (e) {
      signUpController.isLoading.value = false;

      print('Error Login Failed $e');
    }
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.snackbar('Success', 'You have been logout');
      Get.offAll(const LoginView());
    } catch (e) {
      print('Error Logout Failed $e');
    }
  }

  void checkUserLogin() async {
    try {
      if (FirebaseAuth.instance.currentUser?.uid != null) {

        Get.offAll(BottomNavBar());
      } else {
        Get.offAll(OnBoarding());
      }
    } catch (e) {
      print("User is not login $e");
    }
  }
  RxBool isLoading = false.obs;

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future<void> handleGoogleSignIn() async {
    try {
      isLoading.value = true;
      final auth = FirebaseAuth.instance;
      final _firestore = FirebaseFirestore.instance; // Initialize Firestore

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // Handle null Google user
        return;
      }
      // Obtain the auth details from the request.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create a new credential.
      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Sign in to Firebase with the Google [UserCredential].
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(googleCredential);

      final user = userCredential.user!;
      final uid = user.uid;


      // Check if the user already exists in the Firestore collection
      final userDoc = await _firestore.collection('userDetails').doc(uid).get();
      if (!userDoc.exists) {
        // User does not exist in the collection, proceed to store their data
        String? uName = user.displayName;
        String? uEmail = user.email;
        String? uPhoto = user.photoURL;
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await FirebaseFirestore.instance
              .collection('userDetails')
              .doc(user.uid)
              .set({
            'fcmToken': fcmToken,
          },SetOptions(merge: true));
        }
        // if (uPhoto != null) {
        //   print('Photo URL: $uPhoto');
        // } else {
        //   print('Photo URL not available');
        // }
        // if (uName != null) {
        //   print('Google user name: $uName');
        // } else {
        //   print('Google user name not available');
        // }
        // if (uEmail != null) {
        //   print('uEmail : $uEmail');
        // } else {
        //   print('uEmail not available');
        // }

        // Store user data in Firestore
        await _firestore.collection('userDetails').doc(uid).set({
          'userId': uid,
          'userEmail': uEmail,
          'userImage': uPhoto,
          'userName': uName,
          // 'verified': false,
          'userPurchases':[],
          'following':[],
          // 'userSchool':'Harker',
          "userPassword":'',

        },SetOptions(merge: true));
        // await FirebaseFirestore.instance.collection('wallet').doc(uid).set(
        //     {
        //       'balance':0,
        //       'userId':uid,
        //     },SetOptions(merge: true));
        // _authController.signupName.value = uName!;
        // _authController.signupEmail.value = uEmail!;
        // _authController.profileURL.value = uPhoto!;
        // _authController.fromLogin.value = true;
        // Navigator.of(context).pop();
        // Get.offAll(const MainAuthProgressScreen());
    Get.snackbar('Welcome', 'Welcome Back');

        Get.back();
        // Proceed with navigation or other actions
        Get.offAll(BottomNavBar());


      } else {
        Get.back();
        // Proceed with navigation or other actions
        Get.offAll(BottomNavBar());
      }
    } catch (e) {
      print("error sign in with googleee $e");
    }finally {
      isLoading.value = false;
    }
  }
}
