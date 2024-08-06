import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wisy/models/photo.dart';

class DatabaseService {
  final String? uid;
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
      bucket: 'gs://flutter-firebase-test-4780e.appspot.com');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DatabaseService({required this.uid});

  Future<String> uploadPhoto(
      File file, String fileName, Reference storageRef) async {
    final uploadTask = storageRef.child('$uid/$fileName.jpg').putFile(file);
    String message = "";
    await uploadTask.then((upload) async {
      if (upload.state == TaskState.success) {
        String uploadpath = upload.ref.fullPath;
        String url = await storageRef.child(uploadpath).getDownloadURL();
        final photoDocument = Photo.now(url, fileName);
        try {
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('photos')
              .doc(photoDocument.id)
              .set(photoDocument.toFirestore());
          message = 'Foto guardada';
        } catch (e) {
          storageRef.child(uploadpath).delete();
        }
      } else {
        message = 'Error al subir el archivo';
      }
    });
    return message;
  }

  Future<String> deletePhoto(String photoId) async {
    String response = "";
    final storageRef = _storage.ref().child('$uid/$photoId.jpg');
    await _firestore
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
