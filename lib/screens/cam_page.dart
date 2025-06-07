import 'package:flutter/material.dart';
import 'fullscreen_cam.dart'; // pastikan file ini ada di folder yang sama

class PlantMonitoringPage extends StatelessWidget {
  const PlantMonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'PEMANTAUAN KONDISI TANAMAN',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF9FBF8),
              Color(0xFFC7D9C5),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 32),

            // ✅ Camera Preview Placeholder
            Container(
              margin: const EdgeInsets.all(16),
              height: 250,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Colors.white70,
                ),
              ),
            ),

            // ✅ Tombol Fullscreen
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.fullscreen),
                label: const Text('TAMPILAN FULLSCREEN'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF99B790),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CameraFullScreenPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}