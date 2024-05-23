import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../helper/auth_service.dart';
import '../../route.dart';
import 'package:url_launcher/url_launcher.dart';

class Appbarr extends StatefulWidget {
  bool ishome;
  Appbarr({required this.ishome});
  @override
  State<Appbarr> createState() => _AppbarrState();
}

class _AppbarrState extends State<Appbarr> {
  String currentLoginTime = '';

  @override
  void initState() {
    super.initState();
    getCurrentLoginTime();
  }

  Future<void> getCurrentLoginTime() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(AuthService.to.user?.id)
        .get();

    Timestamp lastLoginTimestamp = userSnapshot['Last Login'];

    Duration duration = DateTime.now().difference(lastLoginTimestamp.toDate());
    setState(() {
      currentLoginTime = formatDuration(duration);
    });
  }

  String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays == 1 ? '' : 's'} ${duration.inHours.remainder(24)} hour${duration.inHours.remainder(24) == 1 ? '' : 's'} ${duration.inMinutes.remainder(60)} min';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours == 1 ? '' : 's'} ${duration.inMinutes.remainder(60)} min';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} min';
    } else {
      return 'Less than a minute';
    }
  }

  final String formLink =
      'https://docs.google.com/forms/d/e/1FAIpQLScR_ot1Qy_mxaR-MsrSvltQwDlFQ66Jlk0G9KzhCdSr_QIuAw/viewform?usp=sf_link';

  void _openFormLink() async {
    if (await canLaunch(formLink)) {
      await launch(formLink);
    } else {
      throw 'Could not launch $formLink';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(left: 200),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: 500,),
            _buildMenuItem('Feedback', () {
              _openFormLink();
            }),
            widget.ishome
                ? SizedBox()
                : _buildMenuItem('Home', () {
                    Get.back();
                  }),
            AuthService.to.user?.type == "Admin"
                ? _buildMenuItem('Inventory', () {
                    Get.toNamed(inventoryPageRoute);
                  })
                : SizedBox(),
            AuthService.to.user?.type == "Admin"
                ? _buildMenuItem('Assign', () {
                    Get.toNamed(adminassignPageRoute);
                  })
                : SizedBox(),
            AuthService.to.user?.type == "Admin"
                ? _buildMenuItem('Volunteer Assign', () {
                    Get.toNamed(volunteerassignPageRoute);
                  })
                : SizedBox(),
            _buildMenuItem('About Us', () {
              Get.toNamed(aboutusPageRoute);
            }),
            AuthService.to.user?.type == "Admin"
                ? _buildMenuItem('Donations', () {
                    Get.toNamed(donationsPageRoute);
                  })
                : const SizedBox(),
            _buildMenuItem('Profile', () {
              Get.dialog(
                Dialog(
                  insetPadding: EdgeInsets.only(right: 10, top: 25),
                  backgroundColor: Colors.white,
                  elevation: 20,
                  alignment: Alignment.topRight,
                  child: Stack(
                    children: [
                      Container(
                        width: 300,
                        height: 220,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                opacity: 0.9,
                                image: AssetImage("assets/profile_bg.jpg"),
                                fit: BoxFit.fill)),
                      ),
                      Container(
                        width: 300,
                        height: 350,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "User Type :  ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'inter',
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  AuthService.to.user!.type,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    Icons.person_2_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Name        :  ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'inter',
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  AuthService.to.user!.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Email         :  ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'inter',
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  AuthService.to.user!.email,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Address     :  ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'inter',
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  AuthService.to.user!.address,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: const SizedBox(
                                height: 5,
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Active Time :  ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'inter',
                                    fontSize: 12,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    currentLoginTime,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'inter',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Expanded(
                              child: SizedBox(
                                height: 0,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.back();
                                Get.toNamed(profilePageRoute);
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 5),
                                margin: const EdgeInsets.only(bottom: 10),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person, color: Colors.black87),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "My Profile",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Divider(),
                            SizedBox(
                              height: 2,
                            ),
                            InkWell(
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(AuthService.to.user!.id)
                                    .update({
                                  'Last Logout': DateTime.now(),
                                });
                                AuthService.to.Logout();
                                Get.offAllNamed(authenticationPageRoute);
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 5),
                                margin: const EdgeInsets.only(bottom: 10),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout, color: Colors.black87),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "Logout",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(
              width: 70,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, Function() onclick) {
    return InkWell(
      onTap: onclick,
      child: Container(
        height: 60,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'inter',
          ),
        ),
      ),
    );
  }
}
