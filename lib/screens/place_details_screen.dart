import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map_screen.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({
    required this.place,
    super.key,
  });

  final Place place;

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  String get _getStaticMapUrl {
    final (latitude, longitude) = (widget.place.location.latitude, widget.place.location.longitude);
    final url =
        'https://static-maps.yandex.ru/v1?ll=$longitude,$latitude&size=600,300&z=16&pt=$longitude,$latitude,comma&apikey=868c8c70-f093-45c6-bbc2-7f4f6ccb64e5';
    return url;
  }

  void _openMapScreen() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => MapScreen(location: widget.place.location),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.place.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Stack(
        children: [
          Image.file(
            widget.place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _openMapScreen,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(_getStaticMapUrl),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    widget.place.location.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
