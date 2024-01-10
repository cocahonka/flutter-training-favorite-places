import 'dart:collection';

import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';

class _PlacesModel extends ChangeNotifier {
  final List<Place> _places = [];

  UnmodifiableListView<Place> get places => UnmodifiableListView(_places);

  void addPlace({required String title}) {
    final place = Place(title: title);
    _places.add(place);
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
