import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map_location_picker/flutter_map_location_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodbankmanagementsystem/helper/auth_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../Model/FoodModel.dart';
import '../../Model/InventoryModel.dart';
import '../../helper/values.dart';
import '../Widgets/input_field.dart';

class InventoryRequestForm extends StatefulWidget {
  List<InventoryModel> cartItems;
  Function resetcart;
  InventoryRequestForm({required this.cartItems, required this.resetcart});

  @override
  _InventoryRequestFormState createState() => _InventoryRequestFormState();
}

class _InventoryRequestFormState extends State<InventoryRequestForm> {
  bool _isloading = false;
  double? latitude;
  double? longitude;
  bool selectlocation = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Location location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw 'Location services are disabled.';
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw 'Location permissions are denied.';
        }
      }

      LocationData currentLocation = await location.getLocation();
      setState(() {
        latitude = double.parse(currentLocation.latitude.toString());
        longitude = double.parse(currentLocation.longitude.toString());
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> saveFormData() async {
    setState(() {
      _isloading = true;
    });
    if (latitude == null || longitude == null) {
      setState(() {
        _isloading = false;
      });
      Get.snackbar(
        "Inventory Request Adding Failed.",
        "Delivery Address is Required!",
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
      List<Map<String, dynamic>> foodMaps = widget.cartItems
          .map((food) => food.toMapWithoutController())
          .toList();

      await FirebaseFirestore.instance.collection('InventoryReceive').add({
        'Items': foodMaps,
        'Longitude': longitude,
        'Latitude': latitude,
        'status': 'Requested',
        'requested date': DateTime.now(),
        'requested by': AuthService.to.user?.id,
      }).then((value) {
        setState(() {
          _isloading = false;
        });
        widget.resetcart();

        Get.back();
        Get.snackbar(
          "Inventory Request Added Successfully.",
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 5.0,
            child: Container(
              padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Cart Items To Request        ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'opensans',
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DataTable(
                      columns: const [
                        DataColumn(
                            label: Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'opensans',
                            fontSize: 14,
                          ),
                        )),
                        DataColumn(
                            label: Text(
                          'Category',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'opensans',
                            fontSize: 14,
                          ),
                        )),
                        DataColumn(
                            numeric: false,
                            label: Text(
                              '    Quantity',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'opensans',
                                fontSize: 14,
                              ),
                            )),
                      ],
                      rows: List<DataRow>.generate(
                        widget.cartItems.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(Text(
                              widget.cartItems[index].name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'opensans',
                                fontSize: 14,
                              ),
                            )),
                            DataCell(Text(
                              widget.cartItems[index].category,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'opensans',
                                fontSize: 14,
                              ),
                            )),
                            DataCell(
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (widget.cartItems[index].quantity >
                                              1) {
                                            widget.cartItems[index].quantity--;
                                          } else {
                                            widget.cartItems.removeAt(index);
                                          }
                                          if (widget.cartItems.length == 0) {
                                            Get.back();
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.remove),
                                    ),
                                  ),
                                  Text(
                                    "  ${widget.cartItems[index].quantity}  ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'opensans',
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (widget.cartItems[index].quantity <
                                              widget.cartItems[index]
                                                  .maxquantity) {
                                            widget.cartItems[index].quantity++;
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 660,
                      height: 300,
                      child: MapLocationPicker(
                        initialLatitude: latitude,
                        initialLongitude: longitude,
                        onPicked: (result) {},
                        backgroundColor: Colors.white,
                        centerWidget: const Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.blue,
                        ),
                        sideButtonsColor: Colors.blue,
                        customFooter: (result, controller) {
                          return Container();
                        },
                        myLocationButtonEnabled: true,
                        zoomButtonEnabled: true,
                        searchBarEnabled: false,
                        switchMapTypeEnabled: false,
                        mapType: MapType.normal,
                        sideWidget: (result, controller) {
                          return TextButton.icon(
                            onPressed: () {
                              latitude = result.latitude;
                              longitude = result.longitude;
                              selectlocation = true;
                              setState(() {});
                            },
                            label: const Text(
                              "Select Location",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue)),
                            icon: const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
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
                            "Request",
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
          ),
          _isloading
              ? const Center(
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
