import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';

import '../../helper/auth_service.dart';
import '../../route.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var conname = TextEditingController();
  var conphone = TextEditingController();
  var conaddress = TextEditingController();
  var contype;
  var conemail = TextEditingController();
  var conpass = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isloading = false;
  @override
  void initState() {
    super.initState();
    _setup();
  }


  void _setup() {
    final authService = AuthService.to;
    if (authService.user != null) {
      conname.text = authService.user!.name ?? '';
      conphone.text = authService.user!.phone ?? '';
      conaddress.text = authService.user!.address ?? '';
      contype = authService.user!.type ?? '';
      conemail.text = authService.user!.email ?? '';
      conpass.text = authService.user!.pass ?? '';
    } else {
      print("User data not available");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/register_bg.png"),
                    fit: BoxFit.fill)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 780,
                  height: 600,
                  margin: EdgeInsets.only(bottom: 60),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          "assets/logo.png",
                          height: 110,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        textAlign: TextAlign.center,
                        "Profile Page",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 22,
                            fontFamily: 'inter',
                            fontWeight: FontWeight.w600),
                      ),
                      const Text(
                        textAlign: TextAlign.center,
                        "Update Your Details from here.",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'inter'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 5,
                                height: 50,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                width: 295,
                                height: 50,
                                child: TextField(
                                  controller: conname,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: InputBorder.none,
                                    labelText: "Name",
                                    fillColor: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          Row(
                            children: [
                              Container(
                                width: 5,
                                height: 50,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                width: 295,
                                height: 50,
                                child: TextField(
                                  controller: conemail,
                                  readOnly: true,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: InputBorder.none,
                                    labelText: "Email",
                                    fillColor: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 5,
                                height: 50,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                width: 295,
                                height: 50,
                                child: TextField(
                                  controller: conphone,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: InputBorder.none,
                                    labelText: "Phone",
                                    fillColor: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          Row(
                            children: [
                              Container(
                                width: 5,
                                height: 50,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                width: 295,
                                height: 50,
                                child: TextField(
                                  controller: conaddress,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: InputBorder.none,
                                    labelText: "Address",
                                    fillColor: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 5,
                                height: 50,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                width: 295,
                                height: 50,
                                child: TextFormField(
                                  initialValue: contype,
                                  readOnly: true,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: InputBorder.none,
                                    labelText: "User Type",
                                    fillColor: Colors.grey.shade200,
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          Row(
                            children: [
                              Container(
                                width: 5,
                                height: 50,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                width: 295,
                                height: 50,
                                child: TextField(
                                  obscureText: !_isPasswordVisible,
                                  controller: conpass,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: InputBorder.none,
                                    labelText: "Password",
                                    fillColor: Colors.grey.shade200,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            _isloading = true;
                          });
                          String cpass = conpass.text;
                          String cname = conname.text;
                          String cphone = conphone.text;
                          String caddress = conaddress.text;
                          if (cpass.isEmpty ||
                              cphone.isEmpty ||
                              cname.isEmpty ||
                              caddress.isEmpty) {
                            setState(() {
                              _isloading = false;
                            });
                            Get.snackbar(
                              "Update Failed.",
                              "All Fields Are Required!",
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
                          } else if (cpass.length < 6) {
                            setState(() {
                              _isloading = false;
                            });
                            Get.snackbar(
                              "Update Failed.",
                              "Password must be at least 6 characters long.",
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
                          } else {
                            try {
                              if (cpass != AuthService.to.user!.pass) {
                                await FirebaseAuth.instance.currentUser!
                                    .updatePassword(cpass);
                              }
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(AuthService.to.user!.id)
                                  .update({
                                'Name': cname,
                                'Phone': cphone,
                                'Address': caddress,
                                'Password': cpass,
                              });
                              setState(() {
                                _isloading = false;
                              });
                              Get.snackbar(
                                "Update Successful.",
                                "User Profile Updated Successfully!",
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
                              AuthService.to.Logout();
                              Get.offNamed(authenticationPageRoute);
                            } catch (e) {
                              setState(() {
                                _isloading = false;
                              });
                              Get.snackbar(
                                "Registration Failed.",
                                "An error occurred. Please try again later.",
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
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          width: 320,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: const Text(
                            "UPDATE",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'opensans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _isloading
              ? Center(
                  child: SpinKitFadingCircle(
                    color: Colors.blueAccent,
                    size: 100.0,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
