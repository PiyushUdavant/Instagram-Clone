import 'package:cloud_firestore/cloud_firestore.dart';
import'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key , required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async{
    try{ QuerySnapshot snap = await FirebaseFirestore.instance
    .collection('posts')
    .doc(widget.snap['postId'])
    .collection('comments')
    .get();

    commentLen = snap.docs.length;
    } catch(e){
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

      if(user==null){ 
      return const Center(                         
        child: CircularProgressIndicator(
          color:primaryColor,
        )
      );
    }

    return Container( // Container of the Post Card
      decoration: BoxDecoration(
        color:mobileBackgroundColor,
        border: Border.all(
          color:width > webScreenSize ? 
          secondaryColor : mobileBackgroundColor,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical:10,
      ),
      child: Column( // Columns of the parts of the Post card
        children:[
          //First Part of the Post Card(username and dp section)
          Container( 
            padding: const EdgeInsets.symmetric(
              vertical:4,
              horizontal: 16,
            ).copyWith(right:0),
            child:Row(
              children:[
                CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'],
                  ),
                ),
                Expanded(
                  child:Padding(
                    padding:const EdgeInsets.only(
                      left:8,
                    ),
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          widget.snap['username'],
                          style:const TextStyle(fontWeight:FontWeight.bold)
                          )
                      ]
                    )
                  ),
                ),
                IconButton(
                  onPressed:(){
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return Dialog(
                          child:ListView(
                            padding: const EdgeInsets.symmetric(vertical:16),
                            shrinkWrap: true,
                            children:[
                              'Delete',
                              'Report'
                            ].map(
                                (e) => InkWell(
                                  onTap:() async{
                                    await FirestoreMethods().deletePost(widget.snap['postId']);
                                    Navigator.of(context).pop();  
                                  },
                                  child: Container(
                                    padding:const EdgeInsets.symmetric(
                                      vertical:12,
                                      horizontal:16,
                                    ),
                                    child:Text(e),
                                  ),
                                ),
                              ).toList(),
                          )
                        );
                      }
                    );
                  },
                  icon:const Icon(Icons.more_vert)
                )
              ]
            )
          ),
          //Second part of the Post Card(Image Section)
          GestureDetector(
            onDoubleTap: () async{
              await FirestoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height:MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit:BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating? 1:0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 200),
                    onEnd:() {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color:primaryColor,
                      size: 120,
                    ),
                  ),
                )
              ],
            ),
          ),
          //Third part of the Post Card(Like Comments Option)
          Row(
            children:[
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike : true,
                child: IconButton(
                  onPressed: () async{
                    await FirestoreMethods().likePost(
                      widget.snap['postId'],
                      user.uid,
                      widget.snap['likes'],
                    );
                  },
                  icon: widget.snap['likes'].contains(user.uid)?
                  const Icon(
                    Icons.favorite,
                    color: Colors.red
                  ):
                  const Icon(
                    Icons.favorite_border,
                  )
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                     builder: (context) => CommentsScreen(
                      snap: widget.snap,
                     )
                    )
                  );
                },
                icon: const Icon(
                  Icons.comment_outlined,
                  color: primaryColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                  color: primaryColor,
                ),
              ),
              Expanded(
                child:Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                  )
                )
              )
            ]
          ),
          // Fourth Part of the Post Card (Description and No. of Likes and Comments)
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment : CrossAxisAlignment.start,
              children:[
                DefaultTextStyle(
                  // style:Theme.of(context).textTheme.subtitle2!.copywith(fontWeight: FontWeight.w800)
                  style:Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight : FontWeight.w800,
                  ),
                  child: Text(
                    '${widget.snap['likes'].length} likes'
                    //style:Theme.of(context).textTheme.bodyText2, 
                    // This is in the video but not working here find out the reason by yourself.
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top:8),
                  child: RichText(
                    text:TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children:[
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']} ',
                        )
                      ]
                    )
                  )
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8 ),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color:secondaryColor
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8 ),
                  child: Text(
                    DateFormat.yMMMd().format(           
                     widget.snap['datePublished'].toDate(), 
                    ),                            
                    style: const TextStyle(                          
                      fontSize: 16,
                      color:secondaryColor
                    ),
                  )
                ),
              ]
            )
          ),
        ]
      )
    );
  }
}