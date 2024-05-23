import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import '../../Model/InventoryModel.dart';
import '../../helper/values.dart';
import '../Widgets/Appbar.dart';
import 'InventoryRequest.dart';

class RecipientBuyPage extends StatefulWidget {
  @override
  State<RecipientBuyPage> createState() => _RecipientBuyPageState();
}

class _RecipientBuyPageState extends State<RecipientBuyPage> {
  List<InventoryModel> cartItems = [];
  int showAll = 0;
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    resetcart() {
      setState(() {
        cartItems = [];
      });
    }

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
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (cartItems.isEmpty) {
                                                    Get.snackbar(
                                                      "Requesting Failed.",
                                                      "Add items to cart to proceed to request.",
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      colorText: Colors.white,
                                                      backgroundColor:
                                                          Colors.red,
                                                      margin: EdgeInsets.zero,
                                                      duration: const Duration(
                                                          milliseconds: 2000),
                                                      boxShadows: [
                                                        const BoxShadow(
                                                          color: Colors.grey,
                                                          offset:
                                                              Offset(-100, 0),
                                                          blurRadius: 20,
                                                        ),
                                                      ],
                                                      borderRadius: 0,
                                                    );
                                                  } else {
                                                    Get.dialog(
                                                        barrierDismissible:
                                                            false,
                                                        Dialog(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child:
                                                                InventoryRequestForm(
                                                              cartItems:
                                                                  cartItems,
                                                              resetcart:
                                                                  resetcart,
                                                            ))).then((value) {
                                                      setState(() {});
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .shopping_cart_outlined,
                                                        color: Colors.white,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      const Text(
                                                        "Proceed To Cart  ",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'opensans',
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        cartItems.length
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'opensans',
                                                          fontSize: 16,
                                                        ),
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
                                                alignment:
                                                    Alignment.centerRight,
                                                underline: null,
                                                value: selectedCategory,
                                                items: [
                                                  'All',
                                                  ...category
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectedCategory =
                                                        newValue!;
                                                  });
                                                },
                                              ),
                                            ],
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
                                      SizedBox(
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
                                            const double itemHeight = 350;
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
                                                final nutrition =
                                                    nutritions[categoryIndex]
                                                        [subcategoryIndex];

                                                final isItemInCart =
                                                    cartItems.any((item) =>
                                                        item.name ==
                                                        donation.name);
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
                                                            itemHeight - 140,
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
                                                          style:
                                                              const TextStyle(
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
                                                                bottom: 5,
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
                                                                bottom: 10,
                                                                top: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 10,
                                                                right: 10,
                                                              ),
                                                              child: Text(
                                                                nutrition,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'opensans',
                                                                ),
                                                              ),
                                                            ),
                                                            isItemInCart
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        cartItems.removeWhere((item) =>
                                                                            item.name ==
                                                                            donation.name);
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .red,
                                                                          borderRadius:
                                                                              BorderRadius.circular(25)),
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .remove_shopping_cart_outlined,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        final newItem = InventoryModel(
                                                                            name: donation
                                                                                .name,
                                                                            category: donation
                                                                                .category,
                                                                            quantity:
                                                                                1,
                                                                            maxquantity:
                                                                                donation.maxquantity,
                                                                            expire: DateTime.now());
                                                                        cartItems
                                                                            .add(newItem);
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .green,
                                                                          borderRadius:
                                                                              BorderRadius.circular(25)),
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .add_shopping_cart,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                      )
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
