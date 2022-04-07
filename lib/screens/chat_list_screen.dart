import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import '../models/chat_list_controller.dart';
import './chat_room_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatefulWidget {
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  ChatListController chatListController = Get.put(ChatListController());
  TextEditingController searchText=TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  FloatingSearchBarController searchController = FloatingSearchBarController();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => chatListController.chats.length==0?Center(child: Text("You haven't initiated any chats yet!",style: TextStyle(color: Colors.white),)):
      Column(
        children: [
         Padding(
           padding:  EdgeInsets.only(left: 15,right: 15,top: 10),
           child: TextField(
             controller: searchText,
             style: TextStyle(color: Colors.white),
             decoration: new InputDecoration(
               contentPadding:  EdgeInsets.symmetric(vertical: 0, ),

               focusedBorder: OutlineInputBorder(
                 borderSide: BorderSide(color: Colors.white, width: 1),
                 borderRadius: BorderRadius.circular(15)
               ),
               prefixIcon: Icon(Icons.search,color: Colors.lightGreen,),
               enabledBorder: OutlineInputBorder(
                 borderSide: BorderSide(color: Colors.white, width: 1),
                   borderRadius:BorderRadius.circular(20)
               ),
               hintText: '  Search..',

               hintStyle: TextStyle(color: Colors.white)
             ),
             onChanged: (text){
               chatListController.chats.refresh();
             },
           ),
         ),
          Expanded(
            child: ListView.builder(
              itemCount: chatListController.chats.length,
              itemBuilder: (context, i) {

                if(chatListController.chats[i].name.toLowerCase().startsWith(searchText.text.toLowerCase()))
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.only(
                      right: 15,
                    ),
                    alignment: Alignment.centerRight,
                    child: FaIcon(
                      FontAwesomeIcons.trash,
                      color: Colors.red,
                    ),
                  ),
                  confirmDismiss: (_) async {
                    bool val = false;
                    await Get.defaultDialog(
                        title: 'Are you sure ?',
                        middleText:
                            'you will loose all your chats with this service centre',
                        textConfirm: 'YES',
                        textCancel: 'NO',
                        confirmTextColor: Colors.white,
                        cancelTextColor: Colors.lightGreen,
                        buttonColor: Colors.lightGreen,
                        onConfirm: () {
                          Navigator.of(context).pop();
                          val = true;
                        });
                    return val;
                  },
                  onDismissed: (_) {
                    FirebaseFirestore.instance
                        .collection('Chat')
                        .doc(chatListController.chats[i].id)
                        .delete();
                  },
                  child: ListTile(
                    onLongPress: () async {
                      await Get.defaultDialog(
                          title: 'Do you want to delete this chat?',
                          middleText:
                              'you will loose all your chats with this service centre',
                          textConfirm: 'YES',
                          textCancel: 'NO',
                          confirmTextColor: Colors.white,
                          cancelTextColor: Colors.lightGreen,
                          buttonColor: Colors.lightGreen,
                          onConfirm: () {
                            Navigator.of(context).pop();
                            FirebaseFirestore.instance
                                .collection('Chat')
                                .doc(chatListController.chats[i].id)
                                .delete();
                          });
                    },
                    contentPadding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 15,
                      right: 10,
                    ),
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection('Chat')
                          .doc(chatListController.chats[i].id)
                          .update({'IsUserInRoom': true});
                      Get.to(() => ChatRoomScreen(
                          chatListController.chats[i].id,
                          chatListController.chats[i].name,
                          chatListController.chats[i].number))?.then((value) {
                        FirebaseFirestore.instance
                            .collection('Chat')
                            .doc(chatListController.chats[i].id)
                            .update({'IsUserInRoom': false});
                      });
                    },
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                      ),
                      backgroundColor: Colors.grey.shade400,
                    ),
                    title: Text(
                      chatListController.chats[i].name,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        //fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: chatListController.chats[i].latestMessageType == 'image'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'photo',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            chatListController.chats[i].latestMessage,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          chatListController.chats[i].latestMessageTime == ''
                              ? ''
                              : DateTime(
                                          DateTime.parse(chatListController
                                                  .chats[i].latestMessageTime)
                                              .day,
                                          DateTime.parse(chatListController
                                                  .chats[i].latestMessageTime)
                                              .month,
                                          DateTime.parse(chatListController
                                                  .chats[i].latestMessageTime)
                                              .year) ==
                                      DateTime(DateTime.now().day,
                                          DateTime.now().month, DateTime.now().year)
                                  ? '${DateTime.parse(chatListController.chats[i].latestMessageTime).hour}:${DateTime.parse(chatListController.chats[i].latestMessageTime).minute}'
                                  : DateTime(
                                              DateTime.parse(chatListController
                                                      .chats[i].latestMessageTime)
                                                  .day,
                                              DateTime.parse(chatListController
                                                      .chats[i].latestMessageTime)
                                                  .month,
                                              DateTime.parse(chatListController
                                                      .chats[i].latestMessageTime)
                                                  .year) ==
                                          DateTime(
                                              DateTime.now().day - 1,
                                              DateTime.now().month,
                                              DateTime.now().year)
                                      ? 'Yesterday'
                                      : '${DateTime.parse(chatListController.chats[i].latestMessageTime).day}/${DateTime.parse(chatListController.chats[i].latestMessageTime).month}/${DateTime.parse(chatListController.chats[i].latestMessageTime).year}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Chat')
                              .doc(chatListController.chats[i].id)
                              .collection('Messages')
                              .where('author',
                                  isNotEqualTo:
                                      FirebaseAuth.instance.currentUser?.uid)
                              .where('isRead', isEqualTo: false)
                              .snapshots(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Text('');
                            } else {
                              return snapshot.data!.docs.length == 0
                                  ? Text('')
                                  : CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.lightGreen,
                                      child: Text(
                                        snapshot.data!.docs.length.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
                else
                  return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
