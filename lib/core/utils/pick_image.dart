import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final picker = ImagePicker();

    final xFile = await picker.pickImage(source: ImageSource.camera);

    if (xFile != null) {
      return File(xFile.path);
    } else {
      return null;
    }
  } catch (error) {
    return null;
  }
}
