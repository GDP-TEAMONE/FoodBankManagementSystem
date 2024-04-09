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
