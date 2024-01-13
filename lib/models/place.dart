import 'dart:io';

import 'package:favorite_places/models/place_location.dart';
import 'package:flutter/foundation.dart';

@immutable
class Place {
  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? DateTime.now().toIso8601String();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;

  @override
  int get hashCode => Object.hash(id, title);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Place &&
        id == other.id &&
        title == other.title &&
        image == other.image &&
        location == other.location;
  }
}
