import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarrChartYearly extends StatefulWidget {
  double cjan,
      cfeb,
      cmar,
      capr,
      cmay,
      cjun,
      cjul,
      caug,
      csept,
      coct,
      cnov,
      cdec,
      ejan,
      efeb,
      emar,
      eapr,
      emay,
      ejun,
      ejul,
      eaug,
      esept,
      eoct,
      enov,
      edec;
  BarrChartYearly(
      {required this.cjan,
      required this.cfeb,
      required this.cmar,
      required this.capr,
      required this.cmay,
      required this.cjun,
      required this.cjul,
      required this.caug,
      required this.csept,
      required this.coct,
      required this.cnov,
      required this.cdec,
      required this.ejan,
      required this.efeb,
      required this.emar,
      required this.eapr,
      required this.emay,
      required this.ejun,
      required this.ejul,
      required this.eaug,
      required this.esept,
      required this.eoct,
      required this.enov,
      required this.edec});
  @override
  State<BarrChartYearly> createState() => _BarrChartYearlyState();
}

class _BarrChartYearlyState extends State<BarrChartYearly> {
  int touchedIndex =
      int.parse(DateTime.now().toString().substring(5, 7).toString()) - 1;

  BarChartGroupData makeGroupData(
    int x,
    double sale,
    double pur, {
    bool isTouched = false,
    Color? barColor,
    double width = 20,
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
    List<double> values = [
      widget.cjan,
      widget.cfeb,
      widget.cmar,
      widget.capr,
      widget.cmay,
      widget.cjun,
      widget.cjul,
      widget.caug,
      widget.csept,
      widget.coct,
      widget.cnov,
      widget.cdec,
      widget.ejan,
      widget.efeb,
      widget.emar,
      widget.eapr,
      widget.emay,
      widget.ejun,
      widget.ejul,
      widget.eaug,
      widget.esept,
      widget.eoct,
      widget.enov,
      widget.edec
    ];
    List<BarChartGroupData> showingGroups() => List.generate(12, (i) {
          switch (i) {
            case 0:
              return makeGroupData(
                0,
                values[0],
                values[12],
                isTouched: i == touchedIndex,
              );
            case 1:
              return makeGroupData(
                1,
                values[1],
                values[13],
                isTouched: i == touchedIndex,
              );
            case 2:
              return makeGroupData(2, values[2], values[14],
                  isTouched: i == touchedIndex);
            case 3:
              return makeGroupData(3, values[3], values[15],
                  isTouched: i == touchedIndex);
            case 4:
              return makeGroupData(4, values[4], values[16],
                  isTouched: i == touchedIndex);
            case 5:
              return makeGroupData(5, values[5], values[17],
                  isTouched: i == touchedIndex);
            case 6:
              return makeGroupData(6, values[6], values[18],
                  isTouched: i == touchedIndex);
            case 7:
              return makeGroupData(7, values[7], values[19],
                  isTouched: i == touchedIndex);
            case 8:
              return makeGroupData(8, values[8], values[20],
                  isTouched: i == touchedIndex);
            case 9:
              return makeGroupData(9, values[9], values[21],
                  isTouched: i == touchedIndex);
            case 10:
              return makeGroupData(10, values[10], values[22],
                  isTouched: i == touchedIndex);
            case 11:
              return makeGroupData(11, values[11], values[23],
                  isTouched: i == touchedIndex);
            default:
              return throw Error();
          }
        });

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
                  String text = '';
                  switch (value.toInt()) {
                    case 0:
                      text = 'Jan';
                      break;
                    case 1:
                      text = 'Feb';
                      break;
                    case 2:
                      text = 'Mar';
                      break;
                    case 3:
                      text = 'Apr';
                      break;
                    case 4:
                      text = 'May';
                      break;
                    case 5:
                      text = 'Jun';
                      break;
                    case 6:
                      text = 'Jul';
                      break;
                    case 7:
                      text = 'Aug';
                      break;
                    case 8:
                      text = 'Sep';
                      break;
                    case 9:
                      text = 'Oct';
                      break;
                    case 10:
                      text = 'Nov';
                      break;
                    case 11:
                      text = 'Dec';
                      break;
                  }

                  return Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      text,
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
