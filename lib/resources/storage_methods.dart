import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future <String> uploadImageToStorage(String childName , Uint8List file , bool isPost) async {
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if(isPost){
      String id = const Uuid().v1();
      ref = ref.child(id);
      //This block is necessary when we are storing the post as profile pic is always even if you change it , it is replaced by the old pic. But posts are going to be multiple and no Post override other post. Hence it is neccessary to create unique id for each post using Uuid so no post override other post.
    }

    UploadTask uploadTask = ref.putData(file); 
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;

  }
}