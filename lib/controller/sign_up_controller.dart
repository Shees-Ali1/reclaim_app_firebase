import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../Auth/signup_profile_pic.dart';
import '../Auth/verification.dart';
import 'home_controller.dart';
import 'user_controller.dart';

class SignUpController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  // New fields for address
  var selectedEmirate = 'Dubai'.obs; // Default to Dubai as per your request
  var selectedCity = ''.obs;
  final poBoxController = TextEditingController();

  // Emirates and their cities, including remote and outer areas
  final Map<String, List<String>> emirateCities = {
    'Dubai': [
      'Downtown Dubai',
      'Dubai Marina',
      'Jumeirah',
      'Deira',
      'Bur Dubai',
      'Palm Jumeirah',
      'Business Bay',
      'Hatta', // From outerAreas: DXB-Hatta
      'Nazwa', // From outerAreas: DXB-Nazwa
    ],
    'Abu Dhabi': [
      'Abu Dhabi City',
      'Al Ain',
      'Al Dhafra',
      'Yas Island',
      'Saadiyat Island',
      'Ghayathi', // From remoteAreas
      'Bad Al Matawa', // From remoteAreas
      'Al Nadra', // From remoteAreas
      'Baraka', // From remoteAreas (assuming Barakah)
      'Al Sila', // From remoteAreas
      'Madinat Zayed', // From remoteAreas
      'Habshan', // From remoteAreas
      'Bainuana', // From remoteAreas
      'Liwa', // From remoteAreas
      'Asab', // From remoteAreas
      'Hameem', // From remoteAreas
      'Ruwais', // From remoteAreas
      'Mirfa', // From remoteAreas
      'Abu Al Bayad', // From remoteAreas
      'Jabel Al Dhani', // From remoteAreas (assuming Jebel Dhanna)
      'Sweihan', // From outerAreas: Sawehan (corrected spelling)
      'Al Qua', // From outerAreas
      'Al Wagan', // From outerAreas
    ],
    'Sharjah': [
      'Sharjah City',
      'Khor Fakkan',
      'Kalba',
      'Al Dhaid',
      'Lehbab', // From outerAreas: SHJ-Lehbab
      'Madam', // From outerAreas: SHJ-Madam
      'Al Dahra', // From outerAreas (assuming Al Dhaid variant)
    ],
    'Ajman': [
      'Ajman City',
      'Masfout', // Also in outerAreas: AJM-Masfout
      'Manama',
    ],
    'Umm Al Quwain': [
      'Umm Al Quwain City',
      'Falaj Al Mualla',
    ],
    'Ras Al Khaimah': [
      'Ras Al Khaimah City',
      'Al Hamra', // Also in remoteAreas
      'Al Nakheel',
      'Jebel Jais',
      'Wadi Al Shiji', // From outerAreas: RAK-Wadi Al Shiji
      'Al Shawka', // From outerAreas: RAK-Al Shawka
    ],
    'Fujairah': [
      'Fujairah City',
      'Dibba Al Fujairah',
      'Al Aqah',
    ],
  };
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
    passwordController.addListener(() {
      String inputText = passwordController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        passwordController.clear();
        Get.snackbar('Error', 'Your message contains inappropriate content'); // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });
    nameController.addListener(() {
      String inputText = nameController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        nameController.clear();
        Get.snackbar('Error', 'Your message contains inappropriate content'); // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });
    emailController.addListener(() {
      String inputText = emailController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        emailController.clear();
        Get.snackbar('Error', 'Your message contains inappropriate content'); // Clear the text field if restricted word is found
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
    passwordController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
  final UserController userController = Get.put(UserController());
  final HomeController homeController = Get.put(HomeController());
  RxBool isChecked = false.obs;
  RxBool isLoading = false.obs;
  Future<void> sendEmailMessage(
      String toEmail, String subject, String message) async {
    try {
      final smtpServer =
          gmail('attaulmohiman112@gmail.com', 'jnjc bcje rnol qtfz');
      final messageToSend = Message()
        ..from = const Address('attaulmohiman112@gmail.com', 'Creek')
        ..recipients.add(toEmail)
        ..subject = subject
        ..text = message;

      await send(messageToSend, smtpServer);
      Get.to(Verification(
        email: toEmail,
      ));
      print("email sent");
    } catch (e) {
      Get.snackbar("Error", " Connection failed");
      print('Error sending email: $e');
    }
  }

  int generateRandomNumber() {
    Random random = Random();
    return random.nextInt(9000) +
        1000; // Generates a number between 100000 and 999999
  }

  Future<void> sentCodeEmail() async {
    try {
      if (emailController.text.isEmpty ||
          nameController.text.isEmpty ||
          passwordController.text.isEmpty||
      selectedEmirate.isEmpty||selectedCity.isEmpty||poBoxController.text.isEmpty) {

        Get.snackbar("Error", "Please Enter All Fields.");
      } else {
        isLoading.value = true;

        // Generate a random number
        int randomCode = generateRandomNumber();

        print('Generated Code: $randomCode');

        // Check if email already exists in the collection
        QuerySnapshot<Map<String, dynamic>> existingEmail =
            await FirebaseFirestore.instance
                .collection('verifyEmailCodes')
                .where('email', isEqualTo: emailController.text)
                .get();

        if (existingEmail.docs.isNotEmpty) {
          // If email exists, update the code for the existing document
          await existingEmail.docs.first.reference.update({
            'code': randomCode,
            'timeStamp': FieldValue.serverTimestamp(),
          });
        } else {
          // If email doesn't exist, add a new document
          await FirebaseFirestore.instance.collection('verifyEmailCodes').add({
            'email': emailController.text.trim(),
            'code': randomCode,
            'timeStamp': FieldValue.serverTimestamp(),
          });
        }

        // Send email message
        await sendEmailMessage(emailController.text, 'Password Reset Code',
            'Your verification code is: $randomCode');
        isLoading.value = false;
      }
    } on FirebaseAuthException catch (e) {
      print("Password reset error: ${e.message}");
    }
  }

  Future<void> verifyOtp(TextEditingController controller, String email) async {
    try {
      isLoading.value = true;

      String enteredOtp = controller.text;

      // Retrieve the stored OTP from Firestore
      QuerySnapshot<Map<String, dynamic>> otpQuery = await FirebaseFirestore
          .instance
          .collection('verifyEmailCodes')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (otpQuery.docs.isNotEmpty) {
        String storedOtp = otpQuery.docs.first['code'].toString();

        if (enteredOtp == storedOtp) {
          // Delete the OTP entry from Firestore
          await FirebaseFirestore.instance
              .collection('verifyEmailCodes')
              .doc(otpQuery.docs.first.id)
              .delete();
          await signupuser(email, passwordController.text);

          print('verified');
        } else {
          // Handle incorrect OTP
          Get.snackbar("Error", "Incorrect OTP");
          isLoading.value = false;

          print('Incorrect OTP');
        }
        isLoading.value = false;
      } else {
        Get.back();

        // Handle missing OTP entry in Firestore
        Get.snackbar("Error", "OTP not found");
        print('OTP not found');
        isLoading.value = false;
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signupuser(String email, String password) async {
    try {
      UserCredential userId = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await storeUserData(userId.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.back();

        Get.snackbar(
            "Error", "The email address is already in use by another account.");
      } else if (e.code == "weak-password") {
        Get.back();

        Get.snackbar("Weak Password",
            "Password must be greater than 6 characters and contains numbers & alphabets");
      } else {
        Get.back();

        print('error auth $e');
        Get.snackbar("Error", "${e.code}");
      }
    } catch (e) {
      print("Error signing $e");
    }
  }

  Future<void> storeUserData(String userId) async {
    try {
      // Combine address components into a single string
      String fullAddress = [
        selectedEmirate.value,
        selectedCity.value,
        if (poBoxController.text.isNotEmpty) 'P.O. Box: ${poBoxController.text}'
      ].where((element) => element.isNotEmpty).join(', ');

      await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(userId)
          .set({
        'userId': userId,
        'userName': nameController.text,
        'userPassword': passwordController.text, // Note: Storing passwords in plain text is not recommended
        'userEmail': emailController.text,
        'Address': fullAddress, // Store the combined address here
        'following': [],
        'userImage': '',
        'userPurchases': []
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance.collection('wallet').doc(userId).set({
        'balance': 0,
        'userId': userId,
      }, SetOptions(merge: true));

      userController.userName.value = nameController.text;
      passwordController.clear();
      nameController.clear();
      emailController.clear();
      poBoxController.clear();

      // Reset observable address fields
      selectedEmirate.value = 'Dubai'; // Reset to default
      selectedCity.value = '';
      Get.offAll(SignupProfilePic());
    } catch (e) {
      print("Error storing user data $e");
    }
  }

  Future<String> uploadImage(String userId) async {
    try {
      isLoading.value = true;

      // Get a reference to the Firebase Storage location
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg'); // You can customize the file name as needed

      // Upload the image
      UploadTask uploadTask =
          storageReference.putFile(userController.imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      isLoading.value = false;

      return imageUrl;
    } catch (e) {
      isLoading.value = false;

      print('Error uploading image to Firebase Storage: $e');
      throw e;
    }
  }
}
