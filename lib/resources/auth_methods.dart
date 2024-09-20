// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{

    User currenUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore
    .collection('users').doc(currenUser.uid).get();

    return model.User.fromSnap(snap);
      // followers: (snap.data() as Map<String , dynamic>)['followers']
      // since we need to retreive all the data hence if we use this then we need to write all this for each variable(email,bio) hence we will create function of User in user.dart file to retreive all the data and call it here.
    
  }

  // sign up user
  Future<String> SignUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async{
    String res = 'Some error occurred !!!';
    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.
        isNotEmpty // || file != null
      ){
        // registering the user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        // adding user to our databse

        model.User user = model.User(
          username : username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [] ,
          photoUrl: photoUrl,
        );
          
        

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
          // 'username' : username,
          // 'uid' : cred.user!.uid,
          // 'email' : email,
          // 'bio' : bio,
          // 'followers' : [],
          // 'following' : [],
          // 'photoUrl' : photoUrl,

          // No need to write this as we already wrote it in user.dart file in model and also declared the values in above User function just call it now .
        

        //Another method to do this without using or setting the uid is to use add method instead of set method . In this way you don't have to do anything with uid and it is auto generated. Note that here uid of document will be different from uid that is present in the field as we are not going to set the uid.If you didn't understood this just comment the above set method and uncomment the below add method.

        // await _firestore.collection('users').add({
        //   'username' : username,          
        //   'email' : email,
        //   'uid' : cred.user!.uid,
        //   'bio' : bio,
        //   'followers' : [],
        //   'following' : [],
        // });
        res = 'success';
      }
    }
    // on FirebaseAuthException catch(err){
    //    
    //    //We dont need to write this block as firebase gives us default
    //    //option for the output when we enter invalid email or weak password
    //               
    //   if(err.code == 'invalid-email'){
    //     res = 'The email is badly formatted';
    //   }
    //   else if(err.code == 'weak-password'){
    //     res = 'Password should be at least 6 characters';
    //   }
    // }
    catch(err){
      res = err.toString();
    }
    return res;
  }

  // Log in user

  Future<String> LoginUser({
    required String email,
    required String password,
    
  }) async{
    String res = 'Some error occurred !!!';

    try{
      if (email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      }else{
        res = 'Please enter all the fields';
      }
    }on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        print('User Not Found');
      }
      else if(e.code == 'wrong-password'){
        print('Invalid Password');
      }
    }
    catch(err){
      res = err.toString();
    }
    return res; 
  }

  Future<void> signOut() async{
    await _auth.signOut();
  }

}