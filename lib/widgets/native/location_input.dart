// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:favorite_places/models/place_location.dart';
import 'package:favorite_places/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({
    required this.saveLocation,
    super.key,
  });

  final ValueSetter<PlaceLocation> saveLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isLoading = false;

  String get _getStaticMapUrl {
    if (_pickedLocation == null) return '';

    final (latitude, longitude) = (_pickedLocation!.latitude, _pickedLocation!.longitude);
    final url =
        'https://static-maps.yandex.ru/v1?ll=$longitude,$latitude&size=600,300&z=16&pt=$longitude,$latitude,comma&apikey=868c8c70-f093-45c6-bbc2-7f4f6ccb64e5';
    return url;
  }

  Future<void> _getCurrentLocation() async {
    final location = Location();

    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    final locationData = await location.getLocation();
    final latitude = locationData.latitude!;
    final longitude = locationData.longitude!;

    final address = await _getAddress(latitude, longitude);

    setState(() {
      _isLoading = false;
    });

    if (address == null) return;

    _pickedLocation = PlaceLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );

    widget.saveLocation(_pickedLocation!);
  }

  Future<String?> _getAddress(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://geocode.maps.co/reverse?lat=$latitude&lon=$longitude&api_key=65a15798a52f2454764671zjl340312',
    );
    final response = await http.get(url);

    if (response.statusCode != 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error getting address')),
        );
      }
      return null;
    }

    final body = json.decode(response.body);
    final addressMap = body['address'];
    final address = '${addressMap["county"]} ${addressMap["road"]} ${addressMap['house_number'] ?? ""}';

    return address;
  }

  Future<void> _chooseLocationOnMap() async {
    final point = await Navigator.of(context).push<Point?>(
      MaterialPageRoute(builder: (_) => const MapScreen()),
    );

    if (point == null) return;

    setState(() {
      _isLoading = true;
    });

    final address = await _getAddress(point.latitude, point.longitude);

    setState(() {
      _isLoading = false;
    });

    if (address == null) return;

    _pickedLocation = PlaceLocation(
      latitude: point.latitude,
      longitude: point.longitude,
      address: address,
    );

    widget.saveLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator()
              : _pickedLocation != null
                  ? Image.network(
                      _getStaticMapUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Text(
                      _pickedLocation == null ? 'No location chosen' : _pickedLocation!.address,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _isLoading ? null : _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: _isLoading ? null : _chooseLocationOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
