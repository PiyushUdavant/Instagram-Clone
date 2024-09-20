import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
// import 'package:flutter/rendering.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayout(
  {super.key,
  required this.mobileScreenLayout,
  required this.webScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  
  // @override
  // void initState() {
  //   super.initState();  
  //   addData();
  // }

  //This above mf took my 2-3 days to resolve my issues in the app now finally I was able to resolve all the issues and hence complete my app using chatgpt I added following function to resolve the issue. To understand it thoroughly visit below link: 
  // https://chatgpt.com/c/7db9c43b-84cb-4b55-bb56-dea6e42323ff
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    addData(); // Now call your addData method here
  }

  void addData() async {
    UserProvider userProvider = Provider.of(context);
    await userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      if (Constraints.maxWidth > webScreenSize) {
        return widget.webScreenLayout;
      }
      return widget.mobileScreenLayout;
    });
  }
}
