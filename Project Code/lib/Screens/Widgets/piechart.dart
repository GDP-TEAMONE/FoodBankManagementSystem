import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieCharts extends StatefulWidget {
  final double totaldonation, totalreceived, inventory;
  PieCharts({
    required this.inventory,
    required this.totaldonation,
    required this.totalreceived,
  });

  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State<PieCharts> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> showingSections() {
      return List.generate(3, (i) {
        final isTouched = i == touchedIndex;
        const fontSize = 10.0;
        final radius = isTouched ? 110.0 : 100.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: Colors.blue,
              value: widget.totalreceived,
              title: isTouched ? 'Total Received: ${widget.totalreceived}/-' : "",
              radius: radius,
              titleStyle: const TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff),
                shadows: shadows,
              ),
            );
          case 1:
            return PieChartSectionData(
              color: Colors.brown,
              value: widget.totaldonation,
              title: isTouched ? 'Total Donation: ${widget.totaldonation}/-' : "",
              radius: radius,
              titleStyle: const TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff),
                shadows: shadows,
              ),
            );
          default:
            return PieChartSectionData(
              color: Colors.green,
              value: widget.inventory,
              title: isTouched ? 'Total Inventory: ${widget.inventory}/-' : "",
              radius: radius,
              titleStyle: const TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff),
                shadows: shadows,
              ),
            );
        }
      });
    }
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 0,
        sections: showingSections(),
      ),
    );
  }
}
