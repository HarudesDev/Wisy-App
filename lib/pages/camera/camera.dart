import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wisy/providers/photos_provider.dart';
import 'package:wisy/services/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera.g.dart';

class Camera extends ConsumerStatefulWidget {
  const Camera({super.key});

  @override
  ConsumerState<Camera> createState() => _Camera2State();
}

class _Camera2State extends ConsumerState<Camera> {

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

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue<void>>(
      cameraControllerProvider,
      (_, state) => state.whenOrNull(
        error: (error, stackTrace) {
          // show snackbar if an error occurred
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
        data:(data) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Foto guardada exitosamente")),
          );
        },
      ),
    );

    final AsyncValue<void> state = ref.watch(cameraControllerProvider);
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
            onMediaTap: (mediaCapture) => ref.read(cameraControllerProvider.notifier).uploadPhoto(mediaCapture),
          ),
          if (state.isLoading)
            const Opacity(
              opacity: 0.4,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (state.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

@riverpod
class CameraController extends _$CameraController{
  @override
  FutureOr<void> build(){

  }

  void uploadPhoto(MediaCapture mediaCapture) async {
    final storageRef = ref.read(storageProvider).ref();
    final databaseService = ref.watch(databaseServiceProvider);
    String path = mediaCapture.filePath;
    File file = File(mediaCapture.filePath);
    String fileName =
        path.substring(path.lastIndexOf('/') + 1, path.lastIndexOf('.') - 1);

    state = const AsyncLoading();

    final uploadTask = storageRef.child('Auth().getID()/$fileName.jpg').putFile(file);
    /*uploadTask.snapshotEvents.listen((event) { 
      setState(() {
        _progress = event.bytesTransferred.toDouble()/event.totalBytes.toDouble();
      });
    });*/
    //final message =
    state = await AsyncValue.guard(() => databaseService.uploadPhoto(uploadTask, fileName, storageRef)); 
    /*if (context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    }*/
  }
}