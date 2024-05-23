import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final String content;
  final bool ifreq;
  final TextEditingController txt;

  InputField(
      {required this.label,
      required this.ifreq,
      required this.content,
      required this.txt});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: 700,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "$label :  ",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'opensans',
                  ),
                ),
              ),
              ifreq
                  ? const Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    )
                  : SizedBox(),
              const Expanded(
                child: SizedBox(
                  width: 40.0,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.7,
                color: Colors.blue[50],
                child: TextField(
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'opensans',
                  ),
                  controller: txt,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: content,
                    fillColor: Colors.blue[50],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
