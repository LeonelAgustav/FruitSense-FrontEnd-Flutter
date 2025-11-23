import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/inventory_models.dart';

class FruitAnalysisScreen extends StatelessWidget {
  final FruitItem fruitItem;

  const FruitAnalysisScreen({super.key, required this.fruitItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Analisa AI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: _buildThumbnail(fruitItem.imageUri),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fruitItem.name,
                        style: AppTextStyles.headlineBold.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Grade ${fruitItem.grade} • ${fruitItem.freshness}% Segar",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSectionTitle("Diagnosa Kondisi"),
            const SizedBox(height: 8),
            // PERBAIKAN: Tambahkan 'child:' dan perbaiki shape
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.greenDark,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        fruitItem.aiDescription,
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionTitle("Saran Penyimpanan"),
            const SizedBox(height: 8),
            // PERBAIKAN: Tambahkan 'child:'
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFFFFB300),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        fruitItem.storageAdvice,
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (fruitItem.recipes.isNotEmpty) ...[
              _buildSectionTitle("Ide Olahan Resep"),
              const SizedBox(height: 8),
              ...fruitItem.recipes.map((recipe) => _buildRecipeCard(recipe)),
            ] else ...[
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Tidak ada rekomendasi resep karena kondisi buah kurang baik.",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.greenDark,
      ),
    );
  }

  Widget _buildThumbnail(String? uri) {
    if (uri == null || uri.isEmpty) {
      return const Center(
        child: Icon(Icons.auto_awesome, color: AppColors.greenDark),
      );
    }
    if (uri.startsWith('http')) {
      return Image.network(uri, fit: BoxFit.cover);
    }
    return Image.file(File(uri), fit: BoxFit.cover);
  }

  Widget _buildRecipeCard(String recipeName) {
    return Card(
      color: AppColors.greenDark,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                recipeName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
