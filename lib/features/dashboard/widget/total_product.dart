import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/product_menagement/provider/product_management_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalProductWidget extends StatelessWidget {
  const TotalProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- LINE CHART ----------------
          Expanded(
            flex: 7,
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.cardbagroundcolor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: StreamBuilder<List<int>>(
                stream: productProvider.getWeeklyProductStream(),
                builder: (context, snapshot) {
                  final weekly = snapshot.data ?? List<int>.filled(7, 0);
                  final maxCount =
                      weekly.isEmpty ? 0 : weekly.reduce((a, b) => a > b ? a : b);
                  final maxY = (maxCount < 5 ? 5 : maxCount + 2).toDouble();

                  return LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      maxY: maxY,
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
                          spots: List.generate(
                            7,
                            (i) => FlSpot(i.toDouble(), weekly[i].toDouble()),
                          ),
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
                  );
                },
              ),
            ),
          ),

          // ---------------- PIE CHART ----------------
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
                      "Product Status",
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: StreamBuilder<int>(
                        stream: productProvider.getCountStream("total"),
                        builder: (context, totalSnap) {
                          return StreamBuilder<int>(
                            stream: productProvider.getCountStream("active"),
                            builder: (context, activeSnap) {
                              return StreamBuilder<int>(
                                stream: productProvider.getCountStream("inactive"),
                                builder: (context, inactiveSnap) {
                                  final total = totalSnap.data ?? 0;
                                  final active = activeSnap.data ?? 0;
                                  final inactive = inactiveSnap.data ?? 0;

                                  if (!totalSnap.hasData &&
                                      !activeSnap.hasData &&
                                      !inactiveSnap.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white70,
                                      ),
                                    );
                                  }

                                  return PieChart(
                                    PieChartData(
                                      centerSpaceRadius: 45,
                                      sectionsSpace: 4,
                                      sections: [
                                        PieChartSectionData(
                                          value: total == 0 ? 0.01 : total.toDouble(),
                                          title: "$total",
                                          color: Colors.blue,
                                          radius: 55,
                                          titleStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        PieChartSectionData(
                                          value: active == 0 ? 0.01 : active.toDouble(),
                                          title: "$active",
                                          color: Colors.green,
                                          radius: 55,
                                          titleStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        PieChartSectionData(
                                          value: inactive == 0 ? 0.01 : inactive.toDouble(),
                                          title: "$inactive",
                                          color: Colors.orange,
                                          radius: 55,
                                          titleStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _legendItem(Colors.blue, "Total Products"),
                    const SizedBox(height: 8),
                    _legendItem(Colors.green, "Active Products"),
                    const SizedBox(height: 8),
                    _legendItem(Colors.orange, "Inactive Products"),
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