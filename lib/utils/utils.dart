
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if(file != null){
    // return await File(_file.path);
    
    // we are not going to use the above statement as it is not widely available across the internet. Also the methods that are included in dart:io are not available on Flutter Web as of now.Hence it's better to use readAsBytes.

    return await file.readAsBytes();
  }
  else{
    if (kDebugMode) {
      print('Image not selected');
    }
  }
  
}
showSnackBar(String content , BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    )
  );    
}