import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/categories/provider/category_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalcategoryWidget extends StatelessWidget {
  const TotalcategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Line chart (unchanged) ──────────────────────────
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
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 25,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
                          ];
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
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
                        FlSpot(0, 1.2), FlSpot(1, 3.0), FlSpot(2, 2.3),
                        FlSpot(3, 3.4), FlSpot(4, 6.3), FlSpot(5, 1.1),
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

          // ── Pie chart — real Firestore counts ──────────────
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
                child: StreamBuilder<Map<String, int>>(
                  stream: context
                      .read<CategoryProvider>()
                      .getCategoryStatsStream(),
                  builder: (context, snapshot) {
                    // ── Loading ──────────────────────────────
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white38,
                          strokeWidth: 2,
                        ),
                      );
                    }

                    final stats = snapshot.data!;
                    final total = stats['total']!;
                    final active = stats['active']!;
                    final inactive = stats['inactive']!;

                    // ── Empty state ──────────────────────────
                    if (total == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Category Status",
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: Text(
                              "No categories yet",
                              style: TextStyle(
                                color: AppColor.whiteColor.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Category Status",
                          style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Pie chart ────────────────────────
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 45,
                              sectionsSpace: 4,
                              sections: [
                                PieChartSectionData(
                                  value: total.toDouble(),
                                  title: "$total",
                                  color: Colors.blue,
                                  radius: 55,
                                  titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: active.toDouble(),
                                  title: "$active",
                                  color: Colors.green,
                                  radius: 55,
                                  titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                if (inactive > 0)
                                  PieChartSectionData(
                                    value: inactive.toDouble(),
                                    title: "$inactive",
                                    color: Colors.orange,
                                    radius: 55,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Legend ───────────────────────────
                        _legendItem(Colors.blue, "Total ($total)"),
                        const SizedBox(height: 8),
                        _legendItem(Colors.green, "Active ($active)"),
                        const SizedBox(height: 8),
                        if (inactive > 0)
                          _legendItem(Colors.orange, "Inactive ($inactive)"),
                      ],
                    );
                  },
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
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}