
import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String username ;
  final String uid ;
  final String email ;
  final String bio ;
  final String photoUrl ;
  final List followers ;
  final List following ;

  User({
    required this.email,
    required this.username,
    required this .uid,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  Map<String ,dynamic> toJson() => {
    "username" : username ,
    'uid' : uid,
    'email' : email,
    'bio' : bio,
    'followers' : followers,
    'following' : following,
    'photoUrl' : photoUrl,
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      bio: snapshot['bio'],
      email: snapshot['email'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}