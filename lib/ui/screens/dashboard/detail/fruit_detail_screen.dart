import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/inventory_models.dart';

class FruitDetailScreen extends StatelessWidget {
  final FruitItem fruitItem;

  const FruitDetailScreen({super.key, required this.fruitItem});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(fruitItem.dateAdded);
    final addedDateStr = "${date.day}/${date.month}/${date.year}";

    String expiryInfo = "-";
    if (fruitItem.expiryDate > 0) {
      final diff = DateTime.fromMillisecondsSinceEpoch(fruitItem.expiryDate)
          .difference(DateTime.now());
      final days = diff.inDays;

      if (days < 0) {
        expiryInfo = "Sudah Kadaluarsa (${days.abs()} hari lalu)";
      } else if (days == 0) {
        expiryInfo = "Busuk Hari Ini";
      } else {
        expiryInfo = "Sisa $days Hari";
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: _buildHeaderImage(fruitItem.imageUri),
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.greenDark,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      "Grade ${fruitItem.grade}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fruitItem.name,
                              style: AppTextStyles.headlineBold.copyWith(
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Ditambahkan: $addedDateStr",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              value: fruitItem.freshness / 100,
                              color: fruitItem.freshness > 50
                                  ? AppColors.greenDark
                                  : AppColors.error,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              strokeWidth: 6,
                            ),
                          ),
                          Text(
                            "${fruitItem.freshness}%",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // PERBAIKAN: Tambahkan 'child:'
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Estimasi Kadaluarsa",
                                  style: AppTextStyles.labelSmall),
                              Text(
                                expiryInfo,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Analisa AI FruitSense",
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.greenOlive,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // PERBAIKAN: Tambahkan 'child:'
                  Card(
                    elevation: 0,
                    color: AppColors.greenDark.withOpacity(0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome,
                                  color: AppColors.greenDark, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                "Kondisi Fisik",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.greenDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(fruitItem.aiDescription),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // PERBAIKAN: Tambahkan 'child:'
                  Card(
                    elevation: 0,
                    color: Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withOpacity(0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Saran Penyimpanan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(fruitItem.storageAdvice),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(String? uri) {
    if (uri == null || uri.isEmpty) {
      return Container(
        color: AppColors.greenDark.withOpacity(0.2),
        child: const Center(
          child: Icon(Icons.auto_awesome, size: 80, color: AppColors.greenDark),
        ),
      );
    }

    if (uri.startsWith('http')) {
      return Image.network(
        uri,
        fit: BoxFit.cover,
        errorBuilder: (ctx, error, stack) => Container(
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.broken_image)),
        ),
      );
    } else {
      return Image.file(
        File(uri),
        fit: BoxFit.cover,
        errorBuilder: (ctx, error, stack) => Container(
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.broken_image)),
        ),
      );
    }
  }
}