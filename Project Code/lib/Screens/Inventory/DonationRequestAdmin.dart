import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodbankmanagementsystem/helper/auth_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../Model/FoodModel.dart';
import '../../helper/values.dart';
import '../Widgets/input_field.dart';

class DonationRequestAdminForm extends StatefulWidget {
  @override
  _DonationRequestAdminFormState createState() =>
      _DonationRequestAdminFormState();
}

class _DonationRequestAdminFormState extends State<DonationRequestAdminForm> {
  bool _isloading = false;

  List<FoodModel> foods = [];

  var categoryindx;
  var _expirationDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _expirationDate) {
      setState(() {
        _expirationDate = picked;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }

  Future<void> saveFormData() async {
    setState(() {
      _isloading = true;
    });
    bool hasEmptyQuantity = foods.any((food) => food.quantity.text.isEmpty);
    if (foods.length == 0) {
      setState(() {
        _isloading = false;
      });
      Get.snackbar(
        "Donation Request Adding Failed.",
        "Items, Donation Type & Proceeding Option is Required!",
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
    } else if (hasEmptyQuantity) {
      setState(() {
        _isloading = false;
      });
      Get.snackbar(
        "Donation Request Adding Failed.",
        "All added food items quantity is required!",
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
      List<Map<String, dynamic>> foodMaps =
          foods.map((food) => food.toMapWithoutController()).toList();

      for (int i = 0; i < foods.length; i++) {
        var food = foodMaps[i];
        var name = food['name'] as String?;
        await FirebaseFirestore.instance
            .collection('Inventory')
            .doc(food['name'])
            .get()
            .then((value) async {
          if (value.exists) {
            await FirebaseFirestore.instance
                .collection('Inventory')
                .doc(food['name'])
                .set({
              'Name': name,
              'Category': food['category'],
              'Quantity': food['quantity'] + value["Quantity"],
              'expiredate': _expirationDate,
            }).then((value) {
              Get.back();
              Get.snackbar(
                "Inventory Updated Successfully.",
                "The item added to the inventory.",
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
            });
          } else {
            await FirebaseFirestore.instance
                .collection('Inventory')
                .doc(food['name'])
                .set({
              'Name': name,
              'Category': food['category'],
              'Quantity': food['quantity'],
              'expiredate': _expirationDate,
            }).then((value) {
              Get.back();
              Get.snackbar(
                "Inventory Updated Successfully.",
                "The item added to the inventory.",
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
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          elevation: 5.0,
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3.3,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.yellow[600],
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 70.0, right: 50.0, left: 50.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Image.asset(
                              "assets/logo.png",
                              height: 170,
                            ),
                          ),
                          SizedBox(
                            height: 60.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: const Text(
                              "Add The items to inventory",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: const Text(
                              "Add New Items to the inventory..",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Container(
                            child: const CircleAvatar(
                              backgroundColor: Colors.black87,
                              child: Text(
                                ">",
                                style: TextStyle(color: Colors.yellow),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 40.0, left: 300.0, bottom: 40.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Container(
                              width: 650,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 140.0,
                                    child: const Text(
                                      "Items & Quantities",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: 'opensans',
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  const Expanded(
                                    child: SizedBox(
                                      width: 40.0,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3.7,
                                    height: 50,
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.blueAccent
                                              .withOpacity(0.5)),
                                      color: Colors.blue[50],
                                    ),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: foods.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(
                                                "${foods[index].name} : ",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontFamily: 'opensans',
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '*  ',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            Container(
                                              width: 70,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white,
                                              ),
                                              child: TextField(
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: 'opensans',
                                                ),
                                                controller:
                                                    foods[index].quantity,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(10.0),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.blue
                                                          .withOpacity(0.5),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.blue
                                                          .withOpacity(0.5),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  hintText: "Quantity",
                                                  hintStyle:
                                                      TextStyle(fontSize: 12),
                                                  fillColor: Colors.blue[50],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: const Text(
                                                " ,  ",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily: 'opensans',
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10.0),
                        LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Container(
                              width: 650,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 140.0,
                                    child: Text(
                                      "Select Category",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: 'opensans',
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: 40.0,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3.7,
                                    height: 50,
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.blueAccent
                                              .withOpacity(0.5)),
                                      color: Colors.blue[50],
                                    ),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: category.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                categoryindx = index;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  categoryindx == index
                                                      ? Colors.blue
                                                      : Colors.grey,
                                            ),
                                            child: Text(
                                              category[index],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'opensans',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        categoryindx != null
                            ? SizedBox(height: 10.0)
                            : SizedBox(),
                        categoryindx != null
                            ? LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  return Container(
                                    width: 650,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 140.0,
                                          child: const Text(
                                            "Select Sub Category",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'opensans',
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          '*',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        const Expanded(
                                          child: SizedBox(
                                            width: 40.0,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.7,
                                          height: 50,
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.blueAccent
                                                    .withOpacity(0.5)),
                                            color: Colors.blue[50],
                                          ),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: subcategory[categoryindx]
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      bool itemExists =
                                                          foods.any((food) =>
                                                              food.name ==
                                                                  subcategory[
                                                                          categoryindx]
                                                                      [index] &&
                                                              food.category ==
                                                                  category[
                                                                      categoryindx]);
                                                      if (!itemExists) {
                                                        foods.add(FoodModel(
                                                            name: subcategory[
                                                                    categoryindx]
                                                                [index],
                                                            category: category[
                                                                categoryindx],
                                                            quantity:
                                                                TextEditingController()));
                                                      }
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue,
                                                  ),
                                                  child: Text(
                                                    subcategory[categoryindx]
                                                        [index],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'opensans',
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : SizedBox(),
                        SizedBox(height: 10.0),
                        LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Container(
                              width: 650,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 140.0,
                                    child: const Text(
                                      "Expire Date",
                                      style: TextStyle(
                                        fontFamily: 'opensans',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const Expanded(
                                    child: SizedBox(
                                      width: 40.0,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.7,
                                      height: 50,
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.blueAccent
                                                .withOpacity(0.5)),
                                        color: Colors.blue[50],
                                      ),
                                      child: Text(
                                        DateFormat.yMMMMd()
                                            .format(_expirationDate),
                                        style: TextStyle(
                                          fontFamily: 'opensans',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 170.0,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontFamily: 'opensans',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                saveFormData();
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'opensans',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
    );
  }
}
