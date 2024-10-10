import'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
// import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {  
  const LoginScreen({super.key});  
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    //  implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().LoginUser(
      email:_emailController.text ,
      password : _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (res == 'success'){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>  const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(), 
            webScreenLayout: WebScreenLayout(),
          )
        )
      );
    }else{
      showSnackBar(res, context);
    }
  }
  
  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen()
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Text('from login screen'),
      body: SafeArea(
        child: Container(
          padding : MediaQuery.of(context).size.width > webScreenSize
          ?EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/3) :const EdgeInsets.symmetric(horizontal : 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Flexible(flex:2, child:Container()),
              //svg image
              SvgPicture.asset('assets/ic_instagram.svg' , color:primaryColor, height:64,),
              const SizedBox(
                height: 64
              ),
              // text field input for email
              TextFieldInput(
                hintText: 'Enter your email', 
                textEditingController: _emailController, 
                textInputType: TextInputType.emailAddress
              ),
              const SizedBox(
                height:24,
              ),
              // text field input for password
              TextFieldInput(
                hintText: 'Enter your password', 
                textEditingController: _passwordController, 
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height:24,
              ),
              // Login Button
              InkWell(
                onTap:loginUser,
                child: Container(
                  alignment:Alignment.center,                
                  padding:const EdgeInsets.symmetric(vertical:12),
                  // color:blueColor,
                  decoration:const ShapeDecoration(
                    color: blueColor,
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    )
                  ),
                  child: _isLoading?
                  const Center(child:CircularProgressIndicator(
                    color:primaryColor,
                  ))
                  :
                  const Text('Log in'),                  
                ),
              ),
              const SizedBox(
                height:12,
              ),
              Flexible(flex:2, child:Container() ),
              // Transitioning to Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(                   
                    padding:const EdgeInsets.symmetric(vertical:8),
                     child:const Text("Don't have an account?"),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(                   
                      padding:const EdgeInsets.symmetric(vertical:8),
                       child:const Text("Sign up." , style:TextStyle(fontWeight:FontWeight.bold)),
                    ),
                  ),
                ]
              )
            ]
          )
        )
      )
    );
  }
}