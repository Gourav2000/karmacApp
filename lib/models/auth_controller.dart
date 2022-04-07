import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karmac/screens/otp_screen_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends GetxController {
  RxBool isLoading = false.obs;
  String? verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final form = GlobalKey<FormState>();
  var phoneDetails = '';

  Future<void> save(BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneDetails',
      timeout: Duration(seconds: 45),
      verificationCompleted: (phoneAuthCredential) async {},
      verificationFailed: (FirebaseAuthException exception) async {
        isLoading.value = false;
        print(exception.message);
      },
      codeSent: (String verificationId, int? resendingToken) async {
        this.verificationId = verificationId;
        Get.to(() => OTPScreen())?.then((value) => isLoading.value = false);
      },
      codeAutoRetrievalTimeout: (String timeout) async {
        return null;
      },
    );
  }

  Future<String?> signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential, BuildContext context) async {
    isLoading.value = true;

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      isLoading.value = false;

      if (authCredential.user != null) {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      print(e);
      return e.message.toString();
    }
  }

  Future<void> saveForm(BuildContext context) async {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    isLoading.value = true;
    form.currentState!.save();
    try {
      await save(context);
    } catch (error) {
      var message = 'Could not authenticate you. Please try again later!!';
      print(error);
    }
  }

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
