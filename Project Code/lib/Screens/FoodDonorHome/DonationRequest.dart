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

class DonationRequestForm extends StatefulWidget {
  @override
  _DonationRequestFormState createState() => _DonationRequestFormState();
}

class _DonationRequestFormState extends State<DonationRequestForm> {
  bool _isloading = false;

  List<FoodModel> foods = [];

  var categoryindx;
  var _expirationDate = DateTime.now();
  var _pickupDeliveryTime = TimeOfDay.now();
  var _description = TextEditingController();
  var _donationType;
  var _deliveryOption;
  var _address = TextEditingController();
  var _contactInfo = TextEditingController();
  var _additionalNotes = TextEditingController();

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
    if (foods.length == 0 || _donationType == null || _deliveryOption == null) {
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
      String formattedTime = formatTimeOfDay(_pickupDeliveryTime);

      List<Map<String, dynamic>> foodMaps =
          foods.map((food) => food.toMapWithoutController()).toList();

      await FirebaseFirestore.instance.collection('FoodDonation').add({
        'foods': foodMaps,
        'expirationDate': _expirationDate,
        'pickupDeliveryTime': formattedTime,
        'description': _description.text,
        'donationType': _donationType,
        'deliveryOption': _deliveryOption,
        'address': _address.text,
        'contactInfo': _contactInfo.text,
        'status': 'Requested',
        'requested date': DateTime.now(),
        'requested by': AuthService.to.user?.id,
        'additionalNotes': _additionalNotes.text,
      }).then((value) {
        setState(() {
          _isloading = false;
        });
        Get.back();
        Get.snackbar(
          "Donation Request Added Successfully.",
          "Wait For The Admin To Approve And Assign Volunteer!",
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
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _pickupDeliveryTime,
    );
    if (picked != null && picked != _pickupDeliveryTime) {
      setState(() {
        _pickupDeliveryTime = picked;
      });
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
            child: SingleChildScrollView(scrollDirection: Axis.horizontal,
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
                        child: SingleChildScrollView(
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
                                child: Text(
                                  "Add The Details To Kick Of Donations",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: const Text(
                                  "The whole process is maintained by the administrator with careful consideration. Admin will assign Volunteer to Pick Up.",
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
                                child: CircleAvatar(
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
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 40.0, left: 50.0,  right: 50.0,bottom: 40.0),
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
                                                  style: const TextStyle(
                                                    fontFamily: 'opensans',
                                                  ),
                                                ),
                                              ),
                                              const Text(
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
                          const SizedBox(height: 10.0),
                          LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return SizedBox(
                                width: 650,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      width: 140.0,
                                      child: Text(
                                        "Select Category",
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
                                      width:
                                          MediaQuery.of(context).size.width / 3.7,
                                      height: 50,
                                      padding: const EdgeInsets.all(10),
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
                              ? const SizedBox(height: 10.0)
                              : const SizedBox(),
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
                                            padding: const EdgeInsets.all(10),
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
                                                      style: TextStyle(
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
                              : const SizedBox(),
                          const SizedBox(height: 10.0),
                          LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return SizedBox(
                                width: 650,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      width: 140.0,
                                      child: Text(
                                        "Description",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: 'opensans',
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: SizedBox(
                                        width: 40.0,
                                      ),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3.7,
                                      color: Colors.blue[50],
                                      child: TextField(
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'opensans',
                                        ),
                                        controller: _description,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blue.withOpacity(0.5),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blue.withOpacity(0.5),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          hintText: "Description",
                                          fillColor: Colors.blue[50],
                                        ),
                                        maxLines: 3,
                                        minLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10.0),
                          LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return SizedBox(
                                width: 650,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: 140.0,
                                      child: Text(
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
                          const SizedBox(height: 10.0),
                          LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return SizedBox(
                                width: 650,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: const Text(
                                        "Donation Type  ",
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
                                      child: DropdownButton(
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        value: _donationType,
                                        hint: const Text(
                                          'Donation Type',
                                          style: TextStyle(
                                            fontFamily: 'opensans',
                                          ),
                                        ),
                                        items: [
                                          'Perishable Food',
                                          'Non-perishable Food',
                                          'Cooked Meals'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                fontFamily: 'opensans',
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _donationType = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10.0),
                          LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return SizedBox(
                                width: 650,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: 140.0,
                                      child: Text(
                                        "Proceeding Options",
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
                                      width:
                                          MediaQuery.of(context).size.width / 3.7,
                                      height: 50,
                                      padding: const EdgeInsets.all(10),
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.blueAccent
                                                .withOpacity(0.5)),
                                        color: Colors.blue[50],
                                      ),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        value: _deliveryOption,
                                        hint: const Text(
                                          "Proceeding Options",
                                          style: TextStyle(
                                            fontFamily: 'opensans',
                                          ),
                                        ),
                                        items: ['Deliver', 'Drop Off']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                fontFamily: 'opensans',
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _deliveryOption = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10.0),
                          (_deliveryOption == 'Deliver')
                              ? InputField(
                                  label: "Address",
                                  txt: _address,
                                  ifreq: false,
                                  content: "Address To Pick Up")
                              : const SizedBox(),
                          (_deliveryOption == 'Deliver')
                              ? const SizedBox(height: 20.0)
                              : const SizedBox(),
                          InputField(
                              label: "Contact Information",
                              txt: _contactInfo,
                              ifreq: false,
                              content: "Your Additional Contact"),
                          const SizedBox(height: 10.0),
                          (_deliveryOption == 'Drop Off')
                              ? LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return Container(
                                      width: 650,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 140.0,
                                            child: const Text(
                                              "Drop Of Time",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: 'opensans',
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(
                                              width: 40.0,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _selectTime(context);
                                            },
                                            child: Container(
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
                                              child: Text(
                                                DateFormat('hh:mm a').format(
                                                    DateTime(
                                                        2022,
                                                        1,
                                                        1,
                                                        _pickupDeliveryTime.hour,
                                                        _pickupDeliveryTime
                                                            .minute)),
                                                style: const TextStyle(
                                                  fontFamily: 'opensans',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : SizedBox(),
                          (_deliveryOption == 'Drop Off')
                              ? SizedBox(height: 10.0)
                              : SizedBox(),
                          InputField(
                              label: "Additional Note",
                              txt: _additionalNotes,
                              ifreq: false,
                              content: "Additional Notes"),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 170.0,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontFamily: 'opensans',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  saveFormData();
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'opensans',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
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
