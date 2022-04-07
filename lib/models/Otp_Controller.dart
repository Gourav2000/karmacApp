
import 'dart:async';

import 'package:get/get.dart';
class OtpController extends GetxController {
 RxInt timerCount=0.obs;
 RxBool enableResend=false.obs;

 timeCounterFunction(int count)
 {
   print('hmmm');
   timerCount=count.obs;
   enableResend=false.obs;
   update();
   Timer _timer=Timer.periodic(Duration(seconds: 1), (timer){
     if(timerCount!=0.obs)
       {
         timerCount--;
         if(timerCount==0.obs)
           enableResend=true.obs;
         update();
       }
     else{

       timer.cancel();
     }
   });
 }

 @override
  void onInit() {
    // TODO: implement onInit

   timeCounterFunction(30);
    super.onInit();
  }
}