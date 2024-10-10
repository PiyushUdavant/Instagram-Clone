import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
// import 'package:instagram_clone/widgets/grid_view_tiles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        backgroundColor: mobileBackgroundColor,
        title:TextFormField(
          controller: searchController,
          decoration:
            const InputDecoration(
              hintText: 'Search for a user',
            ),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers ? FutureBuilder(
        future: FirebaseFirestore.instance
        .collection('users')
        .where(
          'username',
          isGreaterThanOrEqualTo: searchController.text,
        ).get(),
        builder: (
          context, 
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot
        ) {
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(color:primaryColor),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context , index){
              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      uid: snapshot.data!.docs[index]['uid']
                    )  
                  )
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      snapshot.data!.docs[index]['photoUrl'],
                    ),
                  ),
                  title: Text(
                    snapshot.data!.docs[index]['username'],
                  )
                ),
              );
            },
          );
        },
      ) 
    : FutureBuilder(
      future: FirebaseFirestore.instance.collection('posts').get(), 
      builder: (context , snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator()
          );
        }
        // THIS WAS THE CODE FOR OLDER VERSION OF STAGGERED_GRID_VIEW
        // return StaggeredGridView.countBuilder(
        //   crossAxisCount : 3,
        //   itemCount : snapshot.data!.docs.length,
        //   itemBuilder : (context , index){
        //     Image.network(snapshot.data!.docs[index]['postUrl']);
        //   }
        //   staggeredTileBuilder : (index) => StaggeredTile.count(
        //     (index % 7 == 0) ? 2:1 ,
        //     (index % 7 == 0) ? 2:1,
        //   ),
        //   mainAxisSpacing  : 8,
        //   crossAxisSpacing : 8,
        // );

        return GridView.builder(
          itemCount: snapshot.data!.docs.length,
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            repeatPattern: QuiltedGridRepeatPattern.inverted,
            pattern: [
              const QuiltedGridTile(2, 2),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(1, 2),
            ],
          ),
          itemBuilder: (context ,index){
            return Image.network(
              snapshot.data!.docs[index]['postUrl'],
              fit: BoxFit.cover,
            );
          }
        );
      })
    );
  }
}