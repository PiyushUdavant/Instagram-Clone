import 'dart:typed_data';

import'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;

  void postImage(
    String uid,
    String username,
    String profImage
  ) async{
    setState(() {
      _isLoading = true;
    });
    try{
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text, 
        _file!,
        uid,
        username, 
        profImage);
        if(res == 'success'){
          setState(() {
            _isLoading = false;
          });
          showSnackBar('Posted!', context);
          clearImage();
        }
        else{
          setState(() {
           _isLoading = false;
          });
          showSnackBar(res,context);
        }
    }catch(e){
      showSnackBar(e.toString(), context);
    }
  }
  _selectImage(BuildContext context){
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children:[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed:() async{
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.camera,
                );
              setState(() {
                _file = file;
              });
              }
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
              onPressed:() async{
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.gallery,
                );
              setState(() {
                _file = file;
              });
              }
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed:() {
                Navigator.of(context).pop();                
              }
            ),

          ]
        );
      },
    );
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    
    //The below condition is required so that we can access the user.photoUrl in line no. 111 otherwise we will get 'null check operator used on a null value error' it means user is initially null and still you are using null check(!). We have also made changes in user_provider.dart line 10 and commented the old one which we thought is correct . Add this in the notes as it is a very complex error and it is very hard to identify this error.
   
    if(user==null){ 
      return const Center(                         
        child: CircularProgressIndicator(
          color:primaryColor,
        )
      );
    }

    // So, I commented the above condition and added null check (!) after user in line 151 and 174 . This solved my error as the above if condition was just showing the CircularProgressInidcator in my Add Post Screen. If any error occurs in the further part then uncomment this and try to resolve this issue from here only.

    // Hey!!! I already predicted , I got error after selecting the photo now mf try to remove error. Let's see what solution you bring here.
    
    return _file == null? Center(
      child:IconButton(
        icon: const Icon(Icons.upload),
        onPressed: ()  => _selectImage(context),
      )
    )
    
    :
    Scaffold(
      appBar: AppBar(
        backgroundColor : mobileBackgroundColor,
        leading : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: const Text('Post to'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => postImage(user.uid,user.username,user.photoUrl),            
            child: const Text(
              'Post',
              style:TextStyle(
                fontSize : 16,
                fontWeight : FontWeight.bold,
                color: Colors.blueAccent,
              )
            ),
          )
        ]
      ),
      body:Column(
        children: [
          _isLoading ?
          const LinearProgressIndicator() :
          const Padding( padding : EdgeInsets.only(top:0) ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl)
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Write a caption...',
                    border: InputBorder.none,
                  ),
                  maxLines : 8,
                )
              ),
              SizedBox(
                width : 45,
                height : 45,
                child:Container(
                  decoration: BoxDecoration( 
                    color: primaryColor,
                    image: DecorationImage(
                      image: MemoryImage(_file!),
                      fit: BoxFit.fill,
                      alignment: FractionalOffset.topCenter,
                    )
                  )
                )
              ),
              const Divider(),
            ]
          )
        ]
      )
    );
  }
}