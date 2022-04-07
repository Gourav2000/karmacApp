import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:karmac/models/chat_controller.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:intl/intl.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  final String name;
  final String number;

  ChatRoomScreen(this.roomId, this.name, this.number);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ImagePicker _picker = ImagePicker();
  late ChatController chatController;
  TextEditingController mssgController = TextEditingController();
  var separator;
  var date = DateTime.now().day;

  @override
  void initState() {
    chatController = Get.put(ChatController(widget.roomId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
              ),
              backgroundColor: Colors.grey.shade400,
            ),
            Padding(
              padding:  EdgeInsets.only(left: 8.0),
              child: Text(
                widget.name,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.lightGreen,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.phone,
              color: Colors.lightGreen,
            ),
            onPressed: () {
              launch('tel://${widget.number}');
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(
          right: 8,
          left: 8,
        ),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  reverse: true,
                  dragStartBehavior: DragStartBehavior.start,
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, i) {
                    if (i < chatController.messages.length - 1 &&
                        (chatController.messages[i].createdAt.day !=
                            chatController.messages[i + 1].createdAt.day)) {
                      separator = Container(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        alignment: Alignment.center,
                        width: Get.width,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            DateTime(
                                        chatController
                                            .messages[i].createdAt.day,
                                        chatController
                                            .messages[i].createdAt.month,
                                        chatController
                                            .messages[i].createdAt.year) ==
                                    DateTime(
                                        DateTime.now().day,
                                        DateTime.now().month,
                                        DateTime.now().year)
                                ? 'Today'
                                : DateTime(
                                            chatController
                                                .messages[i].createdAt.day,
                                            chatController
                                                .messages[i].createdAt.month,
                                            chatController
                                                .messages[i].createdAt.year) ==
                                        DateTime(
                                            DateTime.now().day - 1,
                                            DateTime.now().month,
                                            DateTime.now().year)
                                    ? 'Yesterday'
                                    : '${chatController.messages[i].createdAt.day}/${chatController.messages[i].createdAt.month}/${chatController.messages[i].createdAt.year}',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    } else {
                      if (i == chatController.messages.length - 1) {
                        separator = Container(
                          alignment: Alignment.center,
                          width: Get.width,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              DateTime(
                                          chatController
                                              .messages[i].createdAt.day,
                                          chatController
                                              .messages[i].createdAt.month,
                                          chatController
                                              .messages[i].createdAt.year) ==
                                      DateTime(
                                          DateTime.now().day,
                                          DateTime.now().month,
                                          DateTime.now().year)
                                  ? 'Today'
                                  : DateTime(
                                              chatController
                                                  .messages[i].createdAt.day,
                                              chatController
                                                  .messages[i].createdAt.month,
                                              chatController.messages[i]
                                                  .createdAt.year) ==
                                          DateTime(
                                              DateTime.now().day - 1,
                                              DateTime.now().month,
                                              DateTime.now().year)
                                      ? 'Yesterday'
                                      : '${chatController.messages[i].createdAt.day}/${chatController.messages[i].createdAt.month}/${chatController.messages[i].createdAt.year}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      } else {
                        separator = Container();
                      }
                    }
                    if (chatController.messages[i].author ==
                        FirebaseAuth.instance.currentUser?.uid) {
                      if (i < chatController.messages.length - 1 &&
                          (chatController.messages[i + 1].author ==
                              FirebaseAuth.instance.currentUser?.uid) &&
                          (DateTime(
                                  chatController.messages[i].createdAt.day,
                                  chatController.messages[i].createdAt.month,
                                  chatController.messages[i].createdAt.year) ==
                              DateTime(
                                  chatController.messages[i + 1].createdAt.day,
                                  chatController
                                      .messages[i + 1].createdAt.month,
                                  chatController
                                      .messages[i + 1].createdAt.year))) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            separator,
                            Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: chatController.messages[i].type ==
                                            'image'
                                        ? const EdgeInsets.all(5)
                                        : const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade900,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            maxHeight: double.infinity,
                                          ),
                                          child: chatController
                                                      .messages[i].type ==
                                                  'image'
                                              ? Stack(
                                                  children: [
                                                    FullScreenWidget(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image.network(
                                                          chatController
                                                              .messages[i].text,
                                                          loadingBuilder: (context,
                                                              child,
                                                              ImageChunkEvent?
                                                                  loadingProgress) {
                                                            if (loadingProgress !=
                                                                null) {
                                                              return CircularProgressIndicator();
                                                            } else {
                                                              return child;
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 5,
                                                      right: 5,
                                                      child: Text(
                                                        '${chatController.messages[i].createdAt.hour}:${chatController.messages[i].createdAt.minute}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  chatController
                                                      .messages[i].text,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                        ),
                                        chatController.messages[i].type ==
                                                'image'
                                            ? Container()
                                            : SizedBox(
                                                width: 4,
                                              ),
                                        chatController.messages[i].type ==
                                                'image'
                                            ? Container()
                                            : Text(
                                                '${chatController.messages[i].createdAt.hour}:${chatController.messages[i].createdAt.minute}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.check,
                                    size: 12,
                                    color: chatController.messages[i].isRead
                                        ? Colors.green
                                        : Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            separator,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ChatBubble(
                                  clipper: ChatBubbleClipper1(
                                    type: BubbleType.sendBubble,
                                    nipWidth: 10,
                                  ),
                                  alignment: Alignment.topRight,
                                  elevation: 0,
                                  margin: EdgeInsets.only(
                                    top: 20,
                                  ),
                                  backGroundColor: Colors.blue.shade900,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          maxHeight: double.infinity,
                                        ),
                                        child: chatController
                                                    .messages[i].type ==
                                                'image'
                                            ? Stack(
                                                children: [
                                                  FullScreenWidget(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        chatController
                                                            .messages[i].text,
                                                        loadingBuilder: (context,
                                                            child,
                                                            ImageChunkEvent?
                                                                loadingProgress) {
                                                          if (loadingProgress !=
                                                              null) {
                                                            return CircularProgressIndicator();
                                                          } else {
                                                            return child;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 5,
                                                    right: 5,
                                                    child: Text(
                                                      '${chatController.messages[i].createdAt.hour}:${chatController.messages[i].createdAt.minute}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                chatController.messages[i].text,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                      ),
                                      chatController.messages[i].type == 'image'
                                          ? Container()
                                          : SizedBox(
                                              width: 4,
                                            ),
                                      chatController.messages[i].type == 'image'
                                          ? Container()
                                          : Text(
                                              '${chatController.messages[i].createdAt.hour}:${chatController.messages[i].createdAt.minute}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.check,
                                  size: 12,
                                  color: chatController.messages[i].isRead
                                      ? Colors.green
                                      : Colors.grey.shade600,
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    } else {
                      if (i < chatController.messages.length - 1 &&
                          (chatController.messages[i + 1].author !=
                              FirebaseAuth.instance.currentUser?.uid) &&
                          (DateTime(
                                  chatController.messages[i].createdAt.day,
                                  chatController.messages[i].createdAt.month,
                                  chatController.messages[i].createdAt.year) ==
                              DateTime(
                                  chatController.messages[i + 1].createdAt.day,
                                  chatController
                                      .messages[i + 1].createdAt.month,
                                  chatController
                                      .messages[i + 1].createdAt.year))) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            separator,
                            Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                              ),
                              child: Container(
                                padding:
                                    chatController.messages[i].type == 'image'
                                        ? const EdgeInsets.all(5)
                                        : const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  color: Colors.grey.shade300,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        maxHeight: double.infinity,
                                      ),
                                      child: chatController.messages[i].type ==
                                              'image'
                                          ? Stack(
                                              children: [
                                                FullScreenWidget(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      chatController
                                                          .messages[i].text,
                                                      loadingBuilder: (context,
                                                          child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress !=
                                                            null) {
                                                          return CircularProgressIndicator();
                                                        } else {
                                                          return child;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 5,
                                                  right: 5,
                                                  child: Text(
                                                    '${chatController.messages[i].createdAt.hour}:${chatController.messages[i].createdAt.minute}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              chatController.messages[i].text,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                    ),
                                    chatController.messages[i].type == 'image'
                                        ? Container()
                                        : SizedBox(
                                            width: 4,
                                          ),
                                    chatController.messages[i].type == 'image'
                                        ? Container()
                                        : Text(
                                            '${chatController.messages[i].createdAt.hour}:${chatController.messages[i].createdAt.minute}',
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 10,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            separator,
                            ChatBubble(
                              clipper: ChatBubbleClipper1(
                                type: BubbleType.receiverBubble,
                                nipWidth: 10,
                              ),
                              backGroundColor: Colors.grey.shade300,
                              elevation: 0,
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                      maxHeight: double.infinity,
                                    ),
                                    child: chatController.messages[i].type ==
                                            'image'
                                        ? Stack(
                                            children: [
                                              FullScreenWidget(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    chatController
                                                        .messages[i].text,
                                                    loadingBuilder: (context,
                                                        child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress !=
                                                          null) {
                                                        return CircularProgressIndicator();
                                                      } else {
                                                        return child;
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 5,
                                                right: 5,
                                                child: Text(
                                                  '${chatController.messages[i].createdAt.hour}:${chatController.messages[i].createdAt.minute}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            chatController.messages[i].text,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                  ),
                                  chatController.messages[i].type == 'image'
                                      ? Container()
                                      : SizedBox(
                                          width: 4,
                                        ),
                                  chatController.messages[i].type == 'image'
                                      ? Container()
                                      : Text(
                                          '${chatController.messages[i].createdAt.hour}:${chatController.messages[i].createdAt.minute}',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 10,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        right: 8,
                        left: 16,
                        top: 2,
                        bottom: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.grey.shade700,
                            ),
                            onPressed: () async {
                              File image;
                              XFile? photo;
                              photo = await _picker.pickImage(
                                  source: ImageSource.camera);
                              if (photo != null) {
                                image = File(photo.path);
                                final ref = FirebaseStorage.instance
                                    .ref()
                                    .child('Chat')
                                    .child(
                                    DateTime.now().toString() + '.jpg');

                                await ref.putFile(image);
                                final String url =
                                await ref.getDownloadURL();
                                chatController.Send(url, 'image');
                              }
                            },
                          ),
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight: Get.height * 0.2,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextField(
                                      autocorrect: true,
                                      enableSuggestions: true,
                                      maxLines: null,
                                      controller: mssgController,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Message',
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.attach_file,
                              color: Colors.grey.shade900,
                            ),
                            onPressed: () {
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
                                                      child: Icon(Icons.insert_drive_file,color: Colors.white,),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Colors.lightGreen,
                                                        shape: BoxShape.circle
                                                    ),

                                                  ),

                                                  Padding(
                                                    padding:  EdgeInsets.only(left: 8.0),
                                                    child: Text('File',style: TextStyle(color: Colors.white,fontSize: 17.5),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: ()async{
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
                                                    .child(
                                                    DateTime.now().toString() + '.jpg');

                                                await ref.putFile(image);
                                                final String url =
                                                await ref.getDownloadURL();
                                                chatController.Send(url, 'image');
                                              }
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.lightGreen,
                    child: Icon(Icons.send),
                    onPressed: () {
                      if (mssgController.text.isNotEmpty) {
                        chatController.Send(mssgController.text, 'message');
                        mssgController.text = '';
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
