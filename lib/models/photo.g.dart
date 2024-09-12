// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhotoImpl _$$PhotoImplFromJson(Map<String, dynamic> json) => _$PhotoImpl(
      id: json['id'] as String,
      url: json['url'] as String,
      dateTime:
          const TimestampConverter().fromJson(json['dateTime'] as Timestamp),
    );

Map<String, dynamic> _$$PhotoImplToJson(_$PhotoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'dateTime': const TimestampConverter().toJson(instance.dateTime),
    };
