import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodbankmanagementsystem/helper/values.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../Model/FoodDonation.dart';
import '../../Model/User.dart';
import '../../helper/auth_service.dart';
import '../../route.dart';
import '../Widgets/Appbar.dart';
import '../Widgets/ChatInputField.dart';
import '../Widgets/chat_box.dart';

class DonationAdmin extends StatefulWidget {
  @override
  State<DonationAdmin> createState() => _DonationAdminState();
}

class _DonationAdminState extends State<DonationAdmin> {
  int showAll = 0;
  bool isspin = false;
  _addtoinventory(DocumentSnapshot doc) async {
    setState(() {
      isspin = true;
    });
    var foods = doc['foods'] as List<dynamic>;
    for (int i = 0; i < foods.length; i++) {
      var food = foods[i];
      var name = food['name'] as String?;
      await FirebaseFirestore.instance
          .collection('Inventory')
          .doc(food['name'])
          .get()
          .then((value) async {
        if (value.exists) {
          await FirebaseFirestore.instance
              .collection('Inventory')
              .doc(food['name'])
              .set({
            'Name': name,
            'Category': food['category'],
            'Quantity': food['quantity'] + value["Quantity"],
            'expiredate': doc['expirationDate'],
          }).then((value) {
            if (i == foods.length - 1) {
              FirebaseFirestore.instance
                  .collection('FoodDonation')
                  .doc(doc.id)
                  .update({'status': "Added To Inventory"}).then((value) {
                setState(() {
                  isspin = false;
                });
                Get.back();
                Get.snackbar(
                  "Inventory Updated Successfully.",
                  "The item added to the inventory.",
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
          });
        } else {
          await FirebaseFirestore.instance
              .collection('Inventory')
              .doc(food['name'])
              .set({
            'Name': name,
            'Category': food['category'],
            'Quantity': food['quantity'],
            'expiredate': doc['expirationDate'],
          }).then((value) {
            if (i == foods.length - 1) {
              FirebaseFirestore.instance
                  .collection('FoodDonation')
                  .doc(doc.id)
                  .update({'status': "Added To Inventory"}).then((value) {
                setState(() {
                  isspin = false;
                });
                Get.back();
                Get.snackbar(
                  "Inventory Updated Successfully.",
                  "The item added to the inventory.",
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
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    int i = 0;
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
                            "Donation Page",
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
                                      "All Donation List        ",
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showAll = 0;
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: showAll == 0
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                borderRadius: const BorderRadius
                                                    .horizontal(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: showAll == 1
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                borderRadius: const BorderRadius
                                                    .horizontal(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('FoodDonation')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return SizedBox(
                                                width: 200,
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              );
                                            }

                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            }
                                            final List<DocumentSnapshot>
                                                documents = snapshot.data!.docs;

                                            final filteredDocuments = showAll ==
                                                    0
                                                ? documents
                                                : documents.where((doc) {
                                                    final donation =
                                                        FoodDonation.fromMap(
                                                            doc.data() as Map<
                                                                String,
                                                                dynamic>);
                                                    return donation.status ==
                                                        "Requested";
                                                  }).toList();
                                            return DataTable(
                                              headingRowColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Colors.blueAccent!),
                                              headingTextStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'opensans',
                                                  fontWeight: FontWeight.bold),
                                              border: TableBorder.all(
                                                  width: 1,
                                                  color: Colors.black12),
                                              columns: [
                                                DataColumn(label: Text('SL')),
                                                DataColumn(
                                                    label:
                                                        Text('Requested User')),
                                                DataColumn(
                                                    label: Text('Items')),
                                                DataColumn(
                                                    label: Text(
                                                        'Delivery Option')),
                                                DataColumn(
                                                    label:
                                                        Text('Request Date')),
                                                DataColumn(
                                                    label: Text('Status')),
                                                DataColumn(
                                                    label: Text('Action')),
                                              ],
                                              rows:
                                                  filteredDocuments.map((doc) {
                                                final donation =
                                                    FoodDonation.fromMap(
                                                        doc.data() as Map<
                                                            String, dynamic>);
                                                var foods = doc['foods']
                                                    as List<dynamic>;
                                                String foodNames = '';
                                                for (var food in foods) {
                                                  var name =
                                                      food['name'] as String?;
                                                  var quantity =
                                                      food['quantity'];
                                                  if (name != null) {
                                                    foodNames =
                                                        "$foodNames$name- $quantity, ";
                                                  }
                                                }

                                                i++;
                                                return DataRow(
                                                  cells: [
                                                    DataCell(
                                                        Text(i.toString())),
                                                    DataCell(FutureBuilder<
                                                        DocumentSnapshot>(
                                                      future: FirebaseFirestore
                                                          .instance
                                                          .collection('Users')
                                                          .doc(donation
                                                              .requestedBy)
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
                                                        if (userSnapshot
                                                            .hasError) {
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
                                                        return Text(
                                                            username ?? '');
                                                      },
                                                    )),
                                                    DataCell(
                                                      Container(
                                                          width: 550,
                                                          child:
                                                              Text(foodNames)),
                                                    ),
                                                    DataCell(Text(donation
                                                        .deliveryOption)),
                                                    DataCell(Text(DateFormat
                                                            .yMMMMd()
                                                        .format(donation
                                                            .requesteddate))),
                                                    DataCell(
                                                        Text(donation.status)),
                                                    DataCell(
                                                        donation.status ==
                                                                "Requested"
                                                            ? IconButton(
                                                                icon: Icon(Icons
                                                                    .more_outlined),
                                                                onPressed: () {
                                                                  Get.dialog(
                                                                    Dialog(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            700,
                                                                        height:
                                                                            250,
                                                                        padding:
                                                                            EdgeInsets.all(20.0),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Container(
                                                                              width: 700,
                                                                              height: 350,
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  const Text(
                                                                                    'Proceed Donation',
                                                                                    style: TextStyle(
                                                                                      fontSize: 20,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: 10),
                                                                                  Divider(),
                                                                                  SizedBox(height: 15),
                                                                                  Text(
                                                                                    "Update The donation Status. Either Add To the Inventory Or Directly Donate to recipient.",
                                                                                    style: TextStyle(fontSize: 16),
                                                                                  ),
                                                                                  Expanded(child: SizedBox(height: 20)),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      ElevatedButton(
                                                                                        onPressed: () {
                                                                                          Get.back();
                                                                                        },
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          backgroundColor: Colors.grey,
                                                                                        ),
                                                                                        child: const Text(
                                                                                          'Cancel',
                                                                                          style: TextStyle(color: Colors.white, fontFamily: 'opensans', fontSize: 18),
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(width: 20),
                                                                                      ElevatedButton(
                                                                                        onPressed: () {
                                                                                          FirebaseFirestore.instance.collection('FoodDonation').doc(doc.id).delete().then((value) {
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
                                                                                      const SizedBox(width: 20),
                                                                                      ElevatedButton(
                                                                                        onPressed: () => _addtoinventory(doc),
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          backgroundColor: Colors.green,
                                                                                        ),
                                                                                        child: const Text(
                                                                                          'Add To Inventory',
                                                                                          style: TextStyle(color: Colors.white, fontFamily: 'opensans', fontSize: 18),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: 680,
                                                                              height: 230,
                                                                              child: isspin
                                                                                  ? SpinKitFadingCircle(
                                                                                      color: Colors.green,
                                                                                      size: 100.0,
                                                                                    )
                                                                                  : SizedBox(),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                            : SizedBox()),
                                                  ],
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
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
