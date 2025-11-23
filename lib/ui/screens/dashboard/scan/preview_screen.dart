import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';

class PreviewScreen extends StatefulWidget {
  final String imagePath;

  const PreviewScreen({super.key, required this.imagePath});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _isAnalyzing = false;

  Future<void> _processImage(BuildContext context) async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final InputImage inputImage = InputImage.fromFilePath(widget.imagePath);
      final ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 1);
      final ImageLabeler labeler = ImageLabeler(options: options);
      final List<ImageLabel> labels = await labeler.processImage(inputImage);

      String detectedName = "Tidak Dikenali";
      int confidence = 0;
      String desc = "Objek tidak terdeteksi dengan jelas. Coba foto ulang.";

      if (labels.isNotEmpty) {
        final firstLabel = labels.first;
        detectedName = firstLabel.label;
        confidence = (firstLabel.confidence * 100).toInt();
        
        if (confidence > 80) {
          desc = "Objek terdeteksi sangat jelas. Kondisi tampak baik.";
        } else {
          desc = "Deteksi agak ragu. Pastikan pencahayaan cukup.";
        }
      }

      labeler.close();

      if (mounted) {
        final resultData = {
          'imagePath': widget.imagePath,
          'data': {
            'name': detectedName,
            'grade': confidence > 80 ? 'A' : (confidence > 50 ? 'B' : 'C'),
            'freshness': confidence,
            'desc': desc
          }
        };

        Navigator.pushNamed(
          context, 
          AppRoutes.SCAN_RESULT,
          arguments: resultData
        );
      }

    } catch (e) {
      print("Error ML Kit: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menganalisa: $e"))
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Gambar Full
          Positioned.fill(
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.contain,
            ),
          ),

          // Loading Overlay
          if (_isAnalyzing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.greenDark),
                    SizedBox(height: 16),
                    Text("Sedang Menganalisa...", style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
            ),

          // Bottom Action Bar
          if (!_isAnalyzing)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Apakah foto sudah jelas?",
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Pastikan buah terlihat utuh dan cahaya cukup.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        // Tombol Ulang
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: theme.colorScheme.outline),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                            ),
                            child: Text("Ulang", style: TextStyle(color: theme.colorScheme.onSurface)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Tombol Analisa
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _processImage(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppColors.greenDark,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                            ),
                            child: const Text("Analisa", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}