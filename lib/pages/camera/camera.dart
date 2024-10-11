import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wisy/models/photo.dart';
import 'package:wisy/repositories/firebase_firestore_repository.dart';
import 'package:wisy/repositories/firebase_storage_repository.dart';
import 'package:wisy/repositories/firebase_auth_repository.dart';
import 'package:wisy/shared/globals.dart';

part 'camera.g.dart';

class Camera extends ConsumerStatefulWidget {
  const Camera({super.key});

  @override
  ConsumerState<Camera> createState() => _Camera2State();
}

class _Camera2State extends ConsumerState<Camera> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      cameraControllerProvider,
      (_, state) => state.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
        data: (data) {
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
              pathBuilder: () =>
                  ref.read(cameraControllerProvider.notifier).getPath(),
            ),
            enablePhysicalButton: true,
            aspectRatio: CameraAspectRatios.ratio_16_9,
            previewFit: CameraPreviewFit.fitWidth,
            onMediaTap: (mediaCapture) => ref
                .read(cameraControllerProvider.notifier)
                .uploadPhoto(mediaCapture),
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

@Riverpod(keepAlive: true)
class CameraController extends _$CameraController {
  @override
  FutureOr<void> build() {}

  Future<String> getPath() async {
    Directory localPath = await getTemporaryDirectory();
    return '${localPath.path}/${generateFileName()}';
  }

  String generateFileName() {
    const int len = 25;
    final r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return '${String.fromCharCodes(Iterable.generate(len, (_) => chars.codeUnitAt(r.nextInt(chars.length))))}.jpg';
  }

  void uploadPhoto(MediaCapture mediaCapture) async {
    final firebaseStorage = ref.read(firebaseStorageRepository);
    final firebaseFirestore = ref.read(firebaseFirestoreRepository);
    final firebaseAuth = ref.read(firebaseAuthRepositoryProvider);
    final path = mediaCapture.filePath;
    final file = File(mediaCapture.filePath);
    final fileName =
        path.substring(path.lastIndexOf('/') + 1, path.lastIndexOf('.') - 1);
    final uid = firebaseAuth.getID()!; //Pendiente de revisión

    state = const AsyncLoading();

    final uploadTask =
        await firebaseStorage.uploadPhotoToStorage(uid, fileName, file);

    state = await AsyncValue.guard(() => uploadTask.then((upload) async {
          if (upload.state == TaskState.success) {
            final url = await upload.ref.getDownloadURL();
            final photo = Photo.now(url, fileName);
            await firebaseFirestore.uploadPhotoToFirestore(uid, photo);
            const SnackBar snackBar =
                SnackBar(content: Text("Foto subida exitosamente"));
            snackbarKey.currentState?.showSnackBar(snackBar);
          }
        }));
  }
}
