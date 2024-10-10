import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'photo.freezed.dart';
part 'photo.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();
  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
}

@freezed
class Photo with _$Photo {
  const Photo._();

  const factory Photo({
    required String id,
    required String url,
    @TimestampConverter() required DateTime dateTime,
  }) = _Photo;

  factory Photo.fromJson(Map<String, Object?> json) => _$PhotoFromJson(json);

  factory Photo.fromFirestore(DocumentSnapshot<Map<String, Object?>> snapshot,
          SnapshotOptions? options) =>
      Photo.fromJson(snapshot.data() as Map<String, Object?>);

  factory Photo.now(String url, String id) {
    return Photo(id: id, url: url, dateTime: DateTime.now());
  }
}


/*class Photo {
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
*/