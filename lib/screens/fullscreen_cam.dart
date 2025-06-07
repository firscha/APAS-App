import 'package:flutter/material.dart';

class CameraFullScreenPage extends StatelessWidget {
  const CameraFullScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tampilan Fullscreen',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: const Center(
            child: Icon(
              Icons.camera_alt,
              size: 100,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}