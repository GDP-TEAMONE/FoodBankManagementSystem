import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarrChartWeekly extends StatefulWidget {
  List<double> idates;
  List<double> edates;
  List<DateTime?> datetimes;
  BarrChartWeekly(
      {required this.idates, required this.edates, required this.datetimes});
  @override
  State<BarrChartWeekly> createState() => _BarrChartWeeklyState();
}

class _BarrChartWeeklyState extends State<BarrChartWeekly> {
  int touchedIndex =
      int.parse(DateTime.now().toString().substring(5, 7).toString()) - 1;

  BarChartGroupData makeGroupData(
    int x,
    double sale,
    double pur, {
    bool isTouched = false,
    Color? barColor,
    double width = 25,
  }) {
    barColor ??= Colors.blue;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          toY: sale,
          color: Colors.blue,
          width: width,
        ),
        BarChartRodData(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          toY: pur,
          color: Colors.yellow,
          width: width,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<double> values = [...widget.idates, ...widget.edates];
    List<BarChartGroupData> showingGroups() {
      int numberOfGroups = values.length ~/ 2;
      return List.generate(numberOfGroups, (i) {
        return makeGroupData(
          i,
          values[i],
          values[i + 7],
          isTouched: i == touchedIndex,
        );
      });
    }

    return BarChart(
      BarChartData(
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipRoundedRadius: 0,
                tooltipPadding: const EdgeInsets.only(
                    top: 25, bottom: 0, left: 0, right: 0),
                tooltipMargin: 0,
                fitInsideVertically: false,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '',
                    const TextStyle(),
                    children: <TextSpan>[
                      TextSpan(
                        text: (rod.toY - 1).toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                }),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  touchedIndex = int.parse(DateTime.now()
                          .toString()
                          .substring(5, 7)
                          .toString()) -
                      1;
                  return;
                }
                touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
              });
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (widget.datetimes[value.toInt()] != null) {
                    return Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        DateFormat('EEEE')
                            .format(widget.datetimes[value.toInt()]!),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "N/A",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  return Container(
                    padding: const EdgeInsets.only(top: 5, right: 4),
                    alignment: Alignment.centerRight,
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
              show: true, border: Border.all(color: Colors.grey.shade200)),
          barGroups: showingGroups(),
          maxY: (values.reduce(max) / 1000).ceil() * 1000,
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.shade300,
                  strokeWidth: 0.5,
                );
              },
              getDrawingVerticalLine: (value) {
                return const FlLine(color: Colors.white, strokeWidth: 0.5);
              },
              drawHorizontalLine: true,
              drawVerticalLine: true)),
    );
  }
}
