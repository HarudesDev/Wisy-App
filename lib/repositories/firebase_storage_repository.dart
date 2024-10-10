import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseStorageRepository {
  final FirebaseStorage storage;

  FirebaseStorageRepository(this.storage);

  Future<UploadTask> uploadPhotoToStorage(
      String uid, String fileName, File file) async {
    final uploadTask = storage.ref().child('$uid/$fileName.jpg').putFile(file);

    return uploadTask;
  }
}

final firebaseStorageRepository = Provider<FirebaseStorageRepository>(
    (ref) => FirebaseStorageRepository(ref.read(storageProvider)));

final storageProvider =
    Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);
