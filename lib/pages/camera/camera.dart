import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wisy/providers/photos_provider.dart';
import 'package:wisy/services/auth.dart';
import 'package:wisy/services/database.dart';

class Camera extends ConsumerStatefulWidget {
  const Camera({super.key});

  @override
  ConsumerState<Camera> createState() => _Camera2State();
}

class _Camera2State extends ConsumerState<Camera> {
  bool _isLoading = false;
  final DatabaseService _databaseService = DatabaseService(uid: Auth().getID());
  late FirebaseStorage _storage;

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<String> getPath() async {
    Directory localPath = await getTemporaryDirectory();
    return '${localPath.path}/${generateFileName()}';
  }

  String generateFileName() {
    const int len = 25;
    Random r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return '${String.fromCharCodes(Iterable.generate(len, (_) => chars.codeUnitAt(r.nextInt(chars.length))))}.jpg';
  }

  void uploadPhoto(MediaCapture mediaCapture) async {
    final storageRef = _storage.ref();
    String path = mediaCapture.filePath;
    File file = File(mediaCapture.filePath);
    String fileName =
        path.substring(path.lastIndexOf('/') + 1, path.lastIndexOf('.') - 1);

    setState(() {
      _isLoading = true;
    });

    final message =
        await _databaseService.uploadPhoto(file, fileName, storageRef);
    if (context.mounted) {
      showSnackBar(context, message);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _storage = ref.read(storageProvider);
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          CameraAwesomeBuilder.awesome(
            saveConfig: SaveConfig.photo(
              pathBuilder: () => getPath(),
            ),
            enablePhysicalButton: true,
            aspectRatio: CameraAspectRatios.ratio_16_9,
            previewFit: CameraPreviewFit.fitWidth,
            onMediaTap: (mediaCapture) => uploadPhoto(mediaCapture),
          ),
          if (_isLoading)
            const Opacity(
              opacity: 0.4,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                  //value: _progress,
                  ),
            ),
        ],
      ),
    );
  }
}
