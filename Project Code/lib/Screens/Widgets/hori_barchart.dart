import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarrChart2 extends StatefulWidget {
  List<Map<String, dynamic>> top10medicine;
  BarrChart2({super.key, required this.top10medicine});
  @override
  State<BarrChart2> createState() => _BarrChart2State();
}

class _BarrChart2State extends State<BarrChart2> {
  int touchedIndex =
      int.parse(DateTime.now().toString().substring(5, 7).toString()) - 1;
  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color? barColor,
        double width = 25,
      }) {
    barColor ??= Color(0xFFDEECFF);
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : x%2==0?Color(0xFFE74F4B):Color(0xFFFF9200),
          width: width,
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> showingGroups() {
      return List.generate(widget.top10medicine.length, (i) {
        final isTouched = i == touchedIndex;
        return makeGroupData(
          i,
          widget.top10medicine[i]['quantity'].toDouble(),
          isTouched: isTouched,
          barColor: isTouched ? Colors.yellow : (i % 2 == 0 ? const Color(0xFFE74F4B) : const Color(0xFFFF9200)),
        );
      });
    }

    double maxQuantity = 0.0;
    for (var medicine in widget.top10medicine) {
      double quantity = medicine['quantity'];
      if (quantity > maxQuantity) {
        maxQuantity = quantity;
      }
    }
    maxQuantity = (maxQuantity / 100).ceil() * 100;
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
                        text: (rod.toY-1).toString(),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 8,
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
          titlesData: FlTitlesData(show: true,
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
                  return Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      widget.top10medicine[value.toInt()]['medicineName'],
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
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade200)),
          barGroups: showingGroups(),  maxY: maxQuantity,
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(dashArray: [10,2,10],
                  color: Colors.grey.shade500,
                  strokeWidth: 0.5,
                );
              },
              getDrawingVerticalLine: (value) {
                return const FlLine(color: Colors.white,);
              },)),
    );
  }
}
