import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';

import '../../Model/User.dart';
import '../../helper/auth_service.dart';
import '../../route.dart';
import '../Widgets/Snakbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var conemail = TextEditingController();
  var conpass = TextEditingController();
  bool sts = false;
  bool _isPasswordVisible = false;
  bool _isloading = false;

  void handleLogin(Users usr) {
    AuthService.to.updateAuthenticationStatus(usr, sts);
    if (usr.type == 'Admin') {
      Get.offAllNamed(homePageRoute);
    } else if (usr.type == 'Food Donor') {
      Get.offAllNamed(fooddonorhomePageRoute);
    } else if (usr.type == 'Volunteer') {
      Get.offAllNamed(volunteerhomePageRoute);
    } else if (usr.type == 'Recipient') {
      Get.offAllNamed(recipienthomePageRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    void showForgotPasswordDialog(BuildContext context) {
      final TextEditingController emailController = TextEditingController();

      Get.dialog(
        AlertDialog(
          title: const Text('Forgot Password'),
          contentPadding: EdgeInsets.zero,
          content: Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(
                  height: 30,
                ),
                const Text(
                  'Send password reset Email.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 50,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(
                      width: 485,
                      height: 50,
                      child: TextField(
                        controller: emailController,
                        key: Key('emailTextField'),
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
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Background color
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String email = emailController.text.trim();

                          if (email.isEmpty) {
                            Get.snackbar('Error', 'Please enter your email');
                            return;
                          }

                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email);
                            Get.snackbar('Success',
                                'Password reset email sent to $email. check your email or spam folder.');
                            Get.back();
                          } catch (e) {
                            Get.snackbar('Error',
                                'Failed to send password reset email: $e');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Background color
                        ),
                        child: const Text(
                          'Send Email',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      );
    }

    void _loginUser() async {
      setState(() {
        _isloading = true;
      });

      String cemail = conemail.text;
      String cpass = conpass.text;
      RegExp emailRegExp = RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

      if (cemail.isEmpty || cpass.isEmpty) {
        showSnackBar(
            'Login Failed.', 'ID and password cannot be empty!', Colors.red);
      } else if (!emailRegExp.hasMatch(cemail)) {
        showSnackBar(
            'Login Failed.', 'Please enter a valid email address.', Colors.red);
      } else if (cpass.length < 6) {
        showSnackBar('Login Failed.',
            'Password must be at least 6 characters long.', Colors.red);
      } else {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: cemail,
            password: cpass,
          );
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(userCredential.user!.uid)
              .get();
          bool userStatus = userDoc.get('Status');
          bool isEmailVerified = userCredential.user!.emailVerified;

          // if (!isEmailVerified) {
          //   setState(() {
          //     _isloading = false;
          //   });
          //   await userCredential.user!
          //       .sendEmailVerification();
          //   showSnackBar('Login Failed.', 'Please verify your email address. An Verification Email is sent to your Email', Colors.red);
          // } else
          if (userStatus) {
            setState(() {
              _isloading = false;
            });
            showSnackBar('Login Successful.', 'User logged in successfully!',
                Colors.green);
            Users user = Users(
              id: userDoc.id,
              type: userDoc["Type"],
              email: userDoc['Email'],
              address: userDoc["Address"],
              name: userDoc["Name"],
              sts: userDoc['Status'],
              phone: userDoc["Phone"],
              pass: userDoc["Password"],
            );
            FirebaseFirestore.instance
                .collection('Users')
                .doc(user.id)
                .update({'Last Login': DateTime.now()});
            handleLogin(user);
          } else {
            setState(() {
              _isloading = false;
            });
            showSnackBar(
                'Login Failed.', 'User is not approved yet.', Colors.red);
          }
        } catch (e) {
          setState(() {
            _isloading = false;
          });
          print(e);
          showSnackBar(
              'Login Failed.',
              'Please verify your email address. An Verification Email is sent to your Email',
              Colors.red);
        }
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/login_bg.png"),
                    fit: BoxFit.fill)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3.49,
                  height: MediaQuery.of(context).size.height / 1.23,
                  margin: EdgeInsets.only(bottom: 40, top: 30, left: 100),
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
                          height: 170,
                        ),
                      ),
                      const Text(
                        textAlign: TextAlign.center,
                        "Login in Account",
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
                              key: Key('emailTextField'),
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
                      const SizedBox(
                        height: 10,
                      ),
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
                              key: Key('passwordTextField'),
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
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Checkbox(
                              value: sts,
                              onChanged: (val) {
                                setState(() {
                                  sts = val!;
                                });
                              },
                            ),
                          ),
                          const Expanded(
                            child: SizedBox(
                              width: 3,
                            ),
                          ),
                          const Text(
                            textAlign: TextAlign.center,
                            "Keep me logged in",
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
                              showForgotPasswordDialog(context);
                            },
                            child: const Text(
                              textAlign: TextAlign.center,
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 14,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          _loginUser();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: const Text(
                            "SIGN IN",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            textAlign: TextAlign.center,
                            "Dont Have An Account? ",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w100),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 3,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(registerPageRoute);
                            },
                            child: const Text(
                              textAlign: TextAlign.center,
                              "Sign Up?",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 14,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
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
