import 'package:flutter/material.dart';
import 'package:wisy/pages/camera/camera.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown,
      ),
      body: const Camera(),
    );
  }
}
