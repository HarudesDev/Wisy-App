import 'package:flutter/material.dart';
import 'package:wisy/pages/camera/camera.dart';
import 'package:wisy/shared/style.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: const Camera(),
    );
  }
}
