import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karmac/models/select_address_controller.dart';
import '../models/add_address_controller.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'dart:async';
import 'package:google_place/google_place.dart';

class SelectAddress extends StatefulWidget {
  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  AddAddressController addAddressController = Get.put(AddAddressController());
  SelectAddressController selectAddressController =
      Get.put(SelectAddressController());
  loc.Location location = new loc.Location();
  late bool _serviceEnabled;
  late loc.PermissionStatus _permissionGranted;
  late loc.LocationData _locationData;
  Completer<GoogleMapController> _controller = Completer();
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    isLoading.value = true;
    getLocation().then((value) => isLoading.value = false);
  }

  Future<void> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    setState(() {
      selectAddressController.lat.value = _locationData.latitude as double;
      selectAddressController.long.value = _locationData.longitude as double;
    });
    selectAddressController.getLoc(
        selectAddressController.lat.value, selectAddressController.long.value);
  }

  @override
  Widget build(BuildContext context) {
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => isLoading.value == true
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.lightGreen,
              ),
            )
          : FloatingSearchBar(
              hint: 'Search...',
              scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
              transitionDuration: const Duration(milliseconds: 800),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              axisAlignment: 0,
              openAxisAlignment: 0.0,
              width: Get.width * 0.95,
              debounceDelay: const Duration(milliseconds: 500),
              onQueryChanged: (query) {
                if (query.isNotEmpty) {
                  addAddressController.getSuggestions(query);
                }
              },
              progress: addAddressController.isLoading.value,
              transition: SlideFadeFloatingSearchBarTransition(),
              toolbarOptions: ToolbarOptions(
                copy: true,
                paste: true,
                selectAll: true,
              ),
              elevation: 10,
              borderRadius: BorderRadius.circular(30),
              actions: [
                FloatingSearchBarAction(
                  showIfOpened: false,
                  child: CircularButton(
                    icon: const Icon(Icons.place),
                    onPressed: () {},
                  ),
                ),
                FloatingSearchBarAction.searchToClear(
                  showIfClosed: false,
                ),
              ],
              builder: (context, transition) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: Colors.white,
                    elevation: 4.0,
                    child: Container(
                      height: height * 0.5,
                      child: ListView.builder(
                        itemCount: addAddressController.suggestions.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: AutoSizeText(
                              addAddressController.suggestions[i].description,
                              minFontSize: 1,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              body: SingleChildScrollView(
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(selectAddressController.lat.value,
                              selectAddressController.long.value),
                          zoom: 16,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        onTap: (val) async {
                          setState(() {
                            selectAddressController.lat.value = val.latitude;
                            selectAddressController.long.value = val.longitude;
                          });
                          await selectAddressController.getLoc(
                              selectAddressController.lat.value,
                              selectAddressController.long.value);
                        },
                        markers: {
                          Marker(
                            markerId: MarkerId('m1'),
                            position: LatLng(selectAddressController.lat.value,
                                selectAddressController.long.value),
                            infoWindow:
                                InfoWindow(title: 'your current position'),
                          ),
                        },
                      ),
                      Positioned(
                        bottom: 25,
                        left: Get.width * 0.025,
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: Get.width * 0.95,
                            child: selectAddressController.isLoading.value
                                ? Container(
                                    height: 50,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: CircularProgressIndicator(
                                        color: Colors.lightGreen,
                                      ),
                                    ),
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          selectAddressController.address.value,
                                          minFontSize: 1,
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      FloatingActionButton(
                                        onPressed: () {
                                          Get.bottomSheet(
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Form(
                                                  key: selectAddressController
                                                      .key,
                                                  child: Container(
                                                    height:
                                                        Get.height * 0.6 - 20,
                                                    width: Get.width,
                                                    child: ListView(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 10,
                                                            left: 10,
                                                          ),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 5,
                                                              bottom: 5,
                                                              right: 10,
                                                              left: 10,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade900,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  selectAddressController
                                                                      .name,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                              validator: (val) {
                                                                if (val!
                                                                    .isEmpty) {
                                                                  return 'Please give a name for this address!';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved: (val) {
                                                                selectAddressController
                                                                        .name1
                                                                        .value =
                                                                    selectAddressController
                                                                        .name
                                                                        .text;
                                                              },
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    'Give a name for this address',
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 20,
                                                            right: 20,
                                                            bottom: 10,
                                                            top: 2,
                                                          ),
                                                          child: AutoSizeText(
                                                            'eg. Home, Office, etc.',
                                                            minFontSize: 1,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 10,
                                                            left: 10,
                                                            bottom: 15,
                                                          ),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 5,
                                                              bottom: 5,
                                                              right: 10,
                                                              left: 10,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade900,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  selectAddressController
                                                                      .flat,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                              validator: (val) {
                                                                if (val!
                                                                    .isEmpty) {
                                                                  return 'Please enter your flat no. and building name!';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved: (val) {
                                                                selectAddressController
                                                                        .flat1
                                                                        .value =
                                                                    selectAddressController
                                                                        .flat
                                                                        .text;
                                                              },
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    'Enter your flat no. and building name',
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 10,
                                                            left: 10,
                                                            bottom: 15,
                                                          ),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 5,
                                                              bottom: 5,
                                                              right: 10,
                                                              left: 10,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade900,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              controller:
                                                                  selectAddressController
                                                                      .state,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                              validator: (val) {
                                                                if (val!
                                                                    .isEmpty) {
                                                                  return 'Please enter your state!';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved: (val) {
                                                                //addCar.carDetails['color'] = val.toString();
                                                              },
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    'Enter state',
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 10,
                                                            left: 10,
                                                            bottom: 15,
                                                          ),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 5,
                                                              bottom: 5,
                                                              right: 10,
                                                              left: 10,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade900,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              controller:
                                                                  selectAddressController
                                                                      .city,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                              validator: (val) {
                                                                if (val!
                                                                    .isEmpty) {
                                                                  return 'Please enter your city!';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved: (val) {
                                                                //addCar.carDetails['color'] = val.toString();
                                                              },
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    'Enter city',
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 10,
                                                            left: 10,
                                                            bottom: 15,
                                                          ),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 5,
                                                              bottom: 5,
                                                              right: 10,
                                                              left: 10,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade900,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              controller:
                                                                  selectAddressController
                                                                      .pincode,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                              validator: (val) {
                                                                if (val!
                                                                    .isEmpty) {
                                                                  return 'Please enter your pincode!';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved: (val) {
                                                                //addCar.carDetails['color'] = val.toString();
                                                              },
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    'Enter pincode',
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            bottom: 20,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  fixedSize:
                                                                      Size(150,
                                                                          36),
                                                                  primary: Colors
                                                                      .lightGreen,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                child: selectAddressController
                                                                        .isLoading
                                                                        .value
                                                                    ? Container(
                                                                        height:
                                                                            20,
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : AutoSizeText(
                                                                        'ADD',
                                                                        minFontSize:
                                                                            1,
                                                                        maxLines:
                                                                            1,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                onPressed: () {
                                                                  selectAddressController
                                                                      .saveForm();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            backgroundColor: Colors.black,
                                            ignoreSafeArea: false,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25),
                                              ),
                                            ),
                                          );
                                        },
                                        backgroundColor: Colors.lightGreen,
                                        child: Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
    );
  }
}
