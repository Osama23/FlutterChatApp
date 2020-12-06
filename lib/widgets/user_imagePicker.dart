import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage, String imageFormat) imagePickerFn;

  UserImagePicker(
    this.imagePickerFn,
  );

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  String _imageFormat;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 150,
    );
    if (pickedImage == null) {
      return;
    }

    final pickedImageFile = File(pickedImage.path);
    _imageFormat = pickedImageFile.path.split('.').last;
    if (this.mounted) {
      setState(() {
        _pickedImage = pickedImageFile;
      });
    }

    widget.imagePickerFn(pickedImageFile, _imageFormat);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text(
            'Add Image',
          ),
        ),
      ],
    );
  }
}
