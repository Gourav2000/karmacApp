import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_controller.dart';
import '../models/edit_profile_controller.dart';
import 'dart:io';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserController userController = Get.put(UserController());
  EditProfileController editProfileController =
      Get.put(EditProfileController());
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = userController.userDetails!.name.toString();
    phoneNumber.text = userController.userDetails!.phoneNumber.toString();
    email.text = userController.userDetails!.email.toString();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 26, 26, 1),
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.lightGreen,
        ),
      ),
      body: Obx(
        () => userController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  height: height,
                  child: ListView(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: Get.width,
                            height: height * 0.35,
                            color: Colors.black,
                          ),
                          Positioned(
                            top: 0,
                            child: Container(
                              width: Get.width,
                              height: height * 0.35,
                              alignment: Alignment.center,
                              child: Stack(children: [
                                CircleAvatar(
                                  radius: height * 0.35 * 0.5 * 0.7,
                                  foregroundImage: NetworkImage(FirebaseAuth
                                      .instance.currentUser!.photoURL
                                      .toString()),
                                  backgroundImage: NetworkImage(
                                      'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                                  backgroundColor: Colors.grey.shade400,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 15,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.green,
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

                                      Get.bottomSheet(
                                        Container(
                                          //height: Get.height*0.2,
                                          //margin: EdgeInsets.only(left: 5,right: 5),

                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade900,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                                          ),
                                          child: Padding(
                                            padding:  EdgeInsets.only(top: Get.height*0.05,bottom:Get.height*0.05 ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(

                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Container(

                                                            child: Padding(
                                                              padding:  EdgeInsets.all(8),
                                                              child: Icon(Icons.camera,color: Colors.white,),
                                                            ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.lightGreen,
                                                            shape: BoxShape.circle
                                                          ),

                                                        ),

                                                        Padding(
                                                          padding:  EdgeInsets.only(left: 8.0),
                                                          child: Text('Camera',style: TextStyle(color: Colors.white,fontSize: 17.5),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: ()async{
                                                    File image;
                                                    XFile? photo;
                                                    photo = await _picker.pickImage(source: ImageSource.camera);
                                                    if (photo != null) {
                                                      image = File(photo.path);
                                                      final ref = FirebaseStorage.instance
                                                          .ref()
                                                          .child('Chat')
                                                          .child(FirebaseAuth.instance
                                                          .currentUser!.uid +
                                                          '.jpg');

                                                      await ref.putFile(image);
                                                      final String url =
                                                      await ref.getDownloadURL();
                                                    }
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                InkWell(

                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Container(

                                                          child: Padding(
                                                            padding:  EdgeInsets.all(8),
                                                            child: Icon(Icons.image,color: Colors.white,),
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color: Colors.lightGreen,
                                                              shape: BoxShape.circle
                                                          ),

                                                        ),

                                                        Padding(
                                                          padding:  EdgeInsets.only(left: 8.0),
                                                          child: Text('Gallery',style: TextStyle(color: Colors.white,fontSize: 17.5),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: ()async{
                                                    File image;
                                                    XFile? photo;
                                                    photo = await _picker.pickImage(source: ImageSource.gallery);
                                                    if (photo != null) {
                                                      image = File(photo.path);
                                                      final ref = FirebaseStorage.instance
                                                          .ref()
                                                          .child('Chat')
                                                          .child(FirebaseAuth.instance
                                                          .currentUser!.uid +
                                                          '.jpg');

                                                      await ref.putFile(image);
                                                      final String url =
                                                      await ref.getDownloadURL();
                                                    }
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      );

                                      // await Get.defaultDialog(
                                      //   title: 'Choose an option',
                                      //   content: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.spaceEvenly,
                                      //     children: [
                                      //       InkWell(
                                      //         onTap: () {
                                      //           Get.back();
                                      //           option = 'camera';
                                      //         },
                                      //         child: Column(
                                      //           children: [
                                      //             Icon(Icons.camera_alt),
                                      //             Text('Camera'),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //       InkWell(
                                      //         onTap: () {
                                      //           Get.back();
                                      //           option = 'gallery';
                                      //         },
                                      //         child: Column(
                                      //           children: [
                                      //             Icon(Icons.image),
                                      //             Text('Gallery'),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ).then((value) async {
                                      //   if (option != '') {
                                      //     File image;
                                      //     XFile? photo;
                                      //     if (option == 'camera') {
                                      //       photo = await _picker.pickImage(
                                      //           source: ImageSource.camera);
                                      //     } else {
                                      //       photo = await _picker.pickImage(
                                      //           source: ImageSource.gallery);
                                      //     }
                                      //     if (photo != null) {
                                      //       image = File(photo.path);
                                      //       final ref = FirebaseStorage.instance
                                      //           .ref()
                                      //           .child('Chat')
                                      //           .child(FirebaseAuth.instance
                                      //                   .currentUser!.uid +
                                      //               '.jpg');
                                      //
                                      //       await ref.putFile(image);
                                      //       final String url =
                                      //           await ref.getDownloadURL();
                                      //     }
                                      //   }
                                      // });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: Get.width,
                        height: height * 0.65 - 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: Get.width,
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: name,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter your name',
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Update',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey.shade400,
                                    height: 0,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: Get.width,
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mobile Number',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: phoneNumber,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            prefix: Text('+91-',style: TextStyle(color: Colors.white),),
                                            hintText:
                                                'Enter your mobile number',
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Update',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey.shade400,
                                    height: 0,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: Get.width,
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email ID',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: email,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter your email Id',
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Update',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.grey.shade600,height:0 )
                                ],

                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding:  EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Deactivate Account ',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(Icons.lock,color: Colors.white,)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
