import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodbankmanagementsystem/Screens/Widgets/barchartmonthly.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../Model/User.dart';
import '../Widgets/Appbar.dart';
import '../Widgets/barchartweekly.dart';
import '../Widgets/chat_box.dart';
import '../Widgets/userList.dart';
import '../Widgets/barchartyearly.dart';
import '../Widgets/overview_widget.dart';
import '../Widgets/piechart.dart';


class DashBoard extends StatefulWidget {
  @override
  DashBoardState createState() => DashBoardState();
}

class DashBoardState extends State<DashBoard> {
  List<Users> csss = [];
  List<Users> allUsers = [];
  int showAll = 0;
  double chatwidth = 0;
  var formatter = NumberFormat('#,##,000');
  var formatters = NumberFormat('#,##,#00');
  List<Users> chatuser = [];
  int totaluser = 0;
  int adminCount = 0;
  int foodDonorCount = 0;
  int recipientCount = 0;
  double reciveCount = 0;
  int selectedValue = 0;
  double donationCount = 0;
  double inventoryCount = 0;
  double subtotal = 0;
  int volunteerCount = 0;
  DateTime now = DateTime.now();
  List<double> donationquantities = List.filled(
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day, 0.0);
  List<double> receivedquantities = List.filled(
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day, 0.0);
  DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 6));
  List<double> quantitiesweek = List.filled(7, 0.0);
  List<DateTime> last7Days = List.generate(
      7, (index) => DateTime.now().subtract(Duration(days: 6 - index)));
  List<double> receivedssweek = List.filled(7, 0.0);
  double cjan = 0,
      cfeb = 0,
      cmar = 0,
      capr = 0,
      cmay = 0,
      cjun = 0,
      cjul = 0,
      caug = 0,
      csept = 0,
      coct = 0,
      cnov = 0,
      cdec = 0,
      ejan = 0,
      efeb = 0,
      emar = 0,
      eapr = 0,
      emay = 0,
      ejun = 0,
      ejul = 0,
      eaug = 0,
      esept = 0,
      eoct = 0,
      enov = 0,
      edec = 0;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    csss = [];
    allUsers = [];
    adminCount = 0;
    foodDonorCount = 0;
    recipientCount = 0;
    volunteerCount = 0;
    reciveCount = 0;
    donationCount = 0;
    inventoryCount = 0;
    subtotal = 0;

    QuerySnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('Users').get();
    List<Users> users = userSnapshot.docs.map((doc) {
      return Users.fromJson(doc.data());
    }).toList();

    List<bool> hasUnseenMessages = List.filled(users.length, false);
    QuerySnapshot<Map<String, dynamic>> messageSnapshot =
        await FirebaseFirestore.instance.collection('ChatsAdmin').get();
    messageSnapshot.docs.forEach((doc) {
      String? userId = doc['userId'];
      bool? seen = doc['seen'];
      if (userId != null && seen != null) {
        int userIndex = users.indexWhere((user) => user.id == userId);
        if (userIndex != -1 && !seen) {
          hasUnseenMessages[userIndex] = true;
        }
      }
    });

    List<Users> sortedUsers = [];
    for (int i = 0; i < users.length; i++) {
      if (hasUnseenMessages[i]) {
        Users user = users[i].copyWith(seen: true);
        sortedUsers.insert(0, user);
      } else {
        sortedUsers.add(users[i]);
      }
    }
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('FoodDonation').get();
    snapshot.docs.forEach((doc) {
      int month = doc['requested date'].toDate().month;
      DateTime requestedDate = doc['requested date'].toDate();
      if (last7Days.any((date) =>
          date.year == requestedDate.year &&
          date.month == requestedDate.month &&
          date.day == requestedDate.day)) {
        int index = last7Days.indexWhere((date) =>
            date.year == requestedDate.year &&
            date.month == requestedDate.month &&
            date.day == requestedDate.day);
        quantitiesweek[index] ??= 0;
        List<dynamic> foods = doc['foods'];
        foods.forEach((food) {
          quantitiesweek[index] += food['quantity'];
        });
      }
      if (month == now.month) {
        List<dynamic> foods = doc['foods'];
        foods.forEach((food) {
          DateTime foodDate = doc['requested date'].toDate();
          int day = foodDate.day;
          int quantity = food['quantity'];
          donationquantities[day - 1] += quantity;
        });
      }
      List<dynamic> foods = doc['foods'];
      foods.forEach((food) {
        donationCount += food['quantity'];
        int quantity = food['quantity'];
        switch (month) {
          case 1:
            cjan += quantity;
            break;
          case 2:
            cfeb += quantity;
            break;
          case 3:
            cmar += quantity;
            break;
          case 4:
            capr += quantity;
            break;
          case 5:
            cmay += quantity;
            break;
          case 6:
            cjun += quantity;
            break;
          case 7:
            cjul += quantity;
            break;
          case 8:
            caug += quantity;
            break;
          case 9:
            csept += quantity;
            break;
          case 10:
            coct += quantity;
            break;
          case 11:
            cnov += quantity;
            break;
          case 12:
            cdec += quantity;
            break;
          default:
            break;
        }
      });
    });

    QuerySnapshot snapshots =
        await FirebaseFirestore.instance.collection('Inventory').get();
    snapshots.docs.forEach((doc) {
      inventoryCount += doc['Quantity'];
    });

    QuerySnapshot snapshotss =
        await FirebaseFirestore.instance.collection('InventoryReceive').get();
    snapshotss.docs.forEach((doc) {
      int month = doc['requested date'].toDate().month;
      DateTime requestedDate = doc['requested date'].toDate();

      if (last7Days.any((date) =>
          date.year == requestedDate.year &&
          date.month == requestedDate.month &&
          date.day == requestedDate.day)) {
        int index = last7Days.indexWhere((date) =>
            date.year == requestedDate.year &&
            date.month == requestedDate.month &&
            date.day == requestedDate.day);
        receivedssweek[index] ??= 0;
        List<dynamic> foods = doc['Items'];
        foods.forEach((food) {
          receivedssweek[index] += food['quantity'];
        });
      }
      if (month == now.month) {
        List<dynamic> foods = doc['Items'];
        foods.forEach((food) {
          DateTime foodDate = doc['requested date'].toDate();
          int day = foodDate.day;
          int quantity = food['quantity'];
          receivedquantities[day - 1] += quantity;
        });
      }
      List<dynamic> foods = doc['Items'];
      foods.forEach((food) {
        reciveCount += food['quantity'];
        int quantity = food['quantity'];
        switch (month) {
          case 1:
            ejan += quantity;
            break;
          case 2:
            efeb += quantity;
            break;
          case 3:
            emar += quantity;
            break;
          case 4:
            eapr += quantity;
            break;
          case 5:
            emay += quantity;
            break;
          case 6:
            ejun += quantity;
            break;
          case 7:
            ejul += quantity;
            break;
          case 8:
            eaug += quantity;
            break;
          case 9:
            esept += quantity;
            break;
          case 10:
            eoct += quantity;
            break;
          case 11:
            enov += quantity;
            break;
          case 12:
            edec += quantity;
            break;
          default:
            break;
        }
      });
    });
    setState(() {
      subtotal = inventoryCount + reciveCount + donationCount;
      allUsers = sortedUsers;
      csss = sortedUsers;
      totaluser = users.length;
      adminCount = users.where((user) => user.type == 'Admin').length;
      foodDonorCount = users.where((user) => user.type == 'Food Donor').length;
      recipientCount = users.where((user) => user.type == 'Recipient').length;
      volunteerCount = users.where((user) => user.type == 'Volunteer').length;
    });
  }

  void filterUsers(String userType) {
    setState(() {
      if (userType == 'Admin') {
        csss = allUsers.where((user) => user.type == 'Admin').toList();
      } else if (userType == 'Food Donor') {
        csss = allUsers.where((user) => user.type == 'Food Donor').toList();
      } else if (userType == 'Recipient') {
        csss = allUsers.where((user) => user.type == 'Recipient').toList();
      } else if (userType == 'Volunteer') {
        csss = allUsers.where((user) => user.type == 'Volunteer').toList();
      } else if (userType == 'Status') {
        csss = allUsers.where((user) => !user.sts).toList();
      } else if (userType == 'Chat') {
        csss = allUsers.where((user) => user.seen ?? false).toList();
      } else {
        csss = allUsers;
      }
    });
  }

  bool addtochatuser(Users usr) {
      chatuser.add(usr);
      return true;
  }

  void removefromchatuser(Users usr) {
    getData();
    setState(() {
      chatuser.remove(usr);
    });
  }

  Future<void> markMessagesAsSeen(String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('ChatsAdmin')
        .where('userId', isEqualTo: userId)
        .where('seen', isEqualTo: false)
        .get();
    WriteBatch batch = FirebaseFirestore.instance.batch();
    snapshot.docs.forEach((doc) {
      batch.update(doc.reference, {'seen': true});
    });
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 75,bottom: 10),
                          child: const Text(
                            "Dashboard",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              fontFamily: 'inter',
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 350,),
                              OverViewWidget(
                                color: Colors.green,
                                text: "TOTAL USER",
                                icon: Icons.person,
                                number: formatters
                                    .format(allUsers.length)
                                    .toString(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OverViewWidget(
                                color: Colors.deepPurple,
                                text: "TOTAL DONOR",
                                icon: Icons.local_dining,
                                number: formatters
                                    .format(foodDonorCount)
                                    .toString(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OverViewWidget(
                                color: Colors.brown,
                                text: "TOTAL RECIPIENT",
                                icon: Icons.check_circle,
                                number: formatters
                                    .format(recipientCount)
                                    .toString(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OverViewWidget(
                                color: Colors.teal,
                                text: "TOTAL VOLUNTEER",
                                icon: Icons.volunteer_activism,
                                number: formatters
                                    .format(volunteerCount)
                                    .toString(),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 150, right: 40),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 3,
                                            blurRadius: 4,
                                            offset: const Offset(2, 5)),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: screenWidth / 1.7 + 30,
                                          margin: const EdgeInsets.only(
                                              right: 20, left: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 20, left: 25),
                                                child: Text(
                                                  selectedValue == 0? "Yearly Progress Report":selectedValue==1?   "Monthly Progress Report": "Weekly Progress Report",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontSize: 22,
                                                      fontFamily: 'inter',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: 120,
                                                      height: 25,
                                                      child: RadioListTile<int>(
                                                        title: const Text(
                                                          'Weekly',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        value: 2,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        groupValue: selectedValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedValue =
                                                                value!;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 120,
                                                      height: 25,
                                                      child: RadioListTile<int>(
                                                        title: const Text(
                                                          'Monthly',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        value: 1,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        groupValue: selectedValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedValue =
                                                                value!;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 120,
                                                      height: 25,
                                                      child: RadioListTile<int>(
                                                        title: const Text(
                                                          'Yearly',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        value: 0,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        groupValue: selectedValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedValue =
                                                                value!;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          width: screenWidth / 1.7 + 50,
                                          height: 0.5,
                                          color: Colors.grey.shade700,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            width: screenWidth / 1.8,
                                            height: screenHeight / 2.3,
                                            child: selectedValue == 0
                                                ? BarrChartYearly(
                                                    cjan: cjan,
                                                    cfeb: cfeb,
                                                    cmar: cmar,
                                                    capr: capr,
                                                    cmay: cmay,
                                                    cjun: cjun,
                                                    cjul: cjul,
                                                    caug: caug,
                                                    csept: csept,
                                                    coct: coct,
                                                    cnov: cnov,
                                                    cdec: cdec,
                                                    ejan: ejan,
                                                    efeb: efeb,
                                                    emar: emar,
                                                    eapr: eapr,
                                                    emay: emay,
                                                    ejun: ejun,
                                                    ejul: ejul,
                                                    eaug: eaug,
                                                    esept: esept,
                                                    eoct: eoct,
                                                    enov: enov,
                                                    edec: edec)
                                                : selectedValue == 2
                                                    ? BarrChartWeekly(
                                                        idates: quantitiesweek,
                                                        edates: receivedssweek,
                                                        datetimes: last7Days,
                                                      )
                                                    : BarrChartMonthly(
                                                        idates:
                                                            donationquantities,
                                                        edates:
                                                            receivedquantities,
                                                      )),
                                      ],
                                    )),
                                SizedBox(width: 20,),
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 3,
                                            blurRadius: 4,
                                            offset: const Offset(2, 5)),
                                      ],
                                    ),
                                    margin: EdgeInsets.only(right: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 25, left: 25),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Donation Summary till",
                                                style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                    fontSize: 12,
                                                    fontFamily: 'inter',
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                " (${DateFormat.yMMMd().format(now)})",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontFamily: 'inter',
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 25),
                                          child: Text(
                                              formatters
                                                  .format(subtotal)
                                                  .toString(),
                                              style: TextStyle(
                                                fontFamily: 'opensans',
                                                color: Color(0xFF1A1E30),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28,
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: screenWidth / 6 + 50,
                                          height: 0.5,
                                          color: Colors.grey.shade700,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            width: screenWidth / 6 +20,
                                            height: screenHeight / 2.3,
                                            child: PieCharts(
                                              inventory: inventoryCount,
                                              totaldonation: donationCount,
                                              totalreceived: reciveCount,
                                            )),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            right: 35,
                            top: 20,
                          ),
                          child: SingleChildScrollView(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(child: SizedBox()),
                                GestureDetector(
                                  onTap: () {
                                    showAll = 0;
                                    filterUsers("ALL");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: showAll == 0
                                          ? Colors.blue
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.horizontal(
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
                                    filterUsers("Chat");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: showAll == 1
                                          ? Colors.blue
                                          : Colors.transparent,
                                      border: const Border.symmetric(
                                        horizontal: BorderSide(
                                          color: Colors.blue,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Unseen Chat',
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
                                GestureDetector(
                                  onTap: () {
                                    showAll = 2;
                                    filterUsers("Admin");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: showAll == 2
                                          ? Colors.blue
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'Admin',
                                      style: TextStyle(
                                        fontFamily: 'inter',
                                        color: showAll == 2
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showAll = 3;
                                    filterUsers("Recipient");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: showAll == 3
                                          ? Colors.blue
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'Recipient',
                                      style: TextStyle(
                                        fontFamily: 'inter',
                                        color: showAll == 3
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showAll = 4;
                                    filterUsers("Food Donor");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: showAll == 4
                                          ? Colors.blue
                                          : Colors.transparent,
                                      border: const Border.symmetric(
                                        horizontal: BorderSide(
                                          color: Colors.blue,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Food Donor',
                                      style: TextStyle(
                                        fontFamily: 'inter',
                                        color: showAll == 4
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showAll = 5;
                                    filterUsers("Volunteer");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: showAll == 5
                                          ? Colors.blue
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.horizontal(
                                        right: Radius.circular(20),
                                      ),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'Volunteer',
                                      style: TextStyle(
                                        fontFamily: 'inter',
                                        color: showAll == 5
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
                        ),
                        UserList(
                            csss: csss,
                            getData: getData,
                            addtochatuser: addtochatuser,
                            showAll: showAll),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              width: MediaQuery.of(context).size.width > screenWidth
                  ? screenWidth
                  : MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: chatuser.isEmpty ? 0 : 430,
                    margin: const EdgeInsets.only(right: 12),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ListView.builder(
                        itemCount: chatuser.length,
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          markMessagesAsSeen(chatuser[index].id);
                          return ChatBox(
                            removefrom: removefromchatuser,
                            usr: chatuser[index],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
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
