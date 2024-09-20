// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key , required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    if(user == null){
      return Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'],
              ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(  //Used for creating row of texts with some properties related to text
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        TextSpan(
                          text: ' ${widget.snap['text']}'
                        )
                      ]
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      // '23/12/2023',
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate(),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      )
                    ),
                  ),
                ]
              )
            ),
          ),
          Column(
            children: [
              IconButton(
                icon : Icon(Icons.favorite_border , size: 20),
                onPressed: () {
                  Icon(Icons.favorite , color: Colors.red);
                } ,
              )
              // Container(
              //   padding: EdgeInsets.all(8),
              //   child: LikeAnimation(
              //     isAnimating: false ,
              //     smallLike: (widget.snap['likes'] != null && widget.snap['likes'].contains(user.uid)),
              //     child: IconButton(
              //       icon: widget.snap['likes'] != null && widget.snap['likes'].contains(user.uid) ?
              //         const Icon(
              //           Icons.favorite,
              //           size:20,
              //           color: Colors.red,
              //         ) :
              //         Icon(
              //           Icons.favorite_border,
              //           size: 20,
              //         ),
              //       onPressed:() async {
              //         await FirestoreMethods().likeComment(
              //           widget.snap['postId'],
              //           widget.snap['commentId'], 
              //           user.uid,
              //         );
              //       }
              //     )
              //     
              //   )
              // ),


              // DefaultTextStyle(
              //   // style:Theme.of(context).textTheme.subtitle2!.copywith(fontWeight: FontWeight.w800)
              //   style:Theme.of(context).textTheme.bodyMedium!.copyWith(
              //     fontWeight : FontWeight.w800,
              //   ),
              //   child: Text(
              //     '${widget.snap['likes'].length} likes'
              //     //style:Theme.of(context).textTheme.bodyText2, 
              //     // This is in the video but not working here find out the reason by yourself.
              //   ),
              // ),
            ],
          )          
        ]
      )
    );
  }
}