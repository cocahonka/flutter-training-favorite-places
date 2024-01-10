import 'dart:io';

import 'package:flutter/foundation.dart';

@immutable
class Place {
  Place({
    required this.title,
    required this.image,
  }) : id = DateTime.now().toIso8601String();

  final String id;
  final String title;
  final File image;

  @override
  int get hashCode => Object.hash(id, title);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Place && id == other.id && title == other.title;
  }
}
