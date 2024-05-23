import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OverViewWidget extends StatelessWidget {
  IconData icon;String text, number;
  Color color;

  OverViewWidget(
      {required this.icon,
      required this.color,
      required this.text,
      required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 5.7,
      height: 170,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 4,
              offset: const Offset(2, 5)),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                 size: 47,
                ),
                const Expanded(
                    child: SizedBox(
                  width: 3,
                )),
                const Row(
                  children: [
                    Text(
                      "Show Details",
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.lightBlue,
                      size: 10,
                    )
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  number,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 46,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
