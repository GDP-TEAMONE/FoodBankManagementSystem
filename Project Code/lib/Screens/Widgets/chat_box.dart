import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Model/User.dart';
import 'ChatInputField.dart';

class ChatBox extends StatefulWidget {
  Function(Users) removefrom;
  Users usr;
  ChatBox({required this.removefrom, required this.usr});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  void refreshChats() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        margin: const EdgeInsets.only(top: 10, left: 12, right: 13, bottom: 10),
        width: 300,
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.usr.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'inter',
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () => widget.removefrom(widget.usr),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 2, color: Colors.red)),
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: widget.usr.fetchChats(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitFadingCircle(
                        color: Colors.blueAccent,
                        size: 30.0,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No chats available'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final chat = snapshot.data![index];
                        return ChatBubble(
                          message: chat['message'],
                          me: !chat['isSelf'],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 16.0),
            Divider(),
            ChatInputField(
              usr: widget.usr,
              refreshChats: refreshChats,
              isadmin: true,
            ),
          ],
        ));
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool me;

  const ChatBubble({required this.message, required this.me});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 1),
            padding: EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              color: !me ? Colors.grey : Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
