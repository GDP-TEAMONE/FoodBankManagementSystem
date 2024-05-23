import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Model/User.dart';

class ChatInputField extends StatefulWidget {
  Users usr;
  bool isadmin;
  final Function refreshChats;
  ChatInputField(
      {required this.usr, required this.refreshChats, required this.isadmin});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  var msg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _submit() async {
      String message = msg.text.toString();
      try {
        if (message.isEmpty) {
          Get.snackbar(
            "Message Send Failed.",
            "Empty Message.",
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
        await FirebaseFirestore.instance.collection('ChatsAdmin').add({
          'userId': widget.usr.id,
          'message': message,
          'timestamp': DateTime.now(),
          'seen': false,
          'isSelf': !widget.isadmin,
        }).then((value) {
          msg.clear();
          widget.refreshChats();
        });
      } catch (e) {
        rethrow;
      }
    }

    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: msg,
              onSubmitted: (_) {
                _submit();
              },
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                contentPadding: EdgeInsets.all(12.0),
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: TextStyle(fontFamily: 'inter', fontSize: 14),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send_outlined,
              size: 20,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              _submit();
            },
          ),
        ],
      ),
    );
  }
}
