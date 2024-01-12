import 'package:flutter/foundation.dart';

@immutable
class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;

  @override
  int get hashCode => Object.hash(latitude, longitude, address);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaceLocation &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        address == other.address;
  }
}
