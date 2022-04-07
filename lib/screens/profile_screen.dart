import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:karmac/auth.config.dart';
import 'package:karmac/models/profile_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:karmac/screens/email_otp_screen.dart';
import 'package:email_auth/email_auth.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/progile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());
  RxBool emailVerified = false.obs;
  TextEditingController email = TextEditingController();
  TextEditingController phn = TextEditingController();
  TextEditingController name = TextEditingController();
  late EmailAuth emailAuth;
  RxString imageUrl = ''.obs;
  RxString verifiedEmail = ''.obs;
  RxString verifiedNumber = ''.obs;
  RxString nameField = ''.obs;

  @override
  void initState() {
    super.initState();
    if (profileController.profileDetails['email'] != null) {
      email.text = profileController.profileDetails['email'].toString();
      verifiedEmail.value =
          profileController.profileDetails['email'].toString();
    }
    if (profileController.profileDetails['phoneNo'] != null) {
      phn.text = profileController.profileDetails['phoneNo'].toString();
      verifiedNumber.value =
          profileController.profileDetails['phoneNo'].toString();
    }
    emailAuth = new EmailAuth(
      sessionName: 'Karmac',
    );
    emailAuth.config(remoteServerConfiguration);
  }

  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
      recipientMail: email.text.trim(),
      otpLength: 5,
    );
    if (result) {
      print('email sent');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        title: Text(
          'Profile Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Form(
            key: profileController.form,
            child: Container(
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(children: [
                    CircleAvatar(
                      radius: 75,
                      foregroundImage: NetworkImage(imageUrl.value == ''
                          ? 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'
                          : imageUrl.value.toString()),
                      backgroundImage: NetworkImage(
                          'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                      backgroundColor: Colors.grey.shade400,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border: Border.all(
                              width: 1,
                              color: Colors.blue,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.lightGreen,
                            size: 20,
                          ),
                        ),
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          String option = '';
                          await Get.defaultDialog(
                            title: 'Choose an option',
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    option = 'camera';
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.camera_alt),
                                      Text('Camera'),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    option = 'gallery';
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.image),
                                      Text('Gallery'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).then((value) async {
                            if (option != '') {
                              File image;
                              XFile? photo;
                              if (option == 'camera') {
                                photo = await _picker.pickImage(
                                    source: ImageSource.camera);
                              } else {
                                photo = await _picker.pickImage(
                                    source: ImageSource.gallery);
                              }
                              if (photo != null) {
                                image = File(photo.path);
                                final ref = FirebaseStorage.instance
                                    .ref()
                                    .child('Chat')
                                    .child(
                                        FirebaseAuth.instance.currentUser!.uid +
                                            '.jpg');

                                await ref.putFile(image);
                                final String url = await ref.getDownloadURL();
                                imageUrl.value = url;
                                profileController.profileDetails['imageUrl'] =
                                    url;
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade900,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.lightGreen,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Obx(
                            () => Expanded(
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                enabled: FirebaseAuth.instance.currentUser!
                                            .phoneNumber ==
                                        null
                                    ? true
                                    : false,
                                controller: phn,
                                decoration: InputDecoration(
                                  hintText: 'Enter Your Phone No.',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  border: InputBorder.none,
                                  suffix: verifiedNumber.value ==
                                          profileController
                                              .profileDetails['phoneNo']
                                      ? FaIcon(
                                          FontAwesomeIcons.checkCircle,
                                          color: Colors.lightGreen,
                                        )
                                      : phn.text == ''
                                          ? null
                                          : InkWell(
                                              onTap: () {},
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                  left: 8,
                                                  right: 8,
                                                  top: 4,
                                                  bottom: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade800,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: AutoSizeText(
                                                  'verify',
                                                  minFontSize: 1,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors
                                                          .lightGreenAccent
                                                          .shade400,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ),
                                ),
                                onFieldSubmitted: (val) {
                                  profileController.profileDetails['phoneNo'] =
                                      val.toString();
                                },
                                onSaved: (val) {
                                  profileController.profileDetails['phoneNo'] =
                                      val.toString();
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (val) {
                                  if (val == null) {
                                    return 'Please enter your phone number';
                                  }
                                  if (val.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  if (val.length != 10) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade900,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.lightGreen,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Obx(
                            () => Expanded(
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller: name,
                                decoration: InputDecoration(
                                  hintText: 'Enter Your Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  border: InputBorder.none,
                                  suffix: nameField.value != ''
                                      ? FaIcon(
                                          FontAwesomeIcons.checkCircle,
                                          color: Colors.lightGreen,
                                        )
                                      : null,
                                ),
                                onFieldSubmitted: (val) {
                                  profileController.profileDetails['name'] =
                                      val.toString();
                                  nameField.value = val;
                                },
                                onSaved: (val) {
                                  profileController.profileDetails['name'] =
                                      val.toString();
                                },
                                onChanged: (val) {
                                  profileController.profileDetails['name'] =
                                      val.toString();

                                  nameField.value = val;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (val) {
                                  if (val == null) {
                                    return 'Please enter your name';
                                  }
                                  if (val.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade900,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail,
                            color: Colors.lightGreen,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Obx(
                            () => Expanded(
                              child: TextFormField(
                                controller: email,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                enabled:
                                    FirebaseAuth.instance.currentUser!.email ==
                                            null
                                        ? true
                                        : false,
                                decoration: InputDecoration(
                                  hintText: 'Enter email address',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  border: InputBorder.none,
                                  suffix: verifiedEmail.value ==
                                          profileController
                                              .profileDetails['email']
                                      ? FaIcon(
                                          FontAwesomeIcons.checkCircle,
                                          color: Colors.lightGreen,
                                        )
                                      : email.text == ''
                                          ? null
                                          : InkWell(
                                              onTap: () {
                                                /*sendOtp();
                                                Get.to(() => EmailOTPScreen(),
                                                        arguments: email.text)
                                                    ?.then((value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      emailVerified.value =
                                                          value;
                                                    });
                                                    if (value == true) {
                                                      verifiedEmail.value =
                                                          email.text;
                                                    }
                                                  }
                                                });*/
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                  left: 8,
                                                  right: 8,
                                                  top: 4,
                                                  bottom: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade800,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: AutoSizeText(
                                                  'verify',
                                                  minFontSize: 1,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors
                                                          .lightGreenAccent
                                                          .shade400,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ),
                                ),
                                onFieldSubmitted: (val) {
                                  profileController.profileDetails['email'] =
                                      val.toString();
                                },
                                onSaved: (val) {
                                  profileController.profileDetails['email'] =
                                      val.toString();
                                },
                                onChanged: (val) {
                                  profileController.profileDetails['email'] =
                                      val.toString();
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (val) {
                                  if (val == null) {
                                    return 'Please enter your email';
                                  }
                                  if (val.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!val.contains('@') ||
                                      !val.contains('.')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                      right: 25,
                      left: 25,
                    ),
                    child: Text(
                      'The entered email id will be used for authentication and accessing updates made by the admin',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 25,
                      left: 25,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => TextButton(
                                child: profileController.isLoading.value
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'NEXT',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                onPressed: () {
                                  profileController.saveForm(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
