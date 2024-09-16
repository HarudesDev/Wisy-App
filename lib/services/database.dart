import 'package:firebase_storage/firebase_storage.dart';
import 'package:wisy/models/photo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy/providers/photos_provider.dart';
import 'package:wisy/repositories/firebase_auth_repository.dart';

class DatabaseService {
  final Ref ref;

  DatabaseService(this.ref);

  Future<void> uploadPhoto(
      UploadTask uploadTask, String fileName, Reference storageRef) async {
    final firestore = ref.watch(firestoreProvider);
    final uid = ref.watch(firebaseAuthRepositoryProvider).getID();
    await uploadTask.then((upload) async {
      if (upload.state == TaskState.success) {
        String uploadPath = upload.ref.fullPath;
        String url = await storageRef.child(uploadPath).getDownloadURL();
        final photoDocument = Photo.now(url, fileName);
        try {
          await firestore
              .collection('users')
              .doc(uid)
              .collection('photos')
              .doc(photoDocument.id)
              .set(photoDocument.toJson());
        } catch (e) {
          storageRef.child(uploadPath).delete();
        }
      }
    });
  }

  Future<String> deletePhoto(String photoId) async {
    String response = "";
    final storage = ref.watch(storageProvider);
    final uid = ref.watch(firebaseAuthRepositoryProvider).getID();
    final storageRef = storage.ref().child('$uid/$photoId.jpg');
    final firestore = ref.watch(firestoreProvider);
    await firestore
        .collection('users')
        .doc(uid)
        .collection('photos')
        .doc(photoId)
        .delete()
        .then((value) async {
      print('Document deleted');
      await storageRef.delete().then((value) {
        print('File deleted');
        response = "Foto borrada";
      }, onError: (e) {
        print("Error deleting the file: $e");
        response = "Error borrando la foto";
      });
    }, onError: (e) {
      print("Errod deleting the document: $e");
      response = "Error borrando la foto";
    });
    return response;
  }
}

final databaseServiceProvider = Provider<DatabaseService>((ref) => DatabaseService(ref));