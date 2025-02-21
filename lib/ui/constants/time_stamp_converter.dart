import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<Timestamp?, dynamic> {
  const TimestampConverter();

  @override
  Timestamp? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) return json;
    if (json is int) return Timestamp.fromMillisecondsSinceEpoch(json);
    return null;
  }

  @override
  dynamic toJson(Timestamp? timestamp) {
    return timestamp?.millisecondsSinceEpoch;
  }
}
