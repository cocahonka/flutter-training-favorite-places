import 'dart:async';

import 'package:favorite_places/models/place_location.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    PlaceLocation? location,
    super.key,
  })  : location = location ?? _defaultLocation,
        _isSelecting = location == null;

  final PlaceLocation location;
  final bool _isSelecting;

  static const _defaultLocation = PlaceLocation(
    latitude: 59.904225,
    longitude: 29.092264,
    address: 'Сосновый Бор',
  );

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapControllerCompleter = Completer<YandexMapController>();

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    final service = Location();

    final hasPermissions = await _initPermissions(service);
    final PlaceLocation location;

    if (hasPermissions) {
      final locationData = await service.getLocation();
      location = PlaceLocation(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        address: '',
      );
    } else {
      location = MapScreen._defaultLocation;
    }

    await _moveToCurrentLocation(location);
  }

  Future<bool> _initPermissions(Location service) async {
    var serviceEnabled = await service.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await service.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    var permissionGranted = await service.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await service.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  Future<void> _moveToCurrentLocation(PlaceLocation location) async {
    await (await mapControllerCompleter.future).moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: location.latitude,
            longitude: location.longitude,
          ),
          zoom: 12,
        ),
      ),
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._isSelecting ? 'Pick your Location' : 'Your Location'),
      ),
      floatingActionButton: widget._isSelecting
          ? FloatingActionButton(
              child: const Icon(Icons.save),
              onPressed: () {},
            )
          : null,
      body: YandexMap(
        onMapCreated: mapControllerCompleter.complete,
        mapObjects: [
          PlacemarkMapObject(
            mapId: const MapObjectId('Placemark'),
            point: Point(
              latitude: widget.location.latitude,
              longitude: widget.location.longitude,
            ),
            opacity: 1,
            isDraggable: true,
          ),
        ],
      ),
    );
  }
}
