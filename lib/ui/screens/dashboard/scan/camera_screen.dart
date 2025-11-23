// ignore_for_file: avoid_print

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  // Labeler ML Kit
  late ImageLabeler _imageLabeler;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeLabeler();
  }

  Future<void> _initializeLabeler() async {
    final options = ImageLabelerOptions(confidenceThreshold: 0.7);
    _imageLabeler = ImageLabeler(options: options);
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    // Cari kamera belakang
    final firstCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || _isProcessing) return;

    try {
      setState(() => _isProcessing = true);

      final image = await _controller!.takePicture();

      // Lakukan proses ML (Opsional disini atau di Result)
      // Kita kirim path gambar ke Preview Screen dulu
      if (mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.SCAN_PREVIEW,
          arguments: image.path,
        );
      }
    } catch (e) {
      print("Error taking picture: $e");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.greenDark),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Preview (Full Screen)
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: CameraPreview(_controller!),
          ),

          // 2. Overlay Grid & Dimmer
          _buildGridOverlay(),

          // 3. Top Bar (Back & Flash)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.flash_auto, color: Colors.white),
                      onPressed: () {
                        // Logic Flash
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Bottom Control Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              color: Colors.black54,
              child: Center(
                child: GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Loading Indicator jika sedang proses
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildGridOverlay() {
    return IgnorePointer(
      child: Column(
        children: [
          const Spacer(),
          Divider(color: Colors.white.withValues(alpha: 0.3), thickness: 1),
          const Spacer(),
          Divider(color: Colors.white.withValues(alpha: 0.3), thickness: 1),
          const Spacer(),
        ],
      ),
    );
  }
}
