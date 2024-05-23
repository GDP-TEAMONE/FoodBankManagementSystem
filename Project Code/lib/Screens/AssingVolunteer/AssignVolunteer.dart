import 'dart:async';
import 'dart:ui';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodbankmanagementsystem/helper/values.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../../Model/InventoryReceive.dart';
import '../Widgets/Appbar.dart';

class AssignVolunteer extends StatefulWidget {
  @override
  State<AssignVolunteer> createState() => _AssignVolunteerState();
}

class _AssignVolunteerState extends State<AssignVolunteer> {
  int showAll = 0;
  bool isspin = false;
  late LatLng destination;
  late String sid, fid;
  late String recipientid;

  late MapController mapController;
  final customMarkers = <Marker>[];
  List<String> names = [];

  Marker buildPin(LatLng point, bool isvolunteer, String name, String id) =>
      Marker(
        point: point,
        width: 35,
        height: 35,
        child: InkWell(
          onTap: () {
            if (isvolunteer) {
              Get.defaultDialog<bool>(
                title: 'Confirmation',
                titlePadding: EdgeInsets.all(20),
                contentPadding: EdgeInsets.all(20),
                titleStyle: TextStyle(color: Colors.white),
                backgroundColor: Colors.blue,
                content: Text(
                    'Are you sure you want to Assign Volunteer: $name with this Request?'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Get.back(result: false),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DocumentSnapshot inventoryReceiveDoc =
                          await FirebaseFirestore.instance
                              .collection('InventoryReceive')
                              .doc(sid)
                              .get();
                      List<dynamic> items = inventoryReceiveDoc['Items'];
                      bool inventorySufficient = true;
                      for (var item in items) {
                        String itemName = item['name'];
                        int quantityReceived = item['quantity'];

                        DocumentSnapshot inventoryDoc = await FirebaseFirestore
                            .instance
                            .collection('Inventory')
                            .doc(itemName)
                            .get();
                        int currentQuantity = inventoryDoc['Quantity'];
                        if (currentQuantity < quantityReceived) {
                          inventorySufficient = false;
                          break;
                        }
                      }

                      if (inventorySufficient) {
                        await FirebaseFirestore.instance
                            .collection('AssignedLocation')
                            .doc(sid)
                            .set({
                          'Start Location':
                              GeoPoint(point.latitude, point.longitude),
                          'Destination': GeoPoint(
                              destination.latitude, destination.longitude),
                          'Volunteerid': id,
                          'Recipientid': recipientid,
                          'VolunteerName': name,
                        }).then((value) async {
                          // Deduct quantities from inventory
                          for (var item in items) {
                            String itemName = item['name'];
                            int quantityReceived = item['quantity'];

                            DocumentSnapshot inventoryDoc =
                                await FirebaseFirestore.instance
                                    .collection('Inventory')
                                    .doc(itemName)
                                    .get();

                            int currentQuantity = inventoryDoc['Quantity'];
                            int updatedQuantity =
                                currentQuantity - quantityReceived;

                            await FirebaseFirestore.instance
                                .collection('Inventory')
                                .doc(itemName)
                                .update({'Quantity': updatedQuantity});
                          }

                          await FirebaseFirestore.instance
                              .collection('InventoryReceive')
                              .doc(sid)
                              .update({'status': 'Assigned'});
                          Get.back();
                          Get.back();
                          Get.snackbar(
                            "Volunteer Assigned Successfully.",
                            "You Can Track Order Volunteer!",
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
                      } else {
                        Get.snackbar(
                          "Insufficient Inventory",
                          "Some items are not Available in the Inventory Currently. Wait For Donations.",
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
                      }
                    },
                    child: Text('Confirm'),
                  ),
                ],
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Location of the Recipient Name: $name',
                    style: TextStyle(color: Colors.white),
                  ),
                  duration: const Duration(seconds: 1),
                  showCloseIcon: true,
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: Icon(
              isvolunteer ? Icons.workspace_premium : Icons.volunteer_activism,
              size: 25,
              color: isvolunteer ? Colors.blue : Colors.red),
        ),
      );

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _getAvailable();
  }

  Future<void> _getAvailable() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Availability').get();
    DateTime today = DateTime.now();
    for (var doc in querySnapshot.docs) {
      if (!doc['status']) {
        DateTime startDate = DateTime.parse(doc["Start Date"]);
        DateTime endDate = DateTime.parse(doc["End Date"]);
        if ((today.year == startDate.year &&
                today.month == startDate.month &&
                today.day >= startDate.day) &&
            (today.year == endDate.year &&
                today.month == endDate.month &&
                today.day <= endDate.day)) {
          customMarkers.add(buildPin(
            LatLng(doc["Latitude"], doc["Longitude"]),
            true,
            doc["Name"],
            doc['User'],
          ));
        }
      }
    }
  }

  bool first = true;

  void _zoomToMarker(LatLng ps) {
    mapController.move(ps, 15.0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    int isss = 0;

    if (first) {
      Future.delayed(Duration(seconds: 5), () {
        if (customMarkers.isNotEmpty) {
          _zoomToMarker(customMarkers[0].point);
        }
      });
      first = false;
    }


    ShowMap(String id) {
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
                  ishome: false,
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
                          child: const Text(
                            "All Assigning Page",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              fontFamily: 'opensans',
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 200),
                            child: Divider(
                              height: 15,
                              thickness: 4,
                            )),
                        Row(
                          children: [
                            Container(
                              width: screenWidth - 30,
                              height: MediaQuery.of(context).size.height - 185,
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
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "All Recipient Request and Volunteer Assign        ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'opensans',
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: screenWidth - 25,
                                      height: 1,
                                      color: Colors.black54,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        right: 35,
                                        top: 10,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showAll = 0;
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: showAll == 0
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                borderRadius:
                                                    const BorderRadius.horizontal(
                                                  left: Radius.circular(20),
                                                ),
                                                border: Border.all(
                                                  color: Colors.blue,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                'Show All',
                                                style: TextStyle(
                                                  fontFamily: 'inter',
                                                  color: showAll == 0
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showAll = 1;
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: showAll == 1
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                borderRadius:
                                                    const BorderRadius.horizontal(
                                                  right: Radius.circular(20),
                                                ),
                                                border: Border.all(
                                                  color: Colors.blue,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                'Requested',
                                                style: TextStyle(
                                                  fontFamily: 'inter',
                                                  color: showAll == 1
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('InventoryReceive')
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
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            }
                                
                                            final List<DocumentSnapshot>
                                                documents = snapshot.data!.docs;
                                            final filteredDocuments = showAll == 0
                                                ? documents
                                                : documents.where((doc) {
                                                    final donation =
                                                        InventoryReceive.fromMap(
                                                            doc.data() as Map<
                                                                String, dynamic>);
                                                    return donation.status ==
                                                        "Requested";
                                                  }).toList();
                                
                                            final List<DataRow> rows =
                                                filteredDocuments
                                                    .map<DataRow>((doc) {
                                              var foods =
                                                  doc['Items'] as List<dynamic>;
                                              String ss = '';
                                              for (var food in foods) {
                                                var name =
                                                    food['name'] as String?;
                                                var quan = food['quantity'];
                                                if (name != null) {
                                                  ss += "$name- $quan, ";
                                                }
                                              }
                                              isss++;
                                              return DataRow(
                                                cells: [
                                                  DataCell(
                                                      Text((isss).toString())),
                                                  DataCell(FutureBuilder<
                                                      DocumentSnapshot>(
                                                    future: FirebaseFirestore
                                                        .instance
                                                        .collection('Users')
                                                        .doc(doc['requested by'])
                                                        .get(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                DocumentSnapshot>
                                                            userSnapshot) {
                                                      if (userSnapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return SizedBox();
                                                      }
                                                      if (userSnapshot.hasError) {
                                                        return Text(
                                                            'Error: ${userSnapshot.error}');
                                                      }
                                                      final userData =
                                                          userSnapshot.data!
                                                                  .data()
                                                              as Map<String,
                                                                  dynamic>;
                                                      final username =
                                                          userData['Name']
                                                              as String?;
                                                      names.add(username!);
                                                      return Text(username ?? '');
                                                    },
                                                  )),
                                                  DataCell(Text(ss)),
                                                  DataCell(Text(doc['Latitude']
                                                      .toString())),
                                                  DataCell(Text(doc['Longitude']
                                                      .toString())),
                                                  DataCell(Text(doc['status'])),
                                                  DataCell(
                                                      doc['status'] == "Requested"
                                                          ? IconButton(
                                                              icon: Icon(Icons
                                                                  .more_outlined),
                                                              onPressed: () {
                                                                sid = doc.id;
                                                                recipientid = doc[
                                                                    'requested by'];
                                                                destination = LatLng(
                                                                    doc["Latitude"],
                                                                    doc["Longitude"]);
                                                                customMarkers
                                                                    .add(buildPin(
                                                                  LatLng(
                                                                      doc["Latitude"],
                                                                      doc["Longitude"]),
                                                                  false,
                                                                  names[isss - 1],
                                                                  doc['requested by'],
                                                                ));
                                                                setState(() {});
                                
                                                                Get.dialog(
                                                                  Dialog(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      width: 900,
                                                                      height: 600,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              20.0),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                900,
                                                                            height:
                                                                                590,
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize:
                                                                                  MainAxisSize.min,
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    const Text(
                                                                                      'Assign Available Volunteer',
                                                                                      style: TextStyle(
                                                                                        fontSize: 20,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        FirebaseFirestore.instance.collection('InventoryReceive').doc(doc.id).delete().then((value) {
                                                                                          Get.back();
                                                                                          setState(() {});
                                                                                        });
                                                                                      },
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: Colors.red,
                                                                                      ),
                                                                                      child: const Text(
                                                                                        'Delete',
                                                                                        style: TextStyle(color: Colors.white, fontFamily: 'opensans', fontSize: 18),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 5),
                                                                                Divider(),
                                                                                SizedBox(height: 5),
                                                                                Container(
                                                                                  width: double.infinity,
                                                                                  height: 500,
                                                                                  child: FlutterMap(
                                                                                    mapController: mapController,
                                                                                    options: MapOptions(
                                                                                      initialCenter: const LatLng(37.417931512052306, -122.08230266766806),
                                                                                      initialZoom: 5,
                                                                                      onTap: (_, p) {
                                                                                        // customMarkers.add(buildPin(
                                                                                        //   p,
                                                                                        // )
                                                                                      },
                                                                                      interactionOptions: const InteractionOptions(
                                                                                        flags: ~InteractiveFlag.doubleTapZoom,
                                                                                      ),
                                                                                    ),
                                                                                    children: [
                                                                                      openStreetMapTileLayer,
                                                                                      MarkerLayer(
                                                                                        markers: customMarkers,
                                                                                        rotate: false,
                                                                                        alignment: Alignment.topCenter,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Expanded(child: SizedBox(height: 10)),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          isspin
                                                                              ? Container(
                                                                                  width: 900,
                                                                                  height: 530,
                                                                                  child: const SpinKitFadingCircle(
                                                                                    color: Colors.green,
                                                                                    size: 100.0,
                                                                                  ),
                                                                                )
                                                                              : SizedBox(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ):
                                                      doc['status'] == "Assigned"
                                                          ?
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
                                                  ): SizedBox()),
                                                ],
                                              );
                                            }).toList();
                                
                                            return DataTable(
                                              headingRowColor:
                                                  MaterialStateColor.resolveWith(
                                                (states) => Colors.blueAccent,
                                              ),
                                              headingTextStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'opensans',
                                                  fontWeight: FontWeight.bold),
                                              border: TableBorder.all(
                                                  width: 1,
                                                  color: Colors.black12),
                                              columns: const [
                                                DataColumn(label: Text('SL')),
                                                DataColumn(
                                                    label:
                                                        Text('Requested User')),
                                                DataColumn(
                                                    label: SizedBox(
                                                        width: 130,
                                                        child:
                                                            Text('Items Name'))),
                                                DataColumn(
                                                    label: SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                          'Latiude',
                                                        ))),
                                                DataColumn(
                                                    label: SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                          'Longitude',
                                                        ))),
                                                DataColumn(
                                                    label: SizedBox(
                                                        width: 70,
                                                        child: Text('Status'))),
                                                DataColumn(
                                                    label: SizedBox(
                                                        width: 70,
                                                        child: Text('Action'))),
                                              ],
                                              rows: rows,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
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

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
