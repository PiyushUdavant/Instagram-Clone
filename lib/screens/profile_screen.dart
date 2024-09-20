// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    setState(() {
      isLoading = true;
    });
    try{
      var userSnap = await FirebaseFirestore.instance
      .collection('users')
      .doc(widget.uid)
      .get();

      var postSnap = await FirebaseFirestore.instance
      .collection('posts')
      .where(
        'uid' , 
        isEqualTo: FirebaseAuth.instance.currentUser!.uid
      ).get();

      postLen = postSnap.docs.length;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
      userData = userSnap.data()!;
      setState(() {});
    } catch(e){
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isLoading 
    ? const Center(
      child: CircularProgressIndicator(
        color: primaryColor
        )
      )
    : Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: Text(userData['username']),
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children:[
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(userData['photoUrl']),
                        radius: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize : MainAxisSize.max,
                              mainAxisAlignment : MainAxisAlignment.spaceEvenly,
                              children:[
                                buildStatColumn(
                                  postLen, 
                                  'Posts',
                                ),
                                buildStatColumn(
                                  followers, 
                                  'Followers',
                                ),
                                buildStatColumn(
                                  following, 
                                  'Following',
                                ),
                              ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:[
                                FirebaseAuth.instance.currentUser!.uid == widget.uid ? 
                                FollowButton(
                                  backgroundColor: mobileBackgroundColor, 
                                  borderColor: Colors.grey, 
                                  text: 'Sign Out', 
                                  textColor: primaryColor,
                                  function: () async{
                                    await AuthMethods().signOut();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen()
                                      )
                                    );
                                  }
                                ) 
                                : isFollowing ?
                                FollowButton(
                                  backgroundColor: Colors.white, 
                                  borderColor: Colors.grey, 
                                  text: 'Unfollow', 
                                  textColor: Colors.black,
                                  function: () async{
                                    await FirestoreMethods()
                                    .followUser(
                                      FirebaseAuth.instance.currentUser!.uid, 
                                      userData['uid'],
                                    );
                                    setState(() {
                                      isFollowing = false;
                                      followers--;
                                    });
                                  }
                                ) 
                                : 
                                FollowButton(
                                  backgroundColor: Colors.blue, 
                                  borderColor: Colors.blue, 
                                  text: 'Follow', 
                                  textColor: Colors.white,
                                  function: () async{
                                    await FirestoreMethods()
                                    .followUser(
                                      FirebaseAuth.instance.currentUser!.uid, 
                                      userData['uid'],
                                    );
                                    setState(() {
                                      isFollowing = true;
                                      followers++;
                                    });
                                  }
                                )
                              ]
                            )
                          ],
                        ),
                      ),
                    ]
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top:4),
                    child: Text(
                      userData['username'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(top:1),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      userData['bio'],
                      style:TextStyle(
                        fontSize : 16,
                      ),
                    ),
                  ),
                ]
              ),
            ),
            const Divider(),
            FutureBuilder(
              future: FirebaseFirestore.instance
                .collection('posts')
                .where('uid' , isEqualTo: widget.uid)
                .get(), 
              builder: (context ,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount : 3,
                    crossAxisSpacing : 5,
                    mainAxisSpacing : 1.5,
                    childAspectRatio: 1,
                    ),
                  itemBuilder: (context ,index){
                    DocumentSnapshot snap = snapshot.data!.docs[index];

                    return Container(
                      child: Image(
                        image: NetworkImage(
                          snap['postUrl']
                        ),
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                );
              }
            ),
          ]
        )
      );
  }

  Column buildStatColumn (int num , String label){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment : MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 22 ,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ]
    );
  }
}