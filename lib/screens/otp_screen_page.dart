import 'dart:async';

import 'package:flutter/material.dart';
import 'package:karmac/models/Otp_Controller.dart';
import 'package:karmac/screens/home_page.dart';
import 'package:karmac/widgets/BasicWidgets.dart';
import 'package:otp_screen/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import './profile_screen.dart';
import 'package:get/get.dart';
import '../models/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
class OTPScreen extends StatefulWidget {
  static const String routeName = '/otp_screen';
  const OTPScreen({Key? key}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  Auth _auth = Get.put(Auth());
  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
  TextEditingController textEditingController=TextEditingController();
  OtpController otpController = Get.put(OtpController());
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.grey.shade400,
        ),
      ),
      body:GetBuilder<OtpController>(
        builder:(otpController){
        return Container(
          color: Colors.black,
          height: height,
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              //crossAxisAlignment: CrossAxisAlignment.s,
              children: [
                SizedBox(height: height*0.05,),
                Row(children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_ios))
                ],),
                //SizedBox(height: height*0.111,),
                Text(
                  'Enter Your OTP',
                  style:
                  TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.bold,fontSize: height*0.03),
                ),
                Text(
                  '\nPlease enter the verification code',
                  style: TextStyle(color: Colors.grey.shade400,fontSize: 15),
                ),
                Text(
                  'sent to +91${_auth.phoneDetails}',
                  style: TextStyle(color: Colors.grey.shade400,fontSize: 15),
                ),
                SizedBox(height: height*0.1,),
                Padding(
                  padding:  EdgeInsets.only(left: width*0.05,right: width*0.05),
                  child:
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: height*0.06,
                        fieldWidth: width*0.125,
                        activeFillColor: Colors.black,
                        inactiveColor: Colors.lightGreen,
                        inactiveFillColor: Colors.black,
                        activeColor: Colors.lightGreen,
                        selectedColor: Colors.blue,
                        selectedFillColor: Colors.black
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.black,
                    enableActiveFill: true,
                    keyboardType: TextInputType.number,
                    textStyle: TextStyle(color: Colors.lightGreen),
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    onCompleted: (v) {
                      print("Completed");
                    },
                    onChanged: (value) {

                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return false;
                    }, appContext: context,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Spacer(),
                    Text('Did not Recieve Otp ?  ',style: TextStyle(color: Colors.blue),),
                    InkWell(
                        onTap: ()async{
                          if(otpController.enableResend==true.obs) {
                            await _auth.saveForm(context);
                            print('tapped');
                            otpController.timeCounterFunction(60);
                          }

                        },
                        child: Text('Resend OTP',style: TextStyle(color: otpController.enableResend==true.obs?Colors.blue:Colors.grey,decoration: otpController.enableResend==true.obs?TextDecoration.underline:TextDecoration.none),)),
                    otpController.enableResend==true.obs?Text(''):Text(' in ${otpController.timerCount} secs',style: TextStyle(color: Colors.blue),),
                    //Spacer()
                  ],
                ),
                SizedBox(height: height*0.07,),
                InkWell(
                  onTap: ()async{
                    if(textEditingController.text.length!=6)
                      errorController.add(ErrorAnimationType.shake);
                    else{
                      PhoneAuthCredential phoneAuthCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: _auth.verificationId.toString(),
                                  smsCode: textEditingController.text);

                          var res= await _auth.signInWithPhoneAuthCredential(
                              phoneAuthCredential, context);
                          if(FirebaseAuth.instance.currentUser!=null)
                            {
                              await FirebaseFirestore.instance
                                        .collection('Users')
                                        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                        .get()
                                        .then((value) {
                                      if (value.docs.isEmpty) {
                                        Get.offAll(() => ProfileScreen());
                                      } else {
                                        Get.offAll(() => HomePage());
                                      }
                                    });
                            }
                          else{
                            errorController.add(ErrorAnimationType.shake);
                            showError('Wrong Otp provided', context);
                          }
                    }
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashAfterRegister()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    height: height*0.055,
                    width: width*0.86,

                    child: Center(child: Text('Continue',style: TextStyle(color: Colors.white,fontSize: height*0.025,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ],
            ),
          ),
        );
        }
      ),





      // OtpScreen.withGradientBackground(
      //   otpLength: 6,
      //   subTitle: 'please enter the OTP sent to\n+91${_auth.phoneDetails}',
      //   validateOtp: (String otp) async {
      //     PhoneAuthCredential phoneAuthCredential =
      //         PhoneAuthProvider.credential(
      //             verificationId: _auth.verificationId.toString(),
      //             smsCode: otp);
      //
      //     return _auth.signInWithPhoneAuthCredential(
      //         phoneAuthCredential, context);
      //   },
      //   routeCallback: (context) async {
      //     if (FirebaseAuth.instance.currentUser != null) {
      //       await FirebaseFirestore.instance
      //           .collection('Users')
      //           .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      //           .get()
      //           .then((value) {
      //         if (value.docs.isEmpty) {
      //           Get.offAll(() => ProfileScreen());
      //         } else {
      //           Get.offAll(() => HomePage());
      //         }
      //       });
      //     }
      //   },
      //   titleColor: Colors.lightGreen,
      //   themeColor: Colors.grey.shade400,
      //   topColor: Colors.black,
      //   bottomColor: Colors.black,
      // ),
    );
  }
}



// class OTPScreen extends StatelessWidget {
//   static const String routeName = '/otp_screen';
//   Auth _auth = Get.put(Auth());
//   StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
//   TextEditingController textEditingController=TextEditingController();
//   OtpController otpController = Get.put(OtpController());
//   @override
//   Widget build(BuildContext context) {
//     double height=MediaQuery.of(context).size.height;
//     double width=MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         brightness: Brightness.dark,
//         iconTheme: IconThemeData(
//           color: Colors.grey.shade400,
//         ),
//       ),
//       body:Obx(
//         ()=> Container(
//           color: Colors.black,
//           height: height,
//           child: SingleChildScrollView(
//             child: Column(
//               //mainAxisAlignment: MainAxisAlignment.spaceAround,
//               //crossAxisAlignment: CrossAxisAlignment.s,
//               children: [
//                 SizedBox(height: height*0.05,),
//                 Row(children: [
//                   IconButton(onPressed: (){
//                     Navigator.pop(context);
//                   }, icon: Icon(Icons.arrow_back_ios))
//                 ],),
//                 //SizedBox(height: height*0.111,),
//                 Text(
//                   'Enter Your OTP',
//                   style:
//                   TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.bold,fontSize: height*0.03),
//                 ),
//                 Text(
//                   '\nPlease enter the verification code',
//                   style: TextStyle(color: Colors.grey.shade400,fontSize: 15),
//                 ),
//                 Text(
//                   'sent to +91${_auth.phoneDetails}',
//                   style: TextStyle(color: Colors.grey.shade400,fontSize: 15),
//                 ),
//                 SizedBox(height: height*0.1,),
//                 Padding(
//                   padding:  EdgeInsets.only(left: width*0.05,right: width*0.05),
//                   child:
//                   PinCodeTextField(
//                     length: 6,
//                     obscureText: false,
//                     animationType: AnimationType.fade,
//                     pinTheme: PinTheme(
//                         shape: PinCodeFieldShape.box,
//                         borderRadius: BorderRadius.circular(10),
//                         fieldHeight: height*0.06,
//                         fieldWidth: width*0.125,
//                         activeFillColor: Colors.black,
//                         inactiveColor: Colors.lightGreen,
//                         inactiveFillColor: Colors.black,
//                         activeColor: Colors.lightGreen,
//                         selectedColor: Colors.blue,
//                         selectedFillColor: Colors.black
//                     ),
//                     animationDuration: Duration(milliseconds: 300),
//                     backgroundColor: Colors.black,
//                     enableActiveFill: true,
//                     keyboardType: TextInputType.number,
//                     textStyle: TextStyle(color: Colors.lightGreen),
//                     errorAnimationController: errorController,
//                     controller: textEditingController,
//                     onCompleted: (v) {
//                       print("Completed");
//                     },
//                     onChanged: (value) {
//
//                     },
//                     beforeTextPaste: (text) {
//                       print("Allowing to paste $text");
//                       //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//                       //but you can show anything you want here, like your pop up saying wrong paste format or etc
//                       return false;
//                     }, appContext: context,
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     //Spacer(),
//                     Text('Did not Recieve Otp ?  ',style: TextStyle(color: Colors.blue),),
//                     InkWell(
//                         onTap: (){
//                           if(otpController.enableResend==true.obs) {
//                             print('tapped');
//                             otpController.timeCounterFunction(60);
//                           }
//
//                         },
//                         child: Text('Resend OTP',style: TextStyle(color: otpController.enableResend==true.obs?Colors.blue:Colors.grey),)),
//                     otpController.enableResend==true.obs?Text(''):Text(' in ${otpController.timerCount} secs',style: TextStyle(color: Colors.blue),),
//                     //Spacer()
//                   ],
//                 ),
//                 SizedBox(height: height*0.07,),
//                 InkWell(
//                   onTap: ()async{
//                     if(textEditingController.text.length!=6)
//                       errorController.add(ErrorAnimationType.shake);
//                     else{
//                       PhoneAuthCredential phoneAuthCredential =
//                               PhoneAuthProvider.credential(
//                                   verificationId: _auth.verificationId.toString(),
//                                   smsCode: textEditingController.text);
//
//                           var res= await _auth.signInWithPhoneAuthCredential(
//                               phoneAuthCredential, context);
//                           if(FirebaseAuth.instance.currentUser!=null)
//                             {
//                               await FirebaseFirestore.instance
//                                         .collection('Users')
//                                         .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//                                         .get()
//                                         .then((value) {
//                                       if (value.docs.isEmpty) {
//                                         Get.offAll(() => ProfileScreen());
//                                       } else {
//                                         Get.offAll(() => HomePage());
//                                       }
//                                     });
//                             }
//                           else{
//                             errorController.add(ErrorAnimationType.shake);
//                             showError('Wrong Otp provided', context);
//                           }
//                     }
//                     //Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashAfterRegister()));
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.lightGreen,
//                         borderRadius: BorderRadius.all(Radius.circular(10))
//                     ),
//                     height: height*0.055,
//                     width: width*0.86,
//
//                     child: Center(child: Text('Continue',style: TextStyle(color: Colors.white,fontSize: height*0.025,fontWeight: FontWeight.bold),)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//
//
//
//
//
//       // OtpScreen.withGradientBackground(
//       //   otpLength: 6,
//       //   subTitle: 'please enter the OTP sent to\n+91${_auth.phoneDetails}',
//       //   validateOtp: (String otp) async {
//       //     PhoneAuthCredential phoneAuthCredential =
//       //         PhoneAuthProvider.credential(
//       //             verificationId: _auth.verificationId.toString(),
//       //             smsCode: otp);
//       //
//       //     return _auth.signInWithPhoneAuthCredential(
//       //         phoneAuthCredential, context);
//       //   },
//       //   routeCallback: (context) async {
//       //     if (FirebaseAuth.instance.currentUser != null) {
//       //       await FirebaseFirestore.instance
//       //           .collection('Users')
//       //           .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//       //           .get()
//       //           .then((value) {
//       //         if (value.docs.isEmpty) {
//       //           Get.offAll(() => ProfileScreen());
//       //         } else {
//       //           Get.offAll(() => HomePage());
//       //         }
//       //       });
//       //     }
//       //   },
//       //   titleColor: Colors.lightGreen,
//       //   themeColor: Colors.grey.shade400,
//       //   topColor: Colors.black,
//       //   bottomColor: Colors.black,
//       // ),
//     );
//   }
// }
