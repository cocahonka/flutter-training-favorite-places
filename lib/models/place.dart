import 'package:flutter/foundation.dart';

@immutable
class Place {
  const Place({required this.title});

  final String title;

  @override
  int get hashCode => title.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Place && title == other.title;
  }
}
