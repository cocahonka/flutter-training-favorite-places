import 'package:favorite_places/screens/new_place_screen.dart';
import 'package:favorite_places/widgets/places/places_list.dart';
import 'package:flutter/material.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  void _openNewPlaceScreen() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) {
          return const NewPlaceScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Places',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: _openNewPlaceScreen,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const PlacesList(),
    );
  }
}
