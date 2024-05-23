import 'dart:ui';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../Model/InventoryModel.dart';
import '../../helper/values.dart';
import '../FoodDonorHome/DonationRequest.dart';
import '../Widgets/Appbar.dart';
import 'DonationRequestAdmin.dart';

class InventoryPage extends StatefulWidget {
  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  int showAll = 0;
  List<DocumentSnapshot> documents = [];
  String selectedCategory = "All";

  void fetchDocuments() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Inventory').get();
    List<Future<void>> deleteOperations = [];
    snapshot.docs.forEach((doc) {
      DateTime expireDate = doc['expiredate'].toDate();
      if (expireDate.isBefore(DateTime.now())) {
        deleteOperations.add(doc.reference.delete());
      }
    });
    await Future.wait(deleteOperations);
    snapshot = await FirebaseFirestore.instance.collection('Inventory').get();
    setState(() {
      documents = snapshot.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDocuments();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<DocumentSnapshot> filterItems(List<DocumentSnapshot> items) {
      if (selectedCategory == "All") {
        return items;
      }
      return items.where((doc) => doc['Category'] == selectedCategory).toList();
    }

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
                            "Inventory",
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
                            child: const Divider(
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
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 30),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                DateTime currentDate =
                                                    DateTime.now();
                                                DateTime fiveDaysFromNow =
                                                    currentDate.add(
                                                        const Duration(
                                                            days: 5));
                                                List<InventoryModel>
                                                    filteredItems = documents
                                                        .map((doc) =>
                                                            InventoryModel
                                                                .fromMap(doc
                                                                        .data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>))
                                                        .where((item) =>
                                                            item.expire.isBefore(
                                                                fiveDaysFromNow) ||
                                                            item.quantity < 5)
                                                        .toList();
                                                Get.dialog(
                                                  Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Container(
                                                      width: 750,
                                                      padding:
                                                          EdgeInsets.all(20.0),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'Expire And Low Quantity Warning',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            const Divider(),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: DataTable(
                                                                columns: const [
                                                                  DataColumn(
                                                                      label: Text(
                                                                          'Item Name')),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          'Quantity')),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          'Expire Date')),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          'Status')),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          'Action')),
                                                                ],
                                                                rows: filteredItems
                                                                    .map(
                                                                        (item) {
                                                                  return DataRow(
                                                                      cells: [
                                                                        DataCell(
                                                                            Text(item.name)),
                                                                        DataCell(Text(item
                                                                            .quantity
                                                                            .toString())),
                                                                        DataCell(
                                                                            Text(DateFormat.yMMMd().format(item.expire))),
                                                                        DataCell(Text(item.quantity <
                                                                                5
                                                                            ? 'Low Quantity'
                                                                            : 'Expiring Soon')),
                                                                        DataCell(
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(Icons.delete),
                                                                            onPressed:
                                                                                () async {
                                                                              await FirebaseFirestore.instance.collection('Inventory').doc(item.name).delete().then((value) {
                                                                                Get.back();
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ]);
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.yellow,
                                              ),
                                              child: const Row(
                                                children: [
                                                  Icon(
                                                    Icons.warning_amber,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    'Warnings',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'opensans',
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          const Text(
                                            "Filter :    ",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontFamily: 'opensans',
                                            ),
                                          ),
                                          DropdownButton<String>(
                                            alignment: Alignment.centerRight,
                                            underline: null,
                                            value: selectedCategory,
                                            items: ['All', ...category]
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedCategory = newValue!;
                                              });
                                            },
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.dialog(
                                                  barrierDismissible: false,
                                                  Dialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child:
                                                          DonationRequestAdminForm()));
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 35),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Text(
                                                "Add Items To Inventory",
                                                textAlign: TextAlign.center,
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
                                      const Text(
                                        "All Inventory Items        ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'opensans',
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: screenWidth - 25,
                                    height: 1,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 460,
                                        width: screenWidth - 100,
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('Inventory')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const SizedBox(
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

                                            final screenWidth =
                                                MediaQuery.of(context)
                                                    .size
                                                    .width;
                                            final crossAxisCount =
                                                (screenWidth / 200).floor();
                                            final double itemWidth =
                                                (screenWidth -
                                                        (crossAxisCount + 1) *
                                                            10) /
                                                    crossAxisCount;
                                            const double itemHeight = 340;
                                            final List<DocumentSnapshot>
                                                filteredDocuments = filterItems(
                                                    snapshot.data!.docs);
                                            if (filteredDocuments.isEmpty) {
                                              return const Center(
                                                child:
                                                    Text('No items available'),
                                              );
                                            }

                                            return GridView.builder(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: crossAxisCount,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                childAspectRatio:
                                                    itemWidth / itemHeight,
                                              ),
                                              itemCount:
                                                  filteredDocuments.length,
                                              itemBuilder: (context, index) {
                                                final doc =
                                                    filteredDocuments[index];
                                                final donation =
                                                    InventoryModel.fromMap(
                                                        doc.data() as Map<
                                                            String, dynamic>);
                                                final categoryIndex = category
                                                    .indexOf(donation.category);
                                                final subcategoryIndex =
                                                    subcategory[categoryIndex]
                                                        .indexOf(donation.name);
                                                final imageUrl =
                                                    suburl[categoryIndex]
                                                        [subcategoryIndex];
                                                return Card(
                                                  elevation: 10,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.network(
                                                        imageUrl,
                                                        width: itemWidth,
                                                        height:
                                                            itemHeight - 130,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 10),
                                                        child: Text(
                                                          donation.category,
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'opensans',
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              donation.name
                                                                          .length >
                                                                      10
                                                                  ? '${donation.name.substring(0, 10)}...'
                                                                  : donation
                                                                      .name,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontFamily:
                                                                      'opensans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              'Q: ${donation.quantity.toString()}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'opensans',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 5,
                                                                bottom: 10),
                                                        child: Text(
                                                          "Expire Date : ${DateFormat.yMMMd().format(doc['expiredate'].toDate())}",
                                                          textAlign:
                                                              TextAlign.end,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'opensans',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
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
