import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../../providers/order_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final todayOrders = orderState.todayOrders;
    final allOrders = orderState.orders;

    // Calculate stats
    final totalRevenue =
        allOrders.fold(0.0, (s, o) => s + o.total);
    final completedOrders = allOrders
        .where((o) => o.status == OrderStatus.completed)
        .length;

    // Top items
    final itemCounts = <String, int>{};
    for (final order in allOrders) {
      for (final item in order.items) {
        itemCounts[item.item.name] =
            (itemCounts[item.item.name] ?? 0) + item.quantity;
      }
    }
    final topItems = itemCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Last 7 days revenue
    final last7Days = List.generate(7, (i) {
      final date =
          DateTime.now().subtract(Duration(days: 6 - i));
      final dayOrders = allOrders.where((o) =>
          o.createdAt.year == date.year &&
          o.createdAt.month == date.month &&
          o.createdAt.day == date.day);
      return dayOrders.fold(0.0, (s, o) => s + o.total);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Analytics',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w700)),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary stats
          _buildSummaryStats(
              allOrders.length, totalRevenue, completedOrders),

          const SizedBox(height: 20),

          // Revenue chart
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Last 7 Days Revenue',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
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
                              final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              final idx = value.toInt();
                              return Text(
                                idx < days.length ? days[idx] : '',
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: AppColors.textHint),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: last7Days.asMap().entries.map((e) {
                        return BarChartGroupData(
                          x: e.key,
                          barRods: [
                            BarChartRodData(
                              toY: e.value,
                              color: AppColors.primary,
                              width: 20,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Top Selling Items
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('⭐ Top Selling Items',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 12),
                if (topItems.isEmpty)
                  Center(
                    child: Text('No sales data yet',
                        style: GoogleFonts.inter(
                            color: AppColors.textHint, fontSize: 13)),
                  )
                else
                  ...topItems.take(5).toList().asMap().entries.map((e) {
                    final maxCount = topItems.first.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${e.key + 1}. ${e.value.key}',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '${e.value.value} sold',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: e.value.value / maxCount,
                            backgroundColor: AppColors.divider,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              e.key == 0
                                  ? AppColors.accent
                                  : AppColors.primary,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            minHeight: 6,
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),

          // Today
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📅 Today's Summary",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _TodayStat('Orders', '${todayOrders.length}'),
                    _TodayStat(
                      'Revenue',
                      AppFormatters.formatPrice(orderState.todayRevenue),
                    ),
                    _TodayStat(
                      'Avg Order',
                      todayOrders.isEmpty
                          ? '₹0'
                          : AppFormatters.formatPrice(
                              orderState.todayRevenue / todayOrders.length),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(
      int total, double revenue, int completed) {
    return Row(
      children: [
        _MiniStat(
            label: 'Total Orders', value: '$total', color: AppColors.primary),
        const SizedBox(width: 10),
        _MiniStat(
            label: 'Total Revenue',
            value: AppFormatters.formatPrice(revenue),
            color: AppColors.accent),
        const SizedBox(width: 10),
        _MiniStat(
            label: 'Completed',
            value: '$completed',
            color: AppColors.statusCompleted),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 8,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                  fontSize: 10, color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayStat extends StatelessWidget {
  final String label;
  final String value;

  const _TodayStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18)),
        Text(label,
            style:
                GoogleFonts.inter(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}
