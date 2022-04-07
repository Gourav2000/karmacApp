import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import './chat.dart';

class ChatListController extends GetxController {
  RxList<Chat> chats = RxList<Chat>([]);


  @override
  void onInit() {
    chats.bindStream(getChats());

    super.onInit();
  }


  Stream<List<Chat>> getChats() {
    print('hmmm');
    try {
      return FirebaseFirestore.instance
          .collection('Chat')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .orderBy('latestMessageTime', descending: true)
          .snapshots()
          .map((query) => query.docs
              .map((e) => Chat(
                    name: e['serviceCentreName'],
                    id: e.id,
                    number: e['serviceCentreNumber'],
                    latestMessage: e['latestMessage'],
                    latestMessageTime: e['latestMessageTime'],
                    latestMessageType: e['latestMessageType'],
                  ))
              .toList());
    } on FirebaseException catch (e) {
      print(e);
      throw (e);
    }
  }
}
