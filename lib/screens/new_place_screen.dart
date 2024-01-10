import 'package:flutter/material.dart';

class NewPlaceScreen extends StatelessWidget {
  const NewPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new Place',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: const Placeholder(),
    );
  }
}
