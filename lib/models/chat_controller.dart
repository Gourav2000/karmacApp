import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './message_details.dart';

class ChatController extends GetxController {
  final String roomId;

  ChatController(this.roomId);

  RxList<MessageDetails> messages = RxList<MessageDetails>([]);

  @override
  void onInit() {
    messages.bindStream(getMessages());
    super.onInit();
  }

  Stream<List<MessageDetails>> getMessages() {
    return FirebaseFirestore.instance
        .collection('Chat')
        .doc(roomId)
        .collection('Messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((query) => query.docs.map((e) {
              if (e['author'] != FirebaseAuth.instance.currentUser?.uid) {
                FirebaseFirestore.instance
                    .collection('Chat')
                    .doc(roomId)
                    .get()
                    .then((value) {
                  if (value.data()!['IsUserInRoom']) {
                    FirebaseFirestore.instance
                        .collection('Chat')
                        .doc(roomId)
                        .collection('Messages')
                        .doc(e.id)
                        .update({'isRead': true});
                  }
                });
              }
              return MessageDetails(
                author: e['author'],
                text: e['text'],
                createdAt: DateTime.parse(e['createdAt']),
                id: e.id,
                isRead: e['isRead'],
                type: e['type'],
              );
            }).toList());
  }

  void Send(String mssg, String type) async {
    DateTime date = DateTime.now();
    await FirebaseFirestore.instance
        .collection('Chat')
        .doc(roomId)
        .collection('Messages')
        .add({
      'author': FirebaseAuth.instance.currentUser!.uid,
      'createdAt': date.toIso8601String(),
      'text': mssg,
      'isRead': false,
      'type': type,
    });
    await FirebaseFirestore.instance.collection('Chat').doc(roomId).update({
      'latestMessage': mssg,
      'latestMessageTime': date.toIso8601String(),
      'latestMessageType': type,
    });
  }
}
