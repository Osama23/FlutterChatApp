import 'dart:io';

import 'package:FlutterChatApp/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '.././widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    String email,
    String userName,
    String password,
    File imageFile,
    String imageFormat,
    bool isLogin,
    BuildContext context,
  ) async {
    AuthResult authResult;
    try {
      if (this.mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        //..
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.' + imageFormat);
        await ref.putFile(imageFile).onComplete;
        // this will store a direct link to the image
        final url = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData(
          {
            'username': userName,
            'email': email,
            'image_url': url,
          },
        );
      }
      Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
    } on PlatformException catch (err) {
      if (this.mounted)
        setState(() {
          _isLoading = false;
        });
      var message = 'An error occured , please check your credentials';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (error) {
      if (this.mounted)
        setState(() {
          _isLoading = false;
        });
      print(error);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
