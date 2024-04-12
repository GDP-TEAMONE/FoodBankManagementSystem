import 'dart:ui';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../Model/User.dart';
import '../../helper/auth_service.dart';
import '../../route.dart';
import '../Widgets/Appbar.dart';
import '../Widgets/chat_box.dart';

class DashBoard extends StatefulWidget {
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Users> csss = [];
  List<Users> allUsers = [];
  int showAll = 0;
  double chatwidth = 0;
  List<Users> chatuser = [];
  int totaluser = 0;
  int adminCount = 0;
  int foodDonorCount = 0;
  int recipientCount = 0;
  int volunteerCount = 0;
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

    setState(() {
      allUsers = sortedUsers;
      csss = sortedUsers;
      totaluser = users.length;
      adminCount = users.where((user) => user.type == 'Admin').length;
      foodDonorCount = users.where((user) => user.type == 'Food Donor').length;
      recipientCount = users.where((user) => user.type == 'Recipient').length;
      volunteerCount = users.where((user) => user.type == 'Volunteer').length;
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
                Appbarr(),
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
                            "Dashboard",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              fontFamily: 'inter',
                            ),
                          ),
                        ),

Container(
                          margin: EdgeInsets.symmetric(horizontal: 45),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  filterUsers("All");
                                },
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: ((Colors.grey[300])!),
                                          blurRadius: 4,
                                          offset:
                                              Offset(4, 8), // Shadow position
                                        ),
                                      ],

                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  //margin: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 0, top: 10, right: 10, bottom: 10),
                                  padding: EdgeInsets.all(30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Users",
                                        style: TextStyle(
                                            fontFamily: 'inter',
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "$totaluser",
                                        style: const TextStyle(
                                            fontFamily: 'inter',
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Image.asset(
                                        "assets/icons/icon_up.png",
                                        width: 20,
                                      ),
                                      Text(
                                        "5.27%",
                                        style: TextStyle(
                                            fontFamily: 'inter',
                                            fontSize: 14,
                                            color: Colors.green),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Since Last Month",
                                        style: TextStyle(
                                            fontFamily: 'inter',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                                     const SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  filterUsers("Admin");
                                },
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: ((Colors.grey[300])!),
                                          blurRadius: 4,
                                          offset:
                                              Offset(4, 8), // Shadow position
                                        ),
                                      ],
                                    olor: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  //margin: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 0, top: 10, right: 10, bottom: 10),
                                  padding: EdgeInsets.all(30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Admin",
                                        style: TextStyle(
                                            fontFamily: 'inter',
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "${adminCount}",
                                        style: const TextStyle(
                                            fontFamily: 'inter',
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Image.asset(
                                        "assets/icons/icon_up.png",
                                        width: 20,
                                      ),
                                      Text(
                                        "5.27%",
                                        style: TextStyle(
                                            fontFamily: 'inter',
                                            fontSize: 14,
                                            color: Colors.green),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Since Last Month",
                                        style: TextStyle(
                                            fontFamily: 'inter',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),









































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
        csss = allUsers.where((user) => user.seen??false).toList();
      } else {
        csss = allUsers;
      }
    });
  }


void _addtochatuser(Users usr) {
    setState(() {
      chatuser.add(usr);
    });
  }

  void _removefromchatuser(Users usr) {
    getData();
    setState(() {
      chatuser.remove(usr);
    });
  }




























































































