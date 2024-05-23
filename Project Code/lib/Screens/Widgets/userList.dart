import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbankmanagementsystem/Screens/Widgets/styledText.dart';
import 'package:get/get.dart';

import '../../Model/User.dart';
import '../../helper/auth_service.dart';

class UserList extends StatefulWidget {
  List<Users> csss;
  Function() getData;
  Function(Users) addtochatuser;
  int showAll;
  UserList(
      {required this.csss,
      required this.getData,
      required this.addtochatuser,
      required this.showAll,
      super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1150,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: ((Colors.grey[300])!),
          blurRadius: 4,
          offset: const Offset(4, 8), // Shadow position
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.only(left: 310, right: 15, top: 10, bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 30, right: 10),
                    child: const Text(
                      "SL",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'inter'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: const Text(
                      "Name",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'inter'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: const Text(
                      "Email",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'inter'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: const Text(
                      "Phone",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'inter'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: const Text(
                      "Address",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'inter'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: const Text(
                      "Type",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'inter'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: const Text(
                      "Chat",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'inter'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: const Text(
                      "Action",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'inter'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.black12,
          ),
          widget.csss.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10),
                  child: const Text(
                    'No Users Found.',
                    style: TextStyle(fontFamily: 'inter', fontSize: 18),
                  ),
                )
              : MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.csss.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            Container(
                              height: 20,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 30, right: 10),
                                      child: StyledText(
                                          text: (index + 1).toString()),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: StyledText(
                                        text: widget.csss[index].name,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: StyledText(
                                        text: widget.csss[index].email,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: StyledText(
                                        text: widget.csss[index].phone,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: StyledText(
                                        text: widget.csss[index].address,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: StyledText(
                                        text: widget.csss[index].type,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: !(widget.csss[index].id ==
                                              AuthService.to.user?.id)
                                          ? widget.csss[index].sts
                                              ? InkWell(
                                                  onTap: () {
                                                    widget.addtochatuser(
                                                        widget.csss[index]);
                                                  },
                                                  child: FittedBox(
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 22,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .blueAccent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100)),
                                                          child: const Icon(
                                                            Icons.chat_outlined,
                                                            size: 13,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        if (widget.csss[index]
                                                                .seen ??
                                                            false ||
                                                                widget.showAll ==
                                                                    1)
                                                          Positioned(
                                                            top: 0,
                                                            right: 0,
                                                            child: Container(
                                                              width: 8,
                                                              height: 8,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : FittedBox(
                                                  child: Container(
                                                      width: 22,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.blueAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: const Icon(
                                                        Icons.chat_outlined,
                                                        size: 13,
                                                        color: Colors.white,
                                                      )),
                                                )
                                          : SizedBox(),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: widget.csss[index].sts
                                            ? InkWell(
                                                onTap: () async {
                                                  Get.dialog(
                                                    Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      child: Container(
                                                        width: 400,
                                                        padding: EdgeInsets.all(
                                                            20.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Text(
                                                              'Delete User',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              "Are you sure to delete '${widget.csss[index].name}' from the list",
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                            SizedBox(
                                                                height: 20),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .grey,
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            'inter',
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 20),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Users')
                                                                        .doc(widget
                                                                            .csss[index]
                                                                            .id)
                                                                        .update({
                                                                      "Status":
                                                                          false,
                                                                    });
                                                                    Get.back();
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blue,
                                                                  ),
                                                                  child: Text(
                                                                    'Disable',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            'inter',
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 20),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Users')
                                                                        .doc(widget
                                                                            .csss[
                                                                                index]
                                                                            .id)
                                                                        .delete()
                                                                        .then(
                                                                            (value) {
                                                                      widget
                                                                          .getData();
                                                                    });
                                                                    Get.back();
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                  child: Text(
                                                                    'Delete',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            'inter',
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: FittedBox(
                                                  child: Container(
                                                      width: 22,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.blueAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: const Icon(
                                                        Icons
                                                            .more_vert_outlined,
                                                        size: 13,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      FirebaseFirestore.instance
                                                          .collection('Users')
                                                          .doc(widget
                                                              .csss[index].id)
                                                          .update({
                                                        "Status": true,
                                                      }).then((value) {
                                                        widget.getData();
                                                      });
                                                    },
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .blueAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                        child: const Icon(
                                                          Icons.check,
                                                          size: 13,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      FirebaseFirestore.instance
                                                          .collection('Users')
                                                          .doc(widget
                                                              .csss[index].id)
                                                          .delete()
                                                          .then((value) {
                                                        widget.getData();
                                                      });
                                                    },
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.all(4.0),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .blueAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                        child: const Icon(
                                                          Icons.close,
                                                          size: 13,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                ],
                                              )),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
