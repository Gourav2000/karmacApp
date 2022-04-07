import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../models/auth_controller.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PhoneAuthScreen extends StatelessWidget {
  static const String routeName = '/phone_auth_screen';
  Auth _auth = Get.put(Auth());
  TextEditingController phoneNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.grey.shade400,
        ),
      ),
      body: Form(
        key: _auth.form,
        child: SingleChildScrollView(
          child: Container(
            height: height,
            width: Get.width,
            child: Column(
              children: [
                Container(
                  height: height * 0.5,
                  width: Get.width,
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.5 * 0.3,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        child: AutoSizeText(
                          'Enter Phone number for Verification',
                          style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 35,
                          ),
                        ),
                      ),
                      Container(
                        height: height * 0.5 * 0.3,
                        padding: const EdgeInsets.all(15),
                        child: AutoSizeText(
                          'This number will be used for all service related communication you shall recieve an SMS with code verification',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Colors.lightGreen,
                            ),
                          ),
                          child: TextFormField(
                            controller: phoneNo,
                            keyboardType: TextInputType.phone,
                            onSaved: (val) {
                              _auth.phoneDetails = val.toString().trim();
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              prefix: Text(
                                '+91 ',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 20,
                                ),
                              ),
                              border: InputBorder.none,
                              hintText: 'Enter your phone number',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 0.5,
                  width: Get.width,
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                            ),
                            child: Obx(
                              () => _auth.isLoading.value
                                  ? Container(
                                      height: 20,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Send OTP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                            ),
                          ),
                          onPressed: () {
                            Get.showOverlay(
                              asyncFunction: () async {
                                await _auth.saveForm(context);
                              },
                              loadingWidget: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.lightGreen,
                                ),
                              ),
                            );
                          },
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
