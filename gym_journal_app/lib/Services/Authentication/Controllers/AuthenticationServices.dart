import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Models/User.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';

/*
TEST LOGIN DETAILS:
Email: joshtest@gmail.com
Password: AdminPassword123

Email: joshtest2@gmail.com
Password: AdminPassword123!

Email: ashton@gmail.com
Password: AdminPassword123!
*/

class AuthenticationController {

  final auth = FirebaseAuth.instance;
  final _databaseController = DatabaseController();

  Future<Result> RegisterUser(String email, String password, String forename, String surname) async {
    try {
      final newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create new custom user object and place in database - stores values like forname & surname
      UserModel user = UserModel(
        userId: newUser.user!.uid,
        firstName: forename,
        lastName: surname,
        email: email,
        dateCreated: DateTime.now().toIso8601String(),    // ISO string format
        joinDate: DateFormat('d MMMM y').format(DateTime.now()),
      );
      await _databaseController.RegisterNewUser(user);

      return Result(success: true, message: 'User created successfully');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'The account already exists for that email.';
          break;
        default:
          errorMessage = 'An unknown error occurred';
      }
      return Result(success: false, message: errorMessage);
    }
  }

  Future<Result> Login(String email, String password) async {
    // Login logic here
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return Result(success: true, message: 'User logged in successfully', data: user);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        default:
          errorMessage = 'An unknown error occurred';
      }
      return Result(success: false, message: errorMessage);
    }
  }

  Future<void> Logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch(e) {
      print(e);
    }
  }

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }
}