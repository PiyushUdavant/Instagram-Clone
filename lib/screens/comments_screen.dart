import 'package:cloud_firestore/cloud_firestore.dart';
import'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  // TextEditingController _controller = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    if(user == null){
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .orderBy('datePublished' , descending: true)
         // Added this to show     comments in descending order of datePublished
        .snapshots(),
        builder: (
          context, 
          snapshot
          ) {
          //In the builder of feed screen we passed a big datatype to the snapshot present in builder but if we don't pass it , it will give error in itemCount to resolve that error we can use a cheap trick to user snapshot.data as dynamic but drawback of this trick is that we'll not get any autocomplete feature after that . So, it's your choice both are good ways but yes tricks always have some drawabacks
          
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(child: CircularProgressIndicator());
          // }
          //So the above waiting if condition is making my comment screen flicker so for right now I commented this if it causes any issue in future make sure to uncomment this. The other changes I done is firstly I made my snap as map<string , dynamic> and then I added querysnapshot and that whole datatype to my streambuilder and not to snapshot. If I did not make these changes then it was giving me null operator used on null value error

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }
          return ListView.builder(
            // itemCount: (snapshot.data! as dynamic).docs.length,
            itemCount: (snapshot.data!).docs.length,
            itemBuilder: (context, index) => CommentCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );        
        },
        
        ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight, // Toolbar height of the AppBar
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical : 8,
          ),
          child: Row(
            children:[
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  user.photoUrl,
                )
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16 , right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration:InputDecoration(
                      hintText:'Comment as  ${user.username}',
                      border: InputBorder.none,
                    )
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                    user.uid,                     
                    widget.snap['postId'],       
                    _commentController.text,      
                    user.photoUrl,                
                    user.username,            
                  );
                  setState(() {
                    _commentController.text = '';
                  });
                },
                child: Container(               
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color:blueColor,
                    )
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}

// Calling The PostComment Function from FirestoreMethods : The thing here I understood is it is must to call the parameters in the same order as they are written inside the function otherwise some mistake will be seen inside firebase.Mark my words it's very essential