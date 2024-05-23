import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../Model/FoodDonation.dart';
import '../../Model/User.dart';
import '../../helper/auth_service.dart';
import '../../helper/generateReceipt.dart';
import '../../route.dart';
import '../Widgets/Appbar.dart';
import '../Widgets/ChatInputField.dart';
import '../Widgets/chat_box.dart';
import 'DonationRequest.dart';

class FoodDonorHome extends StatefulWidget {
  @override
  State<FoodDonorHome> createState() => _FoodDonorHomeState();
}

class _FoodDonorHomeState extends State<FoodDonorHome> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
                                    SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "All Donation Request List   ",
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
                                    Container(
                                      width: screenWidth - 550,
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('FoodDonation')
                                            .where("requested by",
                                            isEqualTo:
                                            AuthService.to.user?.id)
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

                                          final List<DataRow> rows =
                                          snapshot.data!.docs.map((doc) {
                                            final donation =
                                            FoodDonation.fromMap(doc.data()
                                            as Map<String, dynamic>);
                                            var foods =
                                            doc['foods'] as List<dynamic>;
                                            String ss = '';
                                            for (var food in foods) {
                                              var name =
                                              food['name'] as String?;
                                              if (name != null) {
                                                ss = ss + name + ", ";
                                              }
                                            }
                                            return DataRow(
                                              cells: [
                                                DataCell(Container(width:548,child: Text(ss))),
                                                DataCell(Text(
                                                    donation.deliveryOption)),
                                                DataCell(donation.status ==
                                                    "Added To Inventory"
                                                    ? Row(
                                                  children: [
                                                    Text(donation.status),
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons.print),
                                                      onPressed: () async {
                                                        await generateReceipt(
                                                          itemName: ss,
                                                          deliveryOption: donation.deliveryOption,
                                                          address: donation.address,
                                                          contactInfo: donation.contactInfo,
                                                          requestedDate: donation.requesteddate,
                                                          additionalNotes: donation.additionalNotes,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                )
                                                    : Text(donation.status)),
                                              ],
                                            );
                                          }).toList();

                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                              headingRowColor:
                                              MaterialStateColor
                                                  .resolveWith(
                                                    (states) => Colors.blueAccent!,
                                              ),
                                              headingTextStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'opensans',
                                                  fontWeight: FontWeight.bold),
                                              border: TableBorder.all(
                                                  width: 1,
                                                  color: Colors.black12),
                                              columns: const [

                                                DataColumn(
                                                  label: Expanded(
                                                    child: Text('Items Name', overflow: TextOverflow.ellipsis),
                                                  ),
                                                ),
                                                DataColumn(
                                                    label: Text(
                                                        'Delivery Option')),
                                                DataColumn(
                                                    label: Text('Status')),
                                              ],
                                              rows: rows,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height - 185,
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.dialog(
                                            barrierDismissible: false,
                                            Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: DonationRequestForm()));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 35),
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          "Send Donation Request",
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
                                )),
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
