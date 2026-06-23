import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/order/provider/order_provider.dart'; // fix path
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class TotalordersWidget extends StatelessWidget {
  const TotalordersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

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
                stream: orderProvider.getWeeklyOrderStream(),
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
                      "Order Status",
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: StreamBuilder<List<int>>(
                        stream: Rx.combineLatest3<int, int, int, List<int>>(
                          orderProvider.getOrderCountStream("total"),
                          orderProvider.getOrderCountStream("delivered"),
                          orderProvider.getOrderCountStream("pending"),
                          (total, delivered, pending) =>
                              [total, delivered, pending],
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white70,
                              ),
                            );
                          }

                          final total = snapshot.data![0];
                          final delivered = snapshot.data![1];
                          final pending = snapshot.data![2];

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
                                  value:
                                      delivered == 0 ? 0.01 : delivered.toDouble(),
                                  title: "$delivered",
                                  color: Colors.green,
                                  radius: 55,
                                  titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: pending == 0 ? 0.01 : pending.toDouble(),
                                  title: "$pending",
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
                      ),
                    ),
                    const SizedBox(height: 20),
                    _legendItem(Colors.blue, "Total Order"),
                    const SizedBox(height: 8),
                    _legendItem(Colors.green, "Delivered Order"),
                    const SizedBox(height: 8),
                    _legendItem(Colors.orange, "Pending Order"),
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