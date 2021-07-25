import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File> getImagePicker({bool isCamra = false}) async {
  File image;
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
      source: isCamra ? ImageSource.camera : ImageSource.gallery);
  if (pickedFile != null) {
    image = File(pickedFile.path);
  } else {
    print('No image selected.');
  }
  return image;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
