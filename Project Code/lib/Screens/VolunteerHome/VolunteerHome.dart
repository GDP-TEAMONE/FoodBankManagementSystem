import 'dart:async';
import 'dart:ui';
import 'package:location/location.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map_location_picker/flutter_map_location_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:flutter_map/flutter_map.dart';
import '../../Model/User.dart';
import '../../Model/availableModel.dart';
import '../../helper/auth_service.dart';
import '../../route.dart';
import '../AssingVolunteer/AssignVolunteer.dart';
import '../Widgets/Appbar.dart';
import '../Widgets/ChatInputField.dart';
import '../Widgets/chat_box.dart';

class VolunteerHome extends StatefulWidget {
  @override
  State<VolunteerHome> createState() => _VolunteerHomeState();
}

class _VolunteerHomeState extends State<VolunteerHome> {
  final TextEditingController _skillController = TextEditingController();
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  final DateRangePickerController _datePickernestedController =
      DateRangePickerController();
  String? startdate, enddate, sstartdate, senddate;
  Future<List<AvailableModel>>? _futureAvailableModels;
  double? latitude;
  double? longitude;
  bool selectlocation = false;
  final Location location = Location();
  late StreamSubscription<LocationData> _locationSubscription;
  int i = 0;
  @override
  void initState() {
    super.initState();
    loadData();
    _getCurrentLocation();
  }

  Future<void> _saveInitialLocation(String id) async {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      LocationData? currentLocation = await location.getLocation();
      await saveLocationToFirestore(
          currentLocation.latitude!, currentLocation.longitude!, id);
    });
  }

  Future<void> saveLocationToFirestore(
      double latitude, double longitude, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('AssignedLocation')
          .doc(id)
          .update({
        'Start Location': GeoPoint(latitude, longitude),
      });
    } catch (e) {
      print('Error saving location: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Location location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw 'Location services are disabled.';
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw 'Location permissions are denied.';
        }
      }

      LocationData currentLocation = await location.getLocation();
      print(currentLocation.toString());
      setState(() {
        latitude = double.parse(currentLocation.latitude.toString());
        longitude = double.parse(currentLocation.longitude.toString());
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> loadData() async {
    setState(() {
      _futureAvailableModels = getAvailables();
    });
  }

  Future<List<AvailableModel>> _dummyFuture() async {
    List<AvailableModel> _dates = [];
    _dates = await getAvailables();
    return _dates;
  }

  Future<List<AvailableModel>> getAvailables() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Availability')
        .where("User", isEqualTo: AuthService.to.user?.id)
        .get();

    List<AvailableModel> availableModels = [];
    for (var doc in querySnapshot.docs) {
      availableModels.add(AvailableModel(
        id: doc.id,
        start: DateTime.parse(doc["Start Date"]),
        end: DateTime.parse(doc["End Date"]),
        name: doc["Name"],
        latitude: doc["Latitude"],
        longitude: doc["Longitude"],
        uid: doc.id,
      ));
    }

    return availableModels;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    void daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      setState(() {});
    }

    int i = 0;
    void _onSelectionChanged(
        DateRangePickerSelectionChangedArgs
            dateRangePickerSelectionChangedArgs) {
      var str = dateRangePickerSelectionChangedArgs.value.toString();
      setState(() {
        if (str.length > 80) {
          startdate = str.substring(33, 43);
          enddate = str.substring(67, 77);
        } else {
          startdate = str.substring(33, 43);
          enddate = str.substring(33, 43);
        }

        daysBetween(DateTime.parse(startdate!), DateTime.parse(enddate!));
      });
    }

    void _onSelectionChangeds(
        DateRangePickerSelectionChangedArgs
            dateRangePickerSelectionChangedArgs) {
      var str = dateRangePickerSelectionChangedArgs.value.toString();
      setState(() {
        if (str.length > 80) {
          sstartdate = str.substring(33, 43);
          senddate = str.substring(67, 77);
        } else {
          sstartdate = str.substring(33, 43);
          senddate = str.substring(33, 43);
        }

        daysBetween(DateTime.parse(sstartdate!), DateTime.parse(senddate!));
      });
    }

    void _submitSkill() {
      final skill = _skillController.text.trim();
      if (skill.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('Skill')
            .doc(AuthService.to.user?.id)
            .collection('Skills')
            .add({'skill': skill});
        _skillController.clear();
      }
    }

    void _deleteSkill(String skill) {
      FirebaseFirestore.instance
          .collection('Skill')
          .doc(AuthService.to.user?.id)
          .collection('Skills')
          .where('skill', isEqualTo: skill)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    }

    Marker buildPin(LatLng point, bool isvolunteer, String name, String id) {
      return Marker(
        point: point,
        width: 35,
        height: 35,
        child: InkWell(
          onTap: () {},
          child: Icon(
              isvolunteer
                  ? Icons.workspace_premium
                  : Icons.location_on_outlined,
              size: 25,
              color: isvolunteer ? Colors.blue : Colors.red),
        ),
      );
    }

    ShowMap(String id) {
      _locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
        saveLocationToFirestore(
            currentLocation.latitude!, currentLocation.longitude!, id);
      });

      _saveInitialLocation(id);
      String status = '';

      FirebaseFirestore.instance
          .collection('InventoryReceive')
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          status = documentSnapshot.get('status');
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: 900,
                height: 600,
                padding: EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    Container(
                      width: 900,
                      height: 590,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Track Volunteer',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              status == "Assigned"
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('InventoryReceive')
                                            .doc(id)
                                            .update({'status': 'Delivered'});
                                        Get.back();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      child: const Text(
                                        'Delivered',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'opensans',
                                            fontSize: 18),
                                      ),
                                    )
                                  : SizedBox(
                                      child: Text("Already Delivered.     "),
                                    ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _locationSubscription.cancel();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  'Close',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'opensans',
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          SizedBox(height: 5),
                          FutureBuilder(
                            future: Future.delayed(const Duration(seconds: 2)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return Container(
                                width: double.infinity,
                                height: 500,
                                child: StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('AssignedLocation')
                                      .doc(id)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    }
                                    GeoPoint? geoPoint1 =
                                        snapshot.data!['Start Location'];
                                    GeoPoint? geoPoint2 =
                                        snapshot.data!['Destination'];
                                    return FlutterMap(
                                      // mapController: mapController,
                                      options: MapOptions(
                                        initialCenter: LatLng(
                                            geoPoint1!.latitude,
                                            geoPoint1.longitude),
                                        initialZoom: 12,
                                        interactionOptions:
                                            const InteractionOptions(
                                          flags: ~InteractiveFlag.doubleTapZoom,
                                        ),
                                      ),
                                      children: [
                                        openStreetMapTileLayer,
                                        MarkerLayer(
                                          markers: [
                                            buildPin(
                                                LatLng(geoPoint1.latitude,
                                                    geoPoint1.longitude),
                                                false,
                                                '',
                                                ''),
                                            buildPin(
                                                LatLng(geoPoint2!.latitude,
                                                    geoPoint2.longitude),
                                                true,
                                                snapshot.data!['VolunteerName'],
                                                ''),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          Expanded(child: SizedBox(height: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          print('Document does not exist');
        }
      }).catchError((error) {
        print('Error getting document: $error');
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg.png"), fit: BoxFit.fill)),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Appbarr(
                  ishome: true,
                ),
                Container(
                  color: Colors.white,
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 230,
                  height: 1,
                  color: Colors.black12,
                ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 45),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.dialog(
                                    Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        width: 400,
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const Text(
                                              'Skills',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Divider(),
                                            SizedBox(height: 15),
                                            TextField(
                                              controller: _skillController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter skill...',
                                              ),
                                              onSubmitted: (_) =>
                                                  _submitSkill(),
                                            ),
                                            SizedBox(height: 20),
                                            Expanded(
                                              child: StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('Skill')
                                                    .doc(
                                                        AuthService.to.user?.id)
                                                    .collection('Skills')
                                                    .snapshots(),
                                                builder: (context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }

                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        'Error: ${snapshot.error}');
                                                  }

                                                  final skills = snapshot
                                                      .data!.docs
                                                      .map(
                                                          (doc) => doc['skill'])
                                                      .toList();

                                                  return GridView.builder(
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 10,
                                                    ),
                                                    itemCount: skills.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final skill =
                                                          skills[index];
                                                      return Stack(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                                    skill)),
                                                          ),
                                                          Positioned(
                                                            top: 0,
                                                            right: 0,
                                                            child: IconButton(
                                                              icon: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () =>
                                                                  _deleteSkill(
                                                                      skill),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text(
                                  'Add Skill',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'opensans',
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              const Text(
                                "Home Page",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  fontFamily: 'inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 200),
                            child: Divider(
                              height: 15,
                              thickness: 4,
                            )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.only(
                                  top: 30, left: 12, right: 13, bottom: 10),
                              width: 300,
                              height: MediaQuery.of(context).size.height - 185,
                              alignment: Alignment.bottomRight,
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Admin Chat Section",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'inter',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(
                                    child: FutureBuilder<
                                        List<Map<String, dynamic>>>(
                                      future: AuthService.to.user?.fetchChats(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: SpinKitFadingCircle(
                                              color: Colors.blueAccent,
                                              size: 30.0,
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return const Center(
                                              child:
                                                  Text('No chats available'));
                                        } else {
                                          return ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            reverse: true,
                                            itemBuilder: (context, index) {
                                              final chat =
                                                  snapshot.data![index];
                                              return ChatBubble(
                                                message: chat['message'],
                                                me: chat['isSelf'],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Divider(),
                                  ChatInputField(
                                    usr: AuthService.to.user!,
                                    refreshChats: () {
                                      setState(() {});
                                    },
                                    isadmin: false,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(10),
                                margin: const EdgeInsets.only(
                                    top: 30, left: 12, right: 13, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        "Select The Date Of Avaiablity",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'inter',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "Select the start and end date you will be avaiable for!",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'inter',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 300,
                                            width: 280,
                                            alignment: Alignment.center,
                                            child: FutureBuilder<
                                                List<AvailableModel>>(
                                              future: _futureAvailableModels,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator()); // Show a loading indicator while fetching data
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  List<AvailableModel> daterr =
                                                      snapshot.data!;
                                                  return SfDateRangePicker(
                                                    view: DateRangePickerView
                                                        .month,
                                                    monthViewSettings:
                                                        DateRangePickerMonthViewSettings(
                                                      firstDayOfWeek: 6,
                                                    ),
                                                    onSelectionChanged:
                                                        _onSelectionChanged,
                                                    selectionMode:
                                                        DateRangePickerSelectionMode
                                                            .range,
                                                    selectableDayPredicate:
                                                        (DateTime dateTime) {
                                                      for (var iss = 0;
                                                          iss < daterr.length;
                                                          iss++) {
                                                        if (dateTime ==
                                                                daterr[iss]
                                                                    .start ||
                                                            dateTime ==
                                                                daterr[iss]
                                                                    .end) {
                                                          return false;
                                                        }
                                                        for (int i = 0;
                                                            i <=
                                                                daterr[iss]
                                                                    .end
                                                                    .difference(
                                                                        daterr[iss]
                                                                            .start)
                                                                    .inDays;
                                                            i++) {
                                                          if (dateTime ==
                                                              daterr[iss]
                                                                  .start
                                                                  .add(Duration(
                                                                      days:
                                                                          i))) {
                                                            return false;
                                                          }
                                                        }
                                                      }
                                                      return true;
                                                    },
                                                    enablePastDates: false,
                                                    showActionButtons: false,
                                                    controller:
                                                        _datePickerController,
                                                  );
                                                }
                                              },
                                            )),
                                        Expanded(
                                          child: Container(
                                            width: 400,
                                            height: 300,
                                            child: MapLocationPicker(
                                              initialLatitude: latitude,
                                              initialLongitude: longitude,
                                              onPicked: (result) {},
                                              backgroundColor: Colors.white,
                                              centerWidget: const Icon(
                                                Icons.add,
                                                size: 40,
                                                color: Colors.blue,
                                              ),
                                              sideButtonsColor: Colors.blue,
                                              customFooter:
                                                  (result, controller) {
                                                return Container();
                                              },
                                              myLocationButtonEnabled: true,
                                              zoomButtonEnabled: true,
                                              searchBarEnabled: false,
                                              switchMapTypeEnabled: false,
                                              mapType: MapType.normal,
                                              sideWidget: (result, controller) {
                                                return TextButton.icon(
                                                  onPressed: () {
                                                    latitude = result.latitude;
                                                    longitude =
                                                        result.longitude;
                                                    selectlocation = true;
                                                    setState(() {});
                                                  },
                                                  label: const Text(
                                                    "Select Location",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.blue)),
                                                  icon: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 7.0),
                                    Text(
                                      selectlocation
                                          ? "     Current Location :- Latitude : $latitude, Longitude : $longitude."
                                          : "    Select Location :",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'inter',
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Divider(),
                                    SizedBox(height: 20.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.dialog(
                                              Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Container(
                                                  width: 900,
                                                  padding: EdgeInsets.all(20.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Edit Available Date',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                                Icons.cancel),
                                                            onPressed:
                                                                () async {
                                                              Get.back();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Divider(),
                                                      SizedBox(height: 15),
                                                      const Text(
                                                        "Change the available date or delete them.",
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      SizedBox(height: 15),
                                                      FutureBuilder<
                                                              List<
                                                                  AvailableModel>>(
                                                          future:
                                                              _dummyFuture(),
                                                          builder:
                                                              (context, ss) {
                                                            if (ss.connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            } else {
                                                              return Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    DataTable(
                                                                  headingRowColor:
                                                                      MaterialStateColor.resolveWith(
                                                                          (states) =>
                                                                              Colors.blueAccent!),
                                                                  headingTextStyle: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'opensans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  border: TableBorder.all(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .black12),
                                                                  columns: const [
                                                                    DataColumn(
                                                                        label: Text(
                                                                            'SL')),
                                                                    DataColumn(
                                                                        label: Text(
                                                                            'Start Date')),
                                                                    DataColumn(
                                                                        label: Text(
                                                                            'End Date')),
                                                                    DataColumn(
                                                                        label: Text(
                                                                            'Longitude')),
                                                                    DataColumn(
                                                                        label: Text(
                                                                            'Latitude')),
                                                                    DataColumn(
                                                                        label: Text(
                                                                            'Edit')),
                                                                    DataColumn(
                                                                        label: Text(
                                                                            'Delete')),
                                                                  ],
                                                                  rows: ss.data!
                                                                      .map(
                                                                          (doc) {
                                                                    i++;
                                                                    return DataRow(
                                                                      cells: [
                                                                        DataCell(
                                                                            Text(i.toString())),
                                                                        DataCell(
                                                                            Text(DateFormat.yMMMMd().format(doc.start))),
                                                                        DataCell(
                                                                            Text(DateFormat.yMMMMd().format(doc.end))),
                                                                        DataCell(Text(doc
                                                                            .longitude
                                                                            .toString())),
                                                                        DataCell(Text(doc
                                                                            .latitude
                                                                            .toString())),
                                                                        DataCell(
                                                                            IconButton(
                                                                          icon:
                                                                              Icon(Icons.edit),
                                                                          onPressed:
                                                                              () {
                                                                            Get.dialog(
                                                                              Dialog(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                  child: Container(
                                                                                    child: Container(
                                                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                        height: 300,
                                                                                        width: MediaQuery.of(context).size.width / 3,
                                                                                        alignment: Alignment.center,
                                                                                        child: FutureBuilder<List<AvailableModel>>(
                                                                                          future: _futureAvailableModels,
                                                                                          builder: (context, snapshot) {
                                                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                              return Center(child: CircularProgressIndicator()); // Show a loading indicator while fetching data
                                                                                            } else if (snapshot.hasError) {
                                                                                              return Text('Error: ${snapshot.error}');
                                                                                            } else {
                                                                                              List<AvailableModel> daterr = snapshot.data!;
                                                                                              return SfDateRangePicker(
                                                                                                view: DateRangePickerView.month,
                                                                                                monthViewSettings: const DateRangePickerMonthViewSettings(
                                                                                                  firstDayOfWeek: 6,
                                                                                                ),
                                                                                                onSelectionChanged: _onSelectionChangeds,
                                                                                                selectionMode: DateRangePickerSelectionMode.range,
                                                                                                selectableDayPredicate: (DateTime dateTime) {
                                                                                                  for (var iss = 0; iss < daterr.length; iss++) {
                                                                                                    if (daterr[iss].id != doc.id) {
                                                                                                      if (dateTime == daterr[iss].start || dateTime == daterr[iss].end) {
                                                                                                        return false;
                                                                                                      }
                                                                                                      for (int i = 0; i <= daterr[iss].end.difference(daterr[iss].start).inDays; i++) {
                                                                                                        if (dateTime == daterr[iss].start.add(Duration(days: i))) {
                                                                                                          return false;
                                                                                                        }
                                                                                                      }
                                                                                                    }
                                                                                                  }
                                                                                                  return true;
                                                                                                },
                                                                                                onCancel: () {
                                                                                                  Get.back();
                                                                                                },
                                                                                                onSubmit: (val) async {
                                                                                                  if (sstartdate == null || senddate == null) {
                                                                                                    Get.snackbar(
                                                                                                      "Availability Update Failed",
                                                                                                      "Please Select A Dates To Proceed.",
                                                                                                      snackPosition: SnackPosition.BOTTOM,
                                                                                                      colorText: Colors.white,
                                                                                                      backgroundColor: Colors.red,
                                                                                                      margin: EdgeInsets.zero,
                                                                                                      duration: const Duration(milliseconds: 2000),
                                                                                                      boxShadows: [
                                                                                                        const BoxShadow(
                                                                                                          color: Colors.grey,
                                                                                                          offset: Offset(-100, 0),
                                                                                                          blurRadius: 20,
                                                                                                        ),
                                                                                                      ],
                                                                                                      borderRadius: 0,
                                                                                                    );
                                                                                                  } else if (latitude == null || longitude == null) {
                                                                                                    Get.snackbar(
                                                                                                      "Availability Update Failed",
                                                                                                      "Please Select The Location.",
                                                                                                      snackPosition: SnackPosition.BOTTOM,
                                                                                                      colorText: Colors.white,
                                                                                                      backgroundColor: Colors.red,
                                                                                                      margin: EdgeInsets.zero,
                                                                                                      duration: const Duration(milliseconds: 2000),
                                                                                                      boxShadows: [
                                                                                                        const BoxShadow(
                                                                                                          color: Colors.grey,
                                                                                                          offset: Offset(-100, 0),
                                                                                                          blurRadius: 20,
                                                                                                        ),
                                                                                                      ],
                                                                                                      borderRadius: 0,
                                                                                                    );
                                                                                                  } else {
                                                                                                    FirebaseFirestore.instance.collection('Availability').doc(doc.id).update({
                                                                                                      'Start Date': sstartdate,
                                                                                                      'End Date': senddate,
                                                                                                      'User': AuthService.to.user?.id,
                                                                                                      'Name': AuthService.to.user?.name,
                                                                                                      'Longitude': longitude,
                                                                                                      'Latitude': latitude,
                                                                                                    }).then((value) {
                                                                                                      Get.back();
                                                                                                      Get.back();
                                                                                                      loadData();
                                                                                                      setState(() {});
                                                                                                      Get.snackbar(
                                                                                                        "Availability Updated Successfully.",
                                                                                                        "You Are Now Available From $sstartdate to $senddate!",
                                                                                                        snackPosition: SnackPosition.BOTTOM,
                                                                                                        colorText: Colors.white,
                                                                                                        backgroundColor: Colors.green,
                                                                                                        margin: EdgeInsets.zero,
                                                                                                        duration: const Duration(milliseconds: 2000),
                                                                                                        boxShadows: [
                                                                                                          const BoxShadow(
                                                                                                            color: Colors.grey,
                                                                                                            offset: Offset(-100, 0),
                                                                                                            blurRadius: 20,
                                                                                                          ),
                                                                                                        ],
                                                                                                        borderRadius: 0,
                                                                                                      );
                                                                                                    });
                                                                                                  }
                                                                                                },
                                                                                                enablePastDates: false,
                                                                                                showActionButtons: true,
                                                                                                controller: _datePickernestedController,
                                                                                              );
                                                                                            }
                                                                                          },
                                                                                        )),
                                                                                  )),
                                                                            );
                                                                          },
                                                                        )),
                                                                        DataCell(
                                                                            IconButton(
                                                                          icon:
                                                                              Icon(Icons.delete),
                                                                          onPressed:
                                                                              () async {
                                                                            await FirebaseFirestore.instance.collection('Availability').doc(doc.id).delete().then((value) {
                                                                              Get.back();
                                                                              loadData();
                                                                            });
                                                                          },
                                                                        )),
                                                                      ],
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              );
                                                            }
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 120,
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: const Text(
                                              "Cancel Available",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                fontFamily: 'inter',
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (startdate == null ||
                                                enddate == null) {
                                              Get.snackbar(
                                                "Availability Saving Failed",
                                                "Please Select A Date To Proceed.",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                colorText: Colors.white,
                                                backgroundColor: Colors.red,
                                                margin: EdgeInsets.zero,
                                                duration: const Duration(
                                                    milliseconds: 2000),
                                                boxShadows: [
                                                  const BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(-100, 0),
                                                    blurRadius: 20,
                                                  ),
                                                ],
                                                borderRadius: 0,
                                              );
                                            } else if (latitude == null ||
                                                longitude == null) {
                                              Get.snackbar(
                                                "Availability Update Failed",
                                                "Please Select The Location.",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                colorText: Colors.white,
                                                backgroundColor: Colors.red,
                                                margin: EdgeInsets.zero,
                                                duration: const Duration(
                                                    milliseconds: 2000),
                                                boxShadows: [
                                                  const BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(-100, 0),
                                                    blurRadius: 20,
                                                  ),
                                                ],
                                                borderRadius: 0,
                                              );
                                            } else {
                                              FirebaseFirestore.instance
                                                  .collection('Availability')
                                                  .add({
                                                'Start Date': startdate,
                                                'End Date': enddate,
                                                'status': false,
                                                'User': AuthService.to.user?.id,
                                                'Name':
                                                    AuthService.to.user?.name,
                                                'Longitude': longitude,
                                                'Latitude': latitude,
                                              }).then((value) {
                                                Get.snackbar(
                                                  "Availability Added Successful.",
                                                  "You Are Now Available From $startdate to $enddate!",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  colorText: Colors.white,
                                                  backgroundColor: Colors.green,
                                                  margin: EdgeInsets.zero,
                                                  duration: const Duration(
                                                      milliseconds: 2000),
                                                  boxShadows: [
                                                    const BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(-100, 0),
                                                      blurRadius: 20,
                                                    ),
                                                  ],
                                                  borderRadius: 0,
                                                );
                                                loadData();
                                                setState(() {});
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              "Set Available",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                fontFamily: 'inter',
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height - 185,
                              width: 320,
                              margin: const EdgeInsets.only(
                                  top: 30, left: 12, right: 13, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    "Assigned Jobs   ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'inter',
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('AssignedLocation')
                                        .where("Volunteerid",
                                            isEqualTo: AuthService.to.user?.id)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox(
                                            width: 200,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()));
                                      }

                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }

                                      final List<DataRow> rows = snapshot
                                          .data!.docs
                                          .map<DataRow>((doc) {
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                                FutureBuilder<DocumentSnapshot>(
                                              future: FirebaseFirestore.instance
                                                  .collection(
                                                      'InventoryReceive')
                                                  .doc(doc.id)
                                                  .get(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<
                                                          DocumentSnapshot>
                                                      userSnapshot) {
                                                if (userSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return SizedBox();
                                                }
                                                if (userSnapshot.hasError) {
                                                  return Text(
                                                      'Error: ${userSnapshot.error}');
                                                }
                                                final userData =
                                                    userSnapshot.data!.data()
                                                        as Map<String, dynamic>;

                                                return Text(
                                                    userData['status'] ?? '');
                                              },
                                            )),
                                            DataCell(
                                              ElevatedButton(
                                                onPressed: () {
                                                  ShowMap(doc.id);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                ),
                                                child: const Text(
                                                  'View',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'opensans',
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList();

                                      return Expanded(
                                        child: DataTable(
                                          headingRowColor:
                                              MaterialStateColor.resolveWith(
                                            (states) => Colors.blueAccent,
                                          ),
                                          headingTextStyle: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'opensans',
                                              fontWeight: FontWeight.bold),
                                          border: TableBorder.all(
                                              width: 1, color: Colors.black12),
                                          columns: [
                                            DataColumn(
                                                label: SizedBox(
                                                    width: 120,
                                                    child: Text('Status'))),
                                            DataColumn(
                                                label: SizedBox(
                                                    width: 70,
                                                    child: Text('Action'))),
                                          ],
                                          rows: rows,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 150,
              height: 150,
              margin: const EdgeInsets.only(left: 10, top: 10),
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
