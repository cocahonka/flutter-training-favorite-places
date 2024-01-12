// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:favorite_places/models/place_location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

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

    final url = Uri.parse(
      'https://geocode.maps.co/reverse?lat=$latitude&lon=$longitude&api_key=65a15798a52f2454764671zjl340312',
    );
    final response = await http.get(url);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode != 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error getting address')),
        );
      }
      return;
    }

    final body = json.decode(response.body);
    final addressMap = body['address'];
    final address = '${addressMap["county"]} ${addressMap["road"]} ${addressMap['house_number'] ?? ""}';
    _pickedLocation = PlaceLocation(
      latitude: latitude,
      longitude: longitude,
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
              onPressed: _isLoading ? null : () {},
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
