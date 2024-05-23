import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  String text;
  Color clr;
  double font;
  StyledText({required this.text, this.font = 14, this.clr = Colors.black});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign
          .center,
      style:
      TextStyle(
          fontSize:
          14,
          color: clr,
          fontFamily:
          'inter'),
    );
  }
}
