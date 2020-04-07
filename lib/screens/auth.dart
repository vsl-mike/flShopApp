import 'dart:ui';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class AuthScreen extends StatefulWidget {
  final _focusPassword = FocusNode();
  final _focusConfirmPassword = FocusNode();
  final globkey = GlobalKey<FormState>();
  final TextEditingController password = TextEditingController();
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class AuthData {
  String email;
  String password;

  AuthData(this.email, this.password);
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_){
      Provider.of<Auth>(context,listen: false).workWithMemory('Get');
    });
    super.initState();
  }

  @override
  void dispose() {
    widget._focusPassword.dispose();
    widget._focusConfirmPassword.dispose();
    super.dispose();
  }

  AuthData authData = AuthData('', '');
  var isSignUp = false;

  Future<void> saveState() async {
    if (widget.globkey.currentState.validate()) {
      widget.globkey.currentState.save();
      authData = AuthData(authData.email, widget.password.text);
      try {
        if (isSignUp) {
          //sign up
          await Provider.of<Auth>(context, listen: false)
              .authorization(authData.email, authData.password, 'signUp');
        } else {
          await Provider.of<Auth>(context, listen: false).authorization(
              authData.email, authData.password, 'signInWithPassword');
          //log in
        }
      } catch (error) {
        String errorMessage = '';
        switch (error.toString()) {
          case 'EMAIL_EXISTS':
            errorMessage =
                'The email address is already in use by another account!';
            break;
          case 'TOO_MANY_ATTEMPTS_TRY_LATER':
            errorMessage = 'Too many attempts, try later!';
            break;
          case 'EMAIL_NOT_FOUND':
            errorMessage = 'There is no user with this email!';
            break;
          case 'INVALID_PASSWORD':
            errorMessage = 'The password is invalid!';
            break;
          default:
            errorMessage = 'Something went wrong';
        }
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(errorMessage),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Try again!'),
                ),
              ],
            );
          },
        );
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(221, 193, 233, 1),
            Color.fromRGBO(198, 111, 137, 1)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),

              // Container with Label

              Container(
                child: Text(
                  'Fashion Moll',
                  style: TextStyle(
                      fontSize: 40, fontFamily: 'Anton', color: Colors.white),
                ),
                transform: Matrix4.rotationZ(pi * 180 + 176.11)..translate(7.0),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),

              // Container with TextInputForms
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: widget.globkey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'E-mail',
                              ),
                              validator: (value) {
                                if (value.contains('@')) {
                                  return null;
                                } else
                                  return 'Enter valid e-mail address';
                              },
                              onSaved: (value) {
                                authData = AuthData(value, authData.password);
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(widget._focusPassword);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              controller: widget.password,
                              focusNode: widget._focusPassword,
                              textInputAction: isSignUp
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                              onFieldSubmitted: isSignUp
                                  ? (_) {
                                      FocusScope.of(context).requestFocus(
                                          widget._focusConfirmPassword);
                                    }
                                  : (_) => saveState(),
                              validator: (value) {
                                if (value.length < 8)
                                  return 'Password must be at least 8 characters';
                                else
                                  return null;
                              },
                              obscureText: true,
                              decoration:
                                  InputDecoration(labelText: 'Password'),
                            ),
                          ),
                          isSignUp
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: TextFormField(
                                    onFieldSubmitted: (_) => saveState(),
                                    obscureText: true,
                                    focusNode: widget._focusConfirmPassword,
                                    validator: (value) {
                                      if (value != widget.password.text)
                                        return 'Password doesn\'t match';
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Confirm Password'),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),

                    // Container with Buttons

                    Container(
                      padding: EdgeInsets.only(top: 20, bottom: 5),
                      child: isSignUp
                          ? Column(
                              children: <Widget>[
                                RaisedButton(
                                  padding: EdgeInsets.only(left: 35, right: 35),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                  ),
                                  onPressed: () => saveState(),
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  color: Colors.purple,
                                ),
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      isSignUp = false;
                                    });
                                  },
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.purple),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: <Widget>[
                                RaisedButton(
                                  padding: EdgeInsets.only(left: 35, right: 35),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                  ),
                                  onPressed: () => saveState(),
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  color: Colors.purple,
                                ),
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      isSignUp = true;
                                    });
                                  },
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.purple),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
