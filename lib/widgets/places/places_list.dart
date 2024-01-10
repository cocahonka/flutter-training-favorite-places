import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/scopes/places_scope.dart';
import 'package:favorite_places/screens/place_details_screen.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({super.key});

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  void _openPlaceDetailsScreen(Place place) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) {
          return PlaceDetailsScreen(place: place);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = PlacesScope.of(context).places;
    return places.isEmpty
        ? Center(
            child: Text(
              'No places added yet',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.separated(
              itemCount: places.length,
              itemBuilder: (_, index) {
                final place = places[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundImage: FileImage(place.image),
                  ),
                  title: Text(
                    place.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onTap: () => _openPlaceDetailsScreen(place),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          );
  }
}
