import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy/models/photo.dart';
//import 'package:wisy/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wisy/repositories/firebase_auth_repository.dart';

part 'photos_provider.g.dart';

@riverpod
Stream<List<Photo>> photos(PhotosRef ref){
  final storage = ref.watch(firestoreProvider);
  final authService = ref.watch(firebaseAuthRepositoryProvider);
  //ref.watch(authProvider);
  return storage
      .collection('users')
      .doc(authService.getID())
      .collection('photos')
      .orderBy('timestamp')
      .withConverter(
          fromFirestore: Photo.fromFirestore,
          toFirestore: (Photo photo, _) => photo.toJson())
      .snapshots()
      .map((query) {
    return query.docs.map((doc) => doc.data()).toList();
  });
  
}

final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final storageProvider = Provider<FirebaseStorage>((ref) =>
    FirebaseStorage.instanceFor(
        bucket: 'gs://flutter-firebase-test-4780e.appspot.com'));
