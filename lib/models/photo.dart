import 'package:cloud_firestore/cloud_firestore.dart';

class Photo {
  final String id;
  final String url;
  final Timestamp timestamp;

  Photo(this.url, this.timestamp, this.id);

  Photo.now(this.url, this.id) : timestamp = Timestamp.now();

  factory Photo.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Photo(
      data?['url'],
      data?['timestamp'],
      snapshot.id,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "url": url,
      "timestamp": timestamp,
    };
  }
}
