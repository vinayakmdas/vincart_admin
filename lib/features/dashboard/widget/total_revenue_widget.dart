import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TotalRevenueWidget extends StatelessWidget {
  const TotalRevenueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
     child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Expanded(
          flex: 7,
           child: Container(
              height: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.cardbagroundcolor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 8,
               
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
               
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 25,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ];
               
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
               
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      curveSmoothness: 0.4,
                      color: const Color(0xff7B7CFF),
                      barWidth: 4,
               
                      isStrokeCapRound: true,
               
                      spots: const [
                        FlSpot(0, 1.2),
                        FlSpot(1, 3.0),
                        FlSpot(2, 2.3),
                        FlSpot(3, 3.4),
                        FlSpot(4, 6.3),
                        FlSpot(5, 1.1),
                        FlSpot(6, 5.2),
                      ],
               
                      dotData: const FlDotData(show: false),
               
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xff7B7CFF).withOpacity(.45),
                            const Color(0xff7B7CFF).withOpacity(.02),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
         ),
          
          Expanded(
  flex: 3,
  child: Padding(
    padding: const EdgeInsets.only(left: 12, right: 22),
    child: Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.cardbagroundcolor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Revenue Status",
            style: TextStyle(
              color: AppColor.whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25 ),

          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 45,
                sectionsSpace: 4,
                sections: [
                  PieChartSectionData(
                    value: 100,
                    title: "100",
                    color: Colors.blue,
                    radius: 55,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 70,
                    title: "70",
                    color: Colors.green,
                    radius: 55,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold, 
                    ),
                  ),
                  PieChartSectionData(
                    value: 30,
                    title: "30",
                    color: Colors.orange,
                    radius: 55,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          _legendItem(Colors.blue, "Total Revenue"),
          const SizedBox(height: 8),
        
        ],
      ),
    ),
  ),
),
       ],
     ),
  );
}
static Widget _legendItem(Color color, String title) {
  return Row(
    children: [
      Container(
        width: 12, 
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        title,
        style: TextStyle(
          color: AppColor.whiteColor.withOpacity(0.9), 
          fontSize: 14,
        ),
      ),
    ],
  );
  }
}