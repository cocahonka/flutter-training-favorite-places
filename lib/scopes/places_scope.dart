import 'dart:collection';
import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/models/place_location.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class _PlacesModel extends ChangeNotifier {
  final List<Place> _places = [];

  UnmodifiableListView<Place> get places => UnmodifiableListView(_places);

  static Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
        );
      },
      version: 1,
    );
    return db;
  }

  Future<void> loadPlaces() async {
    final db = await _getDatabase();

    final data = await db.query('user_places');
    final places = data.map((row) {
      return Place(
        id: row['id']! as String,
        title: row['title']! as String,
        image: File(row['image']! as String),
        location: PlaceLocation(
          latitude: row['lat']! as double,
          longitude: row['lng']! as double,
          address: row['address']! as String,
        ),
      );
    }).toList();

    _places.addAll(places);
    notifyListeners();
  }

  Future<void> addPlace({
    required String title,
    required File image,
    required PlaceLocation location,
  }) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);

    final copiedImage = await image.copy('${appDir.path}/$filename');

    final place = Place(
      title: title,
      image: copiedImage,
      location: location,
    );

    final db = await _getDatabase();

    await db.insert('user_places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'lat': place.location.latitude,
      'lng': place.location.longitude,
      'address': place.location.address,
    });

    _places.insert(0, place);
    notifyListeners();
  }
}

@immutable
class _PlacesInherited extends InheritedNotifier {
  const _PlacesInherited({
    required this.model,
    required super.child,
  }) : super(notifier: model);

  final _PlacesModel model;
}

class PlacesScope extends StatefulWidget {
  const PlacesScope({
    required this.child,
    super.key,
  });

  final Widget child;

  static _PlacesModel of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<_PlacesInherited>()!.model;
    }
    return context.getInheritedWidgetOfExactType<_PlacesInherited>()!.model;
  }

  @override
  State<PlacesScope> createState() => _PlacesScopeState();
}

class _PlacesScopeState extends State<PlacesScope> {
  final _model = _PlacesModel();

  @override
  Widget build(BuildContext context) {
    return _PlacesInherited(
      model: _model,
      child: widget.child,
    );
  }
}
