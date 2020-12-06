import 'dart:io';

import 'package:FlutterChatApp/widgets/user_imagePicker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final void Function(
      String email,
      String userName,
      String password,
      File userImageFile,
      String imageForma,
      bool isLogin,
      BuildContext context) submitFn;
  final bool isLoading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _userNameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;
  String _userImageFormat;

  @override
  void dispose() {
    super.dispose();
    _userNameFocus.dispose();
    _passwordFocus.dispose();
  }

  void _pickedImage(File image, String imageFormat) {
    _userImageFile = image;
    _userImageFormat = imageFormat;
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState.validate();
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please Pick an Image.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageFile,
        _userImageFormat,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(
          20,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            16.0,
          ),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@'))
                        return 'Please enter a valid email address.!';
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    onEditingComplete: () {
                      if (_isLogin) {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      } else {
                        FocusScope.of(context).requestFocus(_userNameFocus);
                      }
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      key: ValueKey('userName'),
                      focusNode: _userNameFocus,
                      validator: (value) {
                        if (value.isEmpty || value.length < 4)
                          return 'Please enter at least 4 characters.';
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                      onSaved: (value) {
                        _userName = value;
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    focusNode: _passwordFocus,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7)
                        return 'Password must be at least 7 characters long.';
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  widget.isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? 'Login' : 'Sign up'),
                        ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (this.mounted)
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                      },
                      child: Text(_isLogin
                          ? 'Create a new account'
                          : 'I already have an account'),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
