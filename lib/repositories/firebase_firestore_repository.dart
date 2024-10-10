import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy/models/photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreRepository {
  FirebaseFirestore firestore;

  FirebaseFirestoreRepository(this.firestore);

  Future<void> uploadPhotoToFirestore(String uid, Photo photo) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('photos')
        .doc(photo.id)
        .set(photo.toJson());
  }
}

final firebaseFirestoreRepository = Provider<FirebaseFirestoreRepository>(
    (ref) => FirebaseFirestoreRepository(ref.read(firestoreProvider)));

final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
