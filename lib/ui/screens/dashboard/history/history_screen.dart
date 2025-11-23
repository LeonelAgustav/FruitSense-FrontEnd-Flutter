import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/inventory_models.dart';
import '../../../../routes/app_routes.dart';
import 'history_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyList = context.watch<HistoryProvider>().historyList;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.history, color: AppColors.greenDark, size: 28),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Riwayat Scan", style: AppTextStyles.headlineBold),
                      Text(
                        "Aktivitas deteksi sebelumnya",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: historyList.isEmpty
                    ? const Center(child: Text("Belum ada riwayat"))
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: historyList.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _buildHistoryCard(context, historyList[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, FruitItem item) {
    final date = DateTime.fromMillisecondsSinceEpoch(item.dateAdded);
    final dateStr = "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";

    Color gradeColor;
    if (item.grade == "A") {
      gradeColor = AppColors.greenDark;
    } else if (item.grade == "B") {
      gradeColor = AppColors.warning;
    } else {
      gradeColor = AppColors.error;
    }

    // PERBAIKAN: Tambahkan 'child:'
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      surfaceTintColor: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.FRUIT_DETAIL, arguments: item);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.grade,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: gradeColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          dateStr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Text(
                "${item.freshness}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: item.freshness > 70 ? AppColors.greenDark : AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}