import 'package:flutter/foundation.dart';

@immutable
class Place {
  const Place({required this.id, required this.title});

  final String id;
  final String title;

  @override
  int get hashCode => Object.hash(id, title);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Place && id == other.id && title == other.title;
  }
}
