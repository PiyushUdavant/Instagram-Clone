import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [

  const FeedScreen(),  //Home Screen where feed of the app is shown
  const SearchScreen(), //Search Screen
  const AddPostScreen(), // Post Screen
  const Center(child: Text('Favourites')), // Favourites/Saved Screen
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid) // Profile changing screen
];