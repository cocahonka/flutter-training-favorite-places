import 'package:flutter/foundation.dart';

@immutable
class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.adress,
  });

  final double latitude;
  final double longitude;
  final String adress;

  @override
  int get hashCode => Object.hash(latitude, longitude, adress);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaceLocation &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        adress == other.adress;
  }
}
