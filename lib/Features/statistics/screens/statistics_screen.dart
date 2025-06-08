import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/Features/changeState/widgets/build_cart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "إحصائيات شاملة",
                      style: context.textTheme.titleMedium!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 133,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8FCF5),
                        borderRadius: BorderRadius.circular(66),
                        border: Border.all(color: const Color(0xFF16CA8B)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/FileArrowDown.svg",
                              color: const Color(0xFF0C6E4C),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                'تحميل تقرير',
                                style: context.textTheme.titleSmall!.copyWith(
                                  color: const Color(0xFF0C6E4C),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                buildCart(
                  context,
                  title: "إجمالي الأرباح",
                  subtitle: '300,000',
                  iconPath: "assets/svg/coines.svg",
                  iconColor: const Color(0xFF16CA8B),
                  expanded: false,
                ),
                const SizedBox(height: 24),
                Text(
                  "إحصائيات حالة الطلبات اليومية",
                  style: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPieChart(context),
                const SizedBox(height: 24),
                Text(
                  "إحصائيات الإيرادات الشهرية",
                  style: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                _buildLineChart(context),
                const SizedBox(height: 24),

                // 👇 Add Province Chart
                Text(
                  "عدد الطلبات حسب المحافظة",
                  style: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildProvinceOrdersChart(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProvinceOrdersChart() {
  final List<String> provinces = ['ذي قار', 'واسط', 'بابل', 'موصل', 'بصرة', 'اربيل', 'بغداد'];
  final List<int> values = [182, 90, 1203, 390, 194, 267, 200];
  final double maxY = values.reduce((a, b) => a > b ? a : b).toDouble() * 1.2;

  return SizedBox(
    height: 220,
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final int index = value.toInt();
                if (index >= 0 && index < provinces.length) {
                  
                  return SideTitleWidget(
                    meta: meta,
                     
                    child: Text(
                      provinces[index],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
              reservedSize: 42,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: List.generate(provinces.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: values[index].toDouble(),
                  width: 40,
                color: const Color(0xFF00C389),
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY,
                  color: const Color(0xFFF3F5F7),
                ),
              ),
            ],
          );
        }),
      ),
    ),
  );
}



  SizedBox _buildLineChart(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = ['01', '02', '03', '04', '05', '06'];
                  return Text(
                    months[value.toInt() % months.length],
                    style: const TextStyle(fontSize: 12),
                  );
                },
                reservedSize: 32,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: false,
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 5),
                FlSpot(1, 9),
                FlSpot(2, 6),
                FlSpot(3, 10),
                FlSpot(4, 7),
                FlSpot(5, 8),
              ],
              isCurved: true,
              color: const Color(0xff314CFF),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.2),
              ),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    final chartData = [
      {"label": "مكتمل", "value": 3500, "color": const Color(0xFF8CD98C)},
      {"label": "قيد التوصيل", "value": 1500, "color": const Color(0xFF80D4FF)},
      {"label": "قيد التحضير", "value": 2500, "color": const Color(0xFFFFE500)},
      {"label": "ملغي", "value": 500, "color": const Color(0xFFE96363)},
      {"label": "مرتجع", "value": 2000, "color": const Color(0xFFAA80FF)},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            child: Center(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 55,
                  sections: chartData.map((data) {
                    double total = chartData.fold(0,
                        (sum, item) => sum + (item['value'] as int));
                    double percent = (data['value'] as int) / total * 100;
                    return _buildPieSection(
                      context,
                      percent,
                      data['color'] as Color,
                      "${percent.toStringAsFixed(0)}%",
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...chartData.map((data) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: data['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(data['label'].toString(),
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  Text(data['value'].toString(),
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  PieChartSectionData _buildPieSection(BuildContext context, double value,
      Color color, String percentText) {
    return PieChartSectionData(
      value: value,
      color: color,
      showTitle: false,
      badgeWidget: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: context.colorScheme.outline, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          percentText,
          style: context.textTheme.titleMedium!.copyWith(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      badgePositionPercentageOffset: 1,
    );
  }
}
