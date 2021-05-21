import 'dart:async';

import 'package:agro_farm/src/models/applicationUser.dart';
import 'package:agro_farm/src/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class AuthBloc {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _user = BehaviorSubject<ApplicationUser>();
  final _errorMessage = BehaviorSubject<String>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final fb = FacebookLogin();
  final googleSignIn = GoogleSignIn(scopes: ['email']);

  // Get Data
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<bool> get isValid =>
      CombineLatestStream.combine2(email, password, (email, password) => true);
  Stream<ApplicationUser> get user => _user.stream;
  Stream<String> get errorMessage => _errorMessage.stream;
  String get userId => _user.value.userId;

  //Set Data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  dispose() {
    _email.close();
    _password.close();
    _user.close();
    _errorMessage.close();
  }

  //Transformers
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (regExpEmail.hasMatch(email.trim())) {
      sink.add(email.trim());
    } else {
      sink.addError('Must Be Valid Email Address');
    }
  });
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8) {
      sink.add(password.trim());
    } else {
      sink.addError('8 Characters Minimum Required');
    }
  });

  //Functions

  signUpEmail() async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());
      var user = ApplicationUser(
          userId: authResult.user.uid, email: _email.value.trim());
      await _firestoreService.addUser(user);
      _user.sink.add(user);
    } on PlatformException catch (error) {
      print(error);
      _errorMessage.sink.add(error.message);
    } on FirebaseAuthException catch (error) {
      print(error);
      _errorMessage.sink.add(error.message);
    } catch (error) {
      _errorMessage.sink.add('Signup Failed');
      print(error.toString());
    }
  }

  loginEmail() async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());
      var user = await _firestoreService.fetchUser(authResult.user.uid);
      _user.sink.add(user);
    } on PlatformException catch (error) {
      print(error);
      _errorMessage.sink.add(error.message);
    } on FirebaseAuthException catch (error) {
      print(error);
      _errorMessage.sink.add(error.message);
    } catch (error) {
      _errorMessage.sink.add('Signin Failed');
      print(error.toString());
    }
  }

  signinFacebook() async {
    //Facebook login
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (res.status) {
      case FacebookLoginStatus.Success:
        try {
          final FacebookAccessToken fbtoken = res.accessToken;
          AuthCredential credential =
              FacebookAuthProvider.credential(fbtoken.token);

          //Sign into firebase
          final result = await _auth.signInWithCredential(credential);

          //Check if user already exists
          var existingUser = await _firestoreService.fetchUser(result.user.uid);
          var user = ApplicationUser(
              email: result.user.email, userId: result.user.uid);

          if (existingUser == null) {
            await _firestoreService.addUser(user);
            _user.sink.add(user);
          } else {
            _user.sink.add(user);
          }
        } on PlatformException catch (error) {
          print(error);
          _errorMessage.sink.add(error.message);
        } on FirebaseAuthException catch (error) {
          print(error);
          _errorMessage.sink.add(error.message);
        } catch (error) {
          _errorMessage.sink.add('Facebook Authorization Failed');
          print(error.toString());
        }

        break;
      case FacebookLoginStatus.Cancel:
        _errorMessage.sink.add('Canceled by user');
        break;
      case FacebookLoginStatus.Error:
        _errorMessage.sink.add('Facebook Authorization Failed');
        print(res.error.toString());
        break;
    }
  }

  signinGoogle() async {
    //Google login
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      //Sign into firebase
      final result = await _auth.signInWithCredential(credential);

      //Check if user already exists
      var existingUser = await _firestoreService.fetchUser(result.user.uid);
      var user =
          ApplicationUser(email: result.user.email, userId: result.user.uid);

      if (existingUser == null) {
        await _firestoreService.addUser(user);
        _user.sink.add(user);
      } else {
        _user.sink.add(user);
      }
    } on PlatformException catch (error) {
      print(error);
      _errorMessage.sink.add(error.message);
    } on FirebaseAuthException catch (error) {
      print(error);
      _errorMessage.sink.add(error.message);
    } catch (error) {
      _errorMessage.sink.add('Google Authorization Failed');
      print(error.toString());
    }
  }

  Future<bool> isLoggedIn() async {
    var firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return false;

    var user = await _firestoreService.fetchUser(firebaseUser.uid);
    if (user == null) return false;

    _user.sink.add(user);
    return true;
  }

  logout() async {
    await _auth.signOut();
    _user.sink.add(null);
  }

  clearErrorMessage() {
    _errorMessage.sink.add('');
  }
}
