import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:karmac/models/user_controller.dart';
import '../models/review_controller.dart';
import './add_review_screen.dart';
import '../models/service_details_controller.dart';
import './book_slot_screen.dart';
import './chat_room_screen.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/karmac_controller.dart';
import 'package:lottie/lottie.dart' as lot;
import '../models/car_details_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './review_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:ntp/ntp.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ServiceCenterDetailsScreen extends StatefulWidget {
  static const String routeName = '/service_center_details_screen';

  @override
  _ServiceCenterDetailsScreenState createState() =>
      _ServiceCenterDetailsScreenState();
}

class _ServiceCenterDetailsScreenState
    extends State<ServiceCenterDetailsScreen> {
  FirebaseApp secondary = Firebase.app("business");
  KarmacController karmacController = Get.put(KarmacController());
  CarDetailsController addCarController = Get.put(CarDetailsController());
  ServiceDetailsController serviceDetailsController =
      Get.put(ServiceDetailsController());
  late ReviewController revController;
  int i = Get.arguments;
  TextEditingController reviewController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 16,
  );
  @override
  void initState() {
    super.initState();
    revController =
        Get.put(ReviewController(karmacController.serviceCenters[i].id));
  }

  Widget reviewWidget(int k) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(
                    'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                  ),
                  foregroundImage: NetworkImage(revController.reviews[k].image),
                  backgroundColor: Colors.grey.shade400,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  revController.reviews[k].name,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Stack(
                  children: [
                    RatingBarIndicator(
                      rating: 5,
                      itemBuilder: (context, index) => Icon(
                        Icons.star_border_outlined,
                        color: Colors.lightGreen,
                      ),
                      itemCount: 5,
                      itemSize: 15,
                      direction: Axis.horizontal,
                    ),
                    RatingBarIndicator(
                      rating: revController.reviews[k].rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.lightGreenAccent.shade400,
                      ),
                      itemCount: 5,
                      itemSize: 15,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
                SizedBox(
                  width: 8,
                ),
                AutoSizeText(
                  '${revController.reviews[k].date.toDate().day}/${revController.reviews[k].date.toDate().month}/${revController.reviews[k].date.toDate().year}',
                  minFontSize: 1,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            revController.reviews[k].service == ''
                ? Container()
                : Column(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      AutoSizeText(
                        '${revController.reviews[k].service} service',
                        minFontSize: 1,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
            revController.reviews[k].title == ''
                ? Container()
                : Column(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      AutoSizeText(
                        revController.reviews[k].title,
                        minFontSize: 1,
                        maxLines: null,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
            revController.reviews[k].desc == ''
                ? Container()
                : Column(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      AutoSizeText(
                        revController.reviews[k].desc,
                        minFontSize: 1,
                        maxLines: null,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Was this helpful ?',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instanceFor(app: secondary)
                      .collection('ServiceCentres')
                      .doc(karmacController.serviceCenters[i].id)
                      .collection('Reviews')
                      .doc(revController.reviews[k].id)
                      .collection('Likes')
                      .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return IconButton(
                        icon: snapshot.data!.docs.isEmpty
                            ? Icon(
                                Icons.thumb_up_alt_outlined,
                                color: Colors.grey.shade400,
                              )
                            : snapshot.data!.docs.first['isLike'] == true
                                ? Icon(
                                    Icons.thumb_up,
                                    color: Colors.grey.shade400,
                                  )
                                : Icon(
                                    Icons.thumb_up_alt_outlined,
                                    color: Colors.grey.shade400,
                                  ),
                        onPressed: () {
                          if (snapshot.data!.docs.isEmpty) {
                            FirebaseFirestore.instanceFor(app: secondary)
                                .collection('ServiceCentres')
                                .doc(karmacController.serviceCenters[i].id)
                                .collection('Reviews')
                                .doc(revController.reviews[k].id)
                                .collection('Likes')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .set({
                              'uid': FirebaseAuth.instance.currentUser!.uid,
                              'isLike': true,
                              'isDislike': false,
                            });
                            FirebaseFirestore.instanceFor(app: secondary)
                                .collection('ServiceCentres')
                                .doc(karmacController.serviceCenters[i].id)
                                .collection('Reviews')
                                .doc(revController.reviews[k].id)
                                .update({
                              'likes': revController.reviews[k].likes + 1
                            });
                          } else {
                            if (snapshot.data!.docs.first['isLike'] == false) {
                              FirebaseFirestore.instanceFor(app: secondary)
                                  .collection('ServiceCentres')
                                  .doc(karmacController.serviceCenters[i].id)
                                  .collection('Reviews')
                                  .doc(revController.reviews[k].id)
                                  .collection('Likes')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                'isLike': true,
                                'isDislike': false,
                              });
                              if (snapshot.data!.docs.first['isLike'] ==
                                      false &&
                                  snapshot.data!.docs.first['isDislike'] ==
                                      false) {
                                FirebaseFirestore.instanceFor(app: secondary)
                                    .collection('ServiceCentres')
                                    .doc(karmacController.serviceCenters[i].id)
                                    .collection('Reviews')
                                    .doc(revController.reviews[k].id)
                                    .update({
                                  'likes': revController.reviews[k].likes + 1,
                                });
                              } else {
                                FirebaseFirestore.instanceFor(app: secondary)
                                    .collection('ServiceCentres')
                                    .doc(karmacController.serviceCenters[i].id)
                                    .collection('Reviews')
                                    .doc(revController.reviews[k].id)
                                    .update({
                                  'likes': revController.reviews[k].likes + 1,
                                  'dislikes':
                                      revController.reviews[k].dislikes - 1,
                                });
                              }
                            } else {
                              FirebaseFirestore.instanceFor(app: secondary)
                                  .collection('ServiceCentres')
                                  .doc(karmacController.serviceCenters[i].id)
                                  .collection('Reviews')
                                  .doc(revController.reviews[k].id)
                                  .collection('Likes')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                'isLike': false,
                                'isDislike': false,
                              });
                              FirebaseFirestore.instanceFor(app: secondary)
                                  .collection('ServiceCentres')
                                  .doc(karmacController.serviceCenters[i].id)
                                  .collection('Reviews')
                                  .doc(revController.reviews[k].id)
                                  .update({
                                'likes': revController.reviews[k].likes - 1
                              });
                            }
                          }
                        },
                      );
                    } else {
                      return CircularProgressIndicator(
                        color: Colors.grey.shade400,
                      );
                    }
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instanceFor(app: secondary)
                      .collection('ServiceCentres')
                      .doc(karmacController.serviceCenters[i].id)
                      .collection('Reviews')
                      .doc(revController.reviews[k].id)
                      .collection('Likes')
                      .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return IconButton(
                        icon: snapshot.data!.docs.isEmpty
                            ? Icon(
                                Icons.thumb_down_off_alt_outlined,
                                color: Colors.grey.shade400,
                              )
                            : snapshot.data!.docs.first['isDislike'] == true
                                ? Icon(
                                    Icons.thumb_down,
                                    color: Colors.grey.shade400,
                                  )
                                : Icon(
                                    Icons.thumb_down_off_alt_outlined,
                                    color: Colors.grey.shade400,
                                  ),
                        onPressed: () {
                          if (snapshot.data!.docs.isEmpty) {
                            FirebaseFirestore.instanceFor(app: secondary)
                                .collection('ServiceCentres')
                                .doc(karmacController.serviceCenters[i].id)
                                .collection('Reviews')
                                .doc(revController.reviews[k].id)
                                .collection('Likes')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .set({
                              'uid': FirebaseAuth.instance.currentUser!.uid,
                              'isLike': false,
                              'isDislike': true,
                            });
                            FirebaseFirestore.instanceFor(app: secondary)
                                .collection('ServiceCentres')
                                .doc(karmacController.serviceCenters[i].id)
                                .collection('Reviews')
                                .doc(revController.reviews[k].id)
                                .update({
                              'dislikes': revController.reviews[k].dislikes + 1
                            });
                          } else {
                            if (snapshot.data!.docs.first['isDislike'] ==
                                false) {
                              FirebaseFirestore.instanceFor(app: secondary)
                                  .collection('ServiceCentres')
                                  .doc(karmacController.serviceCenters[i].id)
                                  .collection('Reviews')
                                  .doc(revController.reviews[k].id)
                                  .collection('Likes')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                'isLike': false,
                                'isDislike': true,
                              });
                              if (snapshot.data!.docs.first['isLike'] ==
                                      false &&
                                  snapshot.data!.docs.first['isDislike'] ==
                                      false) {
                                FirebaseFirestore.instanceFor(app: secondary)
                                    .collection('ServiceCentres')
                                    .doc(karmacController.serviceCenters[i].id)
                                    .collection('Reviews')
                                    .doc(revController.reviews[k].id)
                                    .update({
                                  'dislikes':
                                      revController.reviews[k].dislikes + 1,
                                });
                              } else {
                                FirebaseFirestore.instanceFor(app: secondary)
                                    .collection('ServiceCentres')
                                    .doc(karmacController.serviceCenters[i].id)
                                    .collection('Reviews')
                                    .doc(revController.reviews[k].id)
                                    .update({
                                  'dislikes':
                                      revController.reviews[k].dislikes + 1,
                                  'likes': revController.reviews[k].likes - 1,
                                });
                              }
                            } else {
                              FirebaseFirestore.instanceFor(app: secondary)
                                  .collection('ServiceCentres')
                                  .doc(karmacController.serviceCenters[i].id)
                                  .collection('Reviews')
                                  .doc(revController.reviews[k].id)
                                  .collection('Likes')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                'isLike': false,
                                'isDislike': false,
                              });
                              FirebaseFirestore.instanceFor(app: secondary)
                                  .collection('ServiceCentres')
                                  .doc(karmacController.serviceCenters[i].id)
                                  .collection('Reviews')
                                  .doc(revController.reviews[k].id)
                                  .update({
                                'dislikes':
                                    revController.reviews[k].dislikes - 1
                              });
                            }
                          }
                        },
                      );
                    } else {
                      return CircularProgressIndicator(
                        color: Colors.grey.shade400,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;

    double rating = 0;
    RxString service = ''.obs;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.lightGreen,
        ),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Image.asset(
          'assets/images/logo2.png',
          height: 56,
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            color: Colors.black,
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    right: 8,
                    left: 8,
                    top: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          karmacController.serviceCenters[i].company,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.grey.shade400,
                          size: 25,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                          ),
                          child: Text(
                            karmacController.serviceCenters[i].address,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${karmacController.serviceCenters[i].city}, ',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                karmacController.serviceCenters[i].state,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      child: Image.network(
                        addCarController.brands
                            .firstWhere((element) =>
                                element.name ==
                                karmacController.serviceCenters[i].brand)
                            .imageUrl,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Timing: ',
                        style: TextStyle(
                          color: Colors.lightGreenAccent.shade400,
                        ),
                      ),
                      Text(
                        '${karmacController.serviceCenters[i].startTime} - ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          karmacController.serviceCenters[i].endTime,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      karmacController.serviceCenters[i].isOpen
                          ? RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Open',
                                    style: TextStyle(
                                      color: Colors.lightGreenAccent.shade400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' now',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Currently ',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Closed',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                Container(
                  width: Get.width,
                  height: 250,
                  child: Swiper(
                    itemCount: 3,
                    autoplay: true,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://drive.google.com/uc?export=view&id=1WADBO26yNIOozbH-IHTXtrejFlpjWnNn',
                            height: 234,
                            width: Get.width - 16,
                            fit: BoxFit.cover,
                            placeholder: (context, val) {
                              return lot.LottieBuilder.asset(
                                'assets/anim/bimg.json',
                                fit: BoxFit.contain,
                                height: 234,
                                width: Get.width - 16,
                              );
                            },
                          ),
                        ),
                      );
                    },
                    pagination: SwiperPagination(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                    ),
                    viewportFraction: 1,
                    scale: 0.9,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    right: 8,
                    left: 8,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Colors.blue,
                                width: 1,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            String roomId = '';
                            final data = await FirebaseFirestore.instance
                                .collection('Chat')
                                .where("userId",
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser?.uid)
                                .where("serviceCentreId",
                                    isEqualTo:
                                        karmacController.serviceCenters[i].id)
                                .get();
                            if (data.docs.isEmpty) {
                              await FirebaseFirestore.instance
                                  .collection('Chat')
                                  .add({
                                'isCentreInRoom': false,
                                'IsUserInRoom': true,
                                'latestMessage': '',
                                'latestMessageTime': '',
                                'latestMessageType': '',
                                'serviceCentreNumber': karmacController
                                    .serviceCenters[i].phoneNumber,
                                'serviceCentreName':
                                    karmacController.serviceCenters[i].company,
                                'serviceCentreId':
                                    karmacController.serviceCenters[i].id,
                                'userId':
                                    FirebaseAuth.instance.currentUser?.uid,
                              }).then((value) {
                                roomId = value.id;
                                Get.to(() => ChatRoomScreen(
                                    roomId,
                                    karmacController.serviceCenters[i].company,
                                    karmacController.serviceCenters[i]
                                        .phoneNumber))?.then((value) {
                                  FirebaseFirestore.instance
                                      .collection('Chat')
                                      .doc(roomId)
                                      .update({'IsUserInRoom': false});
                                });
                              });
                            } else {
                              roomId = data.docs.first.id;
                              Get.to(() => ChatRoomScreen(
                                  roomId,
                                  karmacController.serviceCenters[i].company,
                                  karmacController
                                      .serviceCenters[i].phoneNumber));
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat,
                                color: Colors.grey.shade400,
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Text(
                                      'Chat with ${karmacController.serviceCenters[i].company}',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                        ),
                        onPressed: () {
                          launch(
                              'tel://${karmacController.serviceCenters[i].phoneNumber}');
                        },
                        child: Icon(
                          Icons.phone,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                        ),
                        onPressed: () {
                          String? encodeQueryParameters(
                              Map<String, String> params) {
                            return params.entries
                                .map((e) =>
                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                .join('&');
                          }

                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'support@karmac.in',
                            query: encodeQueryParameters(
                                <String, String>{'subject': 'Support!'}),
                          );

                          launch(emailLaunchUri.toString());
                        },
                        child: Icon(
                          Icons.mail,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    right: 8,
                    left: 8,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 10,
                      top: 4,
                      bottom: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpandablePanel(
                      header: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.tools,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: AutoSizeText(
                                  'List of Services provided by us',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.grey.shade200,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      collapsed: Container(),
                      expanded: Container(
                        height: 300,
                        child: serviceDetailsController.isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.lightGreen,
                                ),
                              )
                            : ListView.builder(
                                itemCount:
                                    serviceDetailsController.services.length,
                                itemBuilder: (context, i) {
                                  return ListTile(
                                    title: AutoSizeText(
                                      serviceDetailsController.services[i],
                                      minFontSize: 1,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      theme: ExpandableThemeData(
                        hasIcon: true,
                        tapHeaderToExpand: true,
                        iconColor: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Divider(
                    color: Colors.grey.shade400,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_offer,
                        color: Colors.red,
                        size: 20,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'offers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width,
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          width: 200,
                          child: Text(
                            '10% instant discount up to ₹1,250 with SBI credit cards(Non-EMI) on minimum order of ₹10,000',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          width: 200,
                          child: Text(
                            '10% instant discount up to ₹1,250 with SBI credit cards(Non-EMI) on minimum order of ₹10,000',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          width: 200,
                          child: Text(
                            '10% instant discount up to ₹1,250 with SBI credit cards(Non-EMI) on minimum order of ₹10,000',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Divider(
                    color: Colors.grey.shade400,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 20,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GoogleMap(
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: {
                          Marker(
                            markerId: MarkerId('m1'),
                            position:
                                LatLng(37.42796133580664, -122.085749655962),
                            infoWindow: InfoWindow(
                                title:
                                    karmacController.serviceCenters[i].company),
                          ),
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                'BOOK A SLOT',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              )),
                          onPressed: () {
                            Get.to(
                              () => BookSlotScreen(),
                              arguments: {
                                'index': i,
                                'id': karmacController.serviceCenters[i].id,
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Divider(
                    color: Colors.grey.shade400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                    left: 8,
                  ),
                  child: Text(
                    'Customer reviews',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 8,
                    right: 8,
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          RatingBarIndicator(
                            rating: 5,
                            itemBuilder: (context, index) => Icon(
                              Icons.star_border_outlined,
                              color: Colors.lightGreen,
                            ),
                            itemCount: 5,
                            itemSize: 20,
                            direction: Axis.horizontal,
                          ),
                          RatingBarIndicator(
                            rating: double.parse(
                                karmacController.serviceCenters[i].rating),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.lightGreenAccent.shade400,
                            ),
                            itemCount: 5,
                            itemSize: 20,
                            direction: Axis.horizontal,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${double.parse(karmacController.serviceCenters[i].rating).toPrecision(1)} out of 5',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 4,
                  ),
                  child: Text(
                    '${revController.reviews.length} ratings',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Divider(
                    color: Colors.grey.shade400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 15,
                        ),
                        child: AutoSizeText(
                          'Top Reviews',
                          minFontSize: 1,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      /*ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.lightGreen,
                              size: 18,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Add a review',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Get.to(() => AddReviewScreen(),
                              arguments: karmacController.serviceCenters[i].id);
                          /*Get.defaultDialog(
                            backgroundColor: Colors.grey,
                            title: 'Give Your Review',
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    'Rating :',
                                  ),
                                  RatingBar.builder(
                                    glow: false,
                                    allowHalfRating: true,
                                    initialRating: 0,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.lightGreenAccent.shade400,
                                      size: 25,
                                    ),
                                    onRatingUpdate: (val) {
                                      rating = val;
                                    },
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Service :',
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Obx(() {
                                        if (service.value == 'Excellent') {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.lightGreen,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Excellent',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              service.value = 'Excellent';
                                            },
                                          );
                                        } else {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.grey.shade700,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Excellent',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              service.value = 'Excellent';
                                            },
                                          );
                                        }
                                      }),
                                      Obx(() {
                                        if (service.value == 'Good') {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.lightGreen,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Good',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              service.value = 'Good';
                                            },
                                          );
                                        } else {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.grey.shade700,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Good',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              service.value = 'Good';
                                            },
                                          );
                                        }
                                      }),
                                      Obx(() {
                                        if (service.value == 'Poor') {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.lightGreen,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Poor',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              service.value = 'Poor';
                                            },
                                          );
                                        } else {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.grey.shade700,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Poor',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              service.value = 'Poor';
                                            },
                                          );
                                        }
                                      }),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Description :',
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: BoxConstraints(
                                      maxHeight: Get.height * 0.2,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: reviewController,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  'Share your Experience with others',
                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: Colors.grey.shade700,
                                              width: 2,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.back();
                                          },
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.grey.shade700,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                          child: Text(
                                            'Submit',
                                            style: TextStyle(
                                              color: Colors.lightGreen,
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (service.value != '' &&
                                                reviewController
                                                    .text.isNotEmpty) {
                                              await FirebaseFirestore
                                                      .instanceFor(
                                                          app: secondary)
                                                  .collection('ServiceCentres')
                                                  .doc(karmacController
                                                      .serviceCenters[i].id)
                                                  .collection('Reviews')
                                                  .add({
                                                'rating': rating,
                                                'service': service.value,
                                                'desc': reviewController.text,
                                                'name': FirebaseAuth.instance
                                                    .currentUser!.displayName,
                                                'imageUrl': FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .photoURL,
                                                'uid': FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                'likes': 0,
                                                'dislikes': 0,
                                                'date': await NTP.now(),
                                              });
                                              double sum = 0;
                                              double review = 0;
                                              FirebaseFirestore.instanceFor(
                                                      app: secondary)
                                                  .collection('ServiceCentres')
                                                  .doc(karmacController
                                                      .serviceCenters[i].id)
                                                  .collection('Reviews')
                                                  .get()
                                                  .then((value) {
                                                if (value.docs.length > 0) {
                                                  value.docs.forEach((e) {
                                                    sum = sum + e['rating'];
                                                  });
                                                  review =
                                                      sum / value.docs.length;
                                                  FirebaseFirestore.instanceFor(
                                                          app: secondary)
                                                      .collection(
                                                          'ServiceCentres')
                                                      .doc(karmacController
                                                          .serviceCenters[i].id)
                                                      .update({
                                                    'rating': review.toString()
                                                  });
                                                }
                                              });
                                            }
                                            Get.back();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );*/
                        },
                      ),*/
                    ],
                  ),
                ),
                Obx(
                  () => Column(
                    children: [
                      revController.reviews.length > 0
                          ? reviewWidget(0)
                          : Container(),
                      revController.reviews.length > 1
                          ? reviewWidget(1)
                          : Container(),
                      revController.reviews.length > 2
                          ? reviewWidget(2)
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              'See All Reviews',
                              style: TextStyle(
                                color: Colors.lightGreen,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Get.to(() => ReviewScreen(
                                karmacController.serviceCenters[i].id));
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
