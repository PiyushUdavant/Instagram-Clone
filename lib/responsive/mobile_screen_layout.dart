import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {

/*  String username = '';

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get();

    setState(() {
      username = (snap.data() as Map<String , dynamic>)['username'];
    });
  }

  Add '$username' in Text of Scaffold. So, basically we are doing all this just to get the username of the user on the screen. Also , if we update the username of the user in firebase then we need to restart the app in order to see the new username . Hence this is not the efficient method for this thing.
  Instead we are going to use State Management for this thing which keeps the track of updated info as well.
*/
  int _page =0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationOnTap(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Center(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
          children: homeScreenItems,
        ),
      ),
      // body: Center(child:Text('This is mobile')) 
      // this is for checking the screens
      // body: Center(child:Text(user.username)), 
      // this is for retrieving the data from firestore database
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon:Icon(
              Icons.home,
              color: _page ==0? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
            icon:Icon(
              Icons.search_sharp,
              color: _page ==1? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
            icon:Icon(
              Icons.add_circle_outline_outlined,
              color: _page ==2? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
            icon:Icon(
              Icons.favorite,
              color: _page ==3? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
            icon:Icon(
              Icons.person,
              color: _page ==4? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor
          ),
        ],
        onTap: navigationOnTap,
      ),
      //Here instead of username we can also call email , uid etc.
    );
  }
}