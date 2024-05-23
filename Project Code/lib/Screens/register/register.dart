import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../Model/User.dart';
import '../../helper/auth_service.dart';
import '../../route.dart';
import '../Widgets/Snakbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var conname = TextEditingController();
  var conphone = TextEditingController();
  String phonenum = '';
  var contype;
  var conaddress = TextEditingController();
  var conemail = TextEditingController();
  var conpass = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isloading = false;

  bool get isLoading => _isloading;
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
                        "Register to Account",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 22,
                            fontFamily: 'inter',
                            fontWeight: FontWeight.w600),
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
                              Container(
                                color: Colors.grey.shade200,
                                width: 295,
                                height: 50,
                                child: InternationalPhoneNumberInput(
                                  selectorConfig: const SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.DROPDOWN,
                                      useBottomSheetSafeArea: true,
                                      trailingSpace: true),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle:
                                      TextStyle(color: Colors.black),
                                  textFieldController: conphone,
                                  formatInput: true,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: false),
                                  inputBorder: null,
                                  onInputChanged: (PhoneNumber value) {
                                    phonenum = value.dialCode! +
                                        " " +
                                        value.phoneNumber.toString();
                                  },
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
                              Container(
                                width: 295,
                                height: 50,
                                child: DropdownButtonFormField<String>(
                                  value: contype,
                                  onChanged: (value) {
                                    setState(() {
                                      contype = value!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: InputBorder.none,
                                    labelText: "User Type",
                                    contentPadding: EdgeInsets.only(
                                        bottom: 20,
                                        left: 10,
                                        right: 10,
                                        top: 5),
                                    fillColor: Colors.grey.shade200,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Admin',
                                      child: Text('Admin'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Food Donor',
                                      child: Text('Food Donor'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Recipient',
                                      child: Text('Recipient'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Volunteer',
                                      child: Text('Volunteer'),
                                    ),
                                  ],
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
                          String cemail = conemail.text ?? '';
                          String cpass = conpass.text ?? '';
                          String cname = conname.text ?? '';
                          String caddress = conaddress.text ?? '';
                          String cphone = phonenum;
                          RegExp emailRegExp = RegExp(
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
                          if (cemail.isEmpty ||
                              cpass.isEmpty ||
                              cphone.isEmpty ||
                              cname.isEmpty ||
                              caddress.isEmpty ||
                              contype == null) {
                            setState(() {
                              _isloading = false;
                            });
                            showSnackBar('Registration Failed.',
                                'All Fields Are Required!', Colors.red);
                          } else if (!emailRegExp.hasMatch(cemail)) {
                            showSnackBar(
                                'Registration Failed.',
                                'Please enter a valid email address.',
                                Colors.red);
                          } else if (cpass.length < 6) {
                            showSnackBar(
                                'Registration Failed.',
                                'Password must be at least 6 characters long.',
                                Colors.red);
                          } else if (cphone.length < 12) {
                            showSnackBar(
                                'Registration Failed.',
                                'Phone number must be at least 12 characters long.',
                                Colors.red);
                          } else {
                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                email: cemail,
                                password: cpass,
                              );
                              await userCredential.user!
                                  .sendEmailVerification();

                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'Name': cname,
                                'Phone': cphone,
                                'Address': caddress,
                                'ID': userCredential.user!.uid,
                                'Type': contype,
                                'Email': cemail,
                                'Password': cpass,
                                'Last Login': DateTime.now(),
                                'Last Logout': DateTime.now(),
                                'Status': true,
                              });
                              setState(() {
                                _isloading = false;
                              });
                              showSnackBar(
                                  'Registration Successful.',
                                  'User registered successfully!',
                                  Colors.green);
                              Get.offNamed(authenticationPageRoute);
                            } catch (e) {
                              setState(() {
                                _isloading = false;
                              });
                              showSnackBar(
                                  'Registration Failed.',
                                  'An error occurred. Please try again later.',
                                  Colors.red);
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
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'opensans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 425,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              textAlign: TextAlign.center,
                              "Already Have An Account? ",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w100),
                            ),
                            const Expanded(
                              child: SizedBox(
                                width: 3,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.offNamed(authenticationPageRoute);
                              },
                              child: const Text(
                                textAlign: TextAlign.center,
                                "Sign In?",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 14,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
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
