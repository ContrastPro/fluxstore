import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Global classes and methods for signing In/Up Users in app
class User {
  String displayName;
  String email;
  String password;

  User();
}

class AuthNotifier with ChangeNotifier {
  FirebaseUser _user;

  FirebaseUser get user => _user;

  void setUser(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }
}

/// signOut() - method for signing out an authorized User from their account
signOut(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

/// initializeCurrentUser() - method for checking current User authorization Firebase
initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}