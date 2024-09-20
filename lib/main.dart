// ignore_for_file: prefer_const_constructors,unused_import 

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
// import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
// import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
// import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb){ // For the web version of the App
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC8-JLDfkuPoK26EalUHosvh0HNWTx-3G4",
        authDomain: "instagram-clone-a8dac.firebaseapp.com",
        projectId: "instagram-clone-a8dac",
        storageBucket: "instagram-clone-a8dac.appspot.com",
        messagingSenderId: "473297065423",
        appId: "1:473297065423:web:58c37f60d293bb03bfaeba"
      )
    );    
  }
  else{ // For the mobile version of the App
    await Firebase.initializeApp();  
  }  
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          // home: const ResponsiveLayout(
          //   mobileScreenLayout: MobileScreenLayout(),
          //   webScreenLayout: WebScreenLayout(),
          // )
          
          // home:LoginScreen(),

          // home: SignupScreen(),
          // home: CommentsScreen(),
          
          home:StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.active){
                if(snapshot.hasData){
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                }
                else if(snapshot.hasError){
                  return Center(
                    child:Text('${snapshot.error}')
                  );
                }
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return LoginScreen();
            },
          )
          ),
    );
  }
}


// In StreamBuilder -> stream there are 3 methods that we can use 
// i) idTokenChnages : So, firebase provides some unique id to each user so whenever user signs out or logs out there some changes occurs in the id and at that time this changes the screen according to that. The drawback of this function is that if we restore our account on some other device without making any change still it chnages the id causing screen getting changed. That is why we are not going to use this function.

// ii) userChanges : This method is same as idTokenChanges but it has additional property that whenever user updats his username or password or anything this method gets called and returns the user on log in screen or sign up screen . But we just want to use change only when there's sign in or sign out hence this method is also not suitable for our project.

// iii) authStateChanges : This method is called only when there's some sign out or sign in hence this method is suitable for our project.

