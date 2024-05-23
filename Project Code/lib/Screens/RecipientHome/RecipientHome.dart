import 'dart:ui';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodbankmanagementsystem/Model/InventoryModel.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../Model/User.dart';
import '../../helper/auth_service.dart';
import '../../route.dart';
import '../AssingVolunteer/AssignVolunteer.dart';
import '../Widgets/Appbar.dart';
import '../Widgets/ChatInputField.dart';
import '../Widgets/chat_box.dart';
import 'package:latlong2/latlong.dart';

class RecipientHome extends StatefulWidget {
  @override
  State<RecipientHome> createState() => _RecipientHomeState();
}

class _RecipientHomeState extends State<RecipientHome> {
  List<String> names = [];
  bool first = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
                          Text(
                            'Track Volunteer',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('InventoryReceive')
                                  .doc(id)
                                  .update({'status': 'Received'}).then((value) {
                                FirebaseFirestore.instance
                                    .collection('AssignedLocation')
                                    .doc(id)
                                    .delete();
                                Get.back();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text(
                              'Received',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'opensans',
                                  fontSize: 18),
                            ),
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
                            return Center(child: CircularProgressIndicator());
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
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }
                                GeoPoint? geoPoint1 =
                                    snapshot.data!['Start Location'];
                                GeoPoint? geoPoint2 =
                                    snapshot.data!['Destination'];
                                print(geoPoint2.toString());
                                return FlutterMap(
                                  // mapController: mapController,
                                  options: MapOptions(
                                    initialCenter: LatLng(geoPoint1!.latitude,
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
                const SizedBox(
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
                            "Home Page",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              fontFamily: 'inter',
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                height:
                                    MediaQuery.of(context).size.height - 185,
                                alignment: Alignment.bottomRight,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Admin Chat Section",
                                            style: TextStyle(
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
                                        future:
                                            AuthService.to.user?.fetchChats(),
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
                                )),
                            Container(
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "All Inventory Request List   ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'inter',
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('InventoryReceive')
                                          .where("requested by",
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
                                          var foods =
                                              doc['Items'] as List<dynamic>;
                                          String ss = '';
                                          for (var food in foods) {
                                            var name = food['name'] as String?;
                                            var quan = food['quantity'];
                                            if (name != null) {
                                              ss += "$name- $quan, ";
                                            }
                                          }
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(ss)),
                                              DataCell(Text(
                                                  doc['Latitude'].toString())),
                                              DataCell(Text(
                                                  doc['Longitude'].toString())),
                                              DataCell(doc['status'] ==
                                                          "Assigned" ||
                                                      doc['status'] == "Delivered"
                                                  ? Row(
                                                      children: [
                                                        Text(doc['status']),
                                                        IconButton(
                                                            onPressed: () {
                                                              ShowMap(doc.id);
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .location_on_outlined,
                                                              color: Colors.blue,
                                                            ))
                                                      ],
                                                    )
                                                  : Text(doc['status'])),
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
                                              width: 1, color: Colors.black12),
                                          columns: [
                                            DataColumn(
                                                label: SizedBox(
                                                    width: 130,
                                                    child: Text('Items Name'))),
                                            DataColumn(
                                                label: SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      'Latitude',
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
                                          ],
                                          rows: rows,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 185,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(recipientBuyPageRoute);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 35),
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Text(
                                          "Get Items From Inventory",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'opensans',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
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
