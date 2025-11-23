import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic> resultData;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.resultData,
  });

  @override
  Widget build(BuildContext context) {
    final String fruitName = resultData['name'];
    final String grade = resultData['grade'];
    final int freshness = resultData['freshness'];
    final String desc = resultData['desc'];

    return Scaffold(
      body: Stack(
        children: [
          // 1. Header Image
          SizedBox(
            height: 400,
            width: double.infinity,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          // Overlay gradient
          Container(
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black26, Colors.transparent],
              ),
            ),
          ),
          // Tombol Back (Custom)
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  // Kembali ke Dashboard (Scan Hub)
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    AppRoutes.DASHBOARD, 
                    (route) => false
                  );
                },
              ),
            ),
          ),

          // 2. Bottom Sheet Detail
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.55,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))
                  ]
                ),
                padding: const EdgeInsets.all(24),
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2)
                        ),
                      ),
                    ),

                    // Judul & Grade
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Hasil Deteksi", style: TextStyle(color: Colors.grey)),
                            Text(
                              fruitName,
                              style: const TextStyle(
                                fontSize: 28, 
                                fontWeight: FontWeight.bold,
                                color: AppColors.greenDark
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 60, height: 60,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.greenDark,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            grade,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Freshness Bar
                    const Text("Tingkat Kesegaran", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: freshness / 100,
                              minHeight: 12,
                              backgroundColor: Colors.grey[200],
                              color: AppColors.greenDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "$freshness%",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      desc,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5),
                    ),

                    const SizedBox(height: 40),

                    // Tombol Aksi
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.popUntil(context, ModalRoute.withName(AppRoutes.SCAN_CAMERA));
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: AppColors.greenDark),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                            ),
                            child: const Text("Scan Lagi", style: TextStyle(color: AppColors.greenDark)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Logic simpan ke inventory
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Disimpan ke Inventory"))
                              );
                              Navigator.pushNamedAndRemoveUntil(
                                context, AppRoutes.DASHBOARD, (route) => false
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenDark,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                            ),
                            child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}