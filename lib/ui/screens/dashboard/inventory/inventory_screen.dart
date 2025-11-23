import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/inventory_models.dart';
import '../../../../routes/app_routes.dart';
import 'inventory_provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryProvider>().checkFruitFreshnessAndNotify();
    });
  }

  @override
  Widget build(BuildContext context) {
    final inventoryList = context.watch<InventoryProvider>().inventoryList;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Inventory Buah",
                        style: AppTextStyles.headlineBold,
                      ),
                      Text(
                        "Daftar buah yang Anda simpan",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.notifications_active,
                    color: AppColors.greenOlive,
                    size: 28,
                  )
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: inventoryList.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: inventoryList.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return _buildFruitCard(context, inventoryList[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "Belum ada buah",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFruitCard(BuildContext context, FruitItem fruit) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final diff = fruit.expiryDate - currentTime;
    final daysLeft = (diff / (1000 * 60 * 60 * 24)).ceil();

    Color statusColor;
    String statusText;

    if (daysLeft < 0) {
      statusColor = AppColors.error;
      statusText = "Busuk";
    } else if (daysLeft <= 2) {
      statusColor = AppColors.warning;
      statusText = "$daysLeft Hari";
    } else {
      statusColor = AppColors.greenDark;
      statusText = "$daysLeft Hari";
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
          Navigator.pushNamed(context, AppRoutes.FRUIT_DETAIL, arguments: fruit);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      fruit.grade,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fruit.name,
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Kesegaran: ${fruit.freshness}%",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Divider(height: 1, color: Theme.of(context).dividerColor.withOpacity(0.2)),

            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.FRUIT_ANALYSIS, arguments: fruit);
              },
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      "Lihat Analisa AI",
                      style: TextStyle(
                        color: AppColors.greenDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.auto_awesome, size: 16, color: AppColors.greenDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}