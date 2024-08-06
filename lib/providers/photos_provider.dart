import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy/models/photo.dart';
import 'package:wisy/providers/auth_provider.dart';
import 'package:wisy/services/auth.dart';

final photosProvider = StreamProvider.autoDispose<List<Photo>>((ref) {
  final storage = ref.watch(firestoreProvider);
  ref.watch(authProvider);
  return storage
      .collection('users')
      .doc(Auth().getID())
      .collection('photos')
      .orderBy('timestamp')
      .withConverter(
          fromFirestore: Photo.fromFirestore,
          toFirestore: (Photo photo, _) => photo.toFirestore())
      .snapshots()
      .map((query) {
    return query.docs.map((doc) => doc.data()).toList();
  });
});

final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final storageProvider = Provider<FirebaseStorage>((ref) =>
    FirebaseStorage.instanceFor(
        bucket: 'gs://flutter-firebase-test-4780e.appspot.com'));
