import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {  
  const SignupScreen({super.key});  
  
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async{
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image =im;
    });
  }

  void signUpUser() async {  
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().SignUpUser(
      email:_emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      bio : _bioController.text,
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });
    // print(res);
    if(res != 'success'){
    showSnackBar(res,context);
    }
    else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>  const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(), 
            webScreenLayout: WebScreenLayout(),
          )
        )
      );
    }
  }

  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen()
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // body: Text('from login screen'),
      body: SafeArea(
        child: Container(
          padding : const EdgeInsets.symmetric(horizontal : 32),
          width: double.infinity,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Flexible(flex:2, child:Container()),
              //svg image
              // ignore: deprecated_member_use
              SvgPicture.asset('assets/ic_instagram.svg' , color:primaryColor, height:64,),
              const SizedBox(
                height: 64
              ),
              // circular widget to show and accept our selected file
              Stack(
                children:[
                  _image != null?
                  CircleAvatar (
                    radius: 64,
                    backgroundImage:MemoryImage(_image!)
                  ) :
                  const CircleAvatar(
                    radius :64,
                    backgroundImage: CachedNetworkImageProvider('https://t4.ftcdn.net/jpg/05/49/98/39/240_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg',
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    left:80,
                    child:IconButton(
                      color: Colors.white,
                      onPressed: selectImage, 
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ]
              ),
              const SizedBox(
                height:24,
              ),
              // text field input for username
              TextFieldInput(
                hintText: 'Enter your username', 
                textEditingController: _usernameController, 
                textInputType: TextInputType.text
              ),
              const SizedBox(
                height:24,
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
              // text field input for bio
              TextFieldInput(
                hintText: 'Enter your bio', 
                textEditingController: _bioController, 
                textInputType: TextInputType.text
              ),
              const SizedBox(
                height:24,
              ),
              // Login Button
              InkWell(
                onTap:  signUpUser,
                child: Container(
                  // ignore: sort_child_properties_last
                  child:_isLoading?
                  const Center(
                    child:CircularProgressIndicator(
                      color: primaryColor,
                    ),
                    
                  )
                  :
                  const Text('Sign up'),
                  alignment:Alignment.center,                
                  padding:const EdgeInsets.symmetric(vertical:12),
                  // color:blueColor,
                  decoration:const ShapeDecoration(
                    color: blueColor,
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    )
                  ),                  
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
                    onTap: navigateToSignUp,
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