import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) pickedImage;
  UserImagePicker(this.pickedImage);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _userImage;

  void _openCamera() async {
    final picker = ImagePicker();
    final takenImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _userImage = File(takenImage.path);
    });
    widget.pickedImage(_userImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
          backgroundImage: _userImage != null ? FileImage(_userImage) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _openCamera,
          icon: Icon(Icons.camera_enhance),
          label: Text('Add an Image'),
        ),
      ],
    );
  }
}
