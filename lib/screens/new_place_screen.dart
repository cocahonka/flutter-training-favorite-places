import 'dart:io';

import 'package:favorite_places/scopes/places_scope.dart';
import 'package:favorite_places/widgets/native/image_input.dart';
import 'package:favorite_places/widgets/places/place_title_field.dart';
import 'package:flutter/material.dart';

class NewPlaceScreen extends StatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  State<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends State<NewPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _enteredTitle;
  File? _pickedImage;

  void _saveForm() {
    final formState = _formKey.currentState!;
    if (formState.validate() && _pickedImage != null) {
      formState.save();

      PlacesScope.of(context, listen: false).addPlace(
        title: _enteredTitle,
        image: _pickedImage!,
      );
      Navigator.of(context).pop();
      return;
    }

    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please take a photo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add new Place',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Column(
              children: [
                PlaceTitleField(onSaved: (value) => _enteredTitle = value!),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ImageInput(
                    saveImage: (value) => _pickedImage = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton.icon(
                    onPressed: _saveForm,
                    icon: const Icon(Icons.add),
                    label: Text(
                      'Add Place',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
