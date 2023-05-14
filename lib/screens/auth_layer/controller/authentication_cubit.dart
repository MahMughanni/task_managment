import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/utils/utils_config.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final FirebaseAuth firebaseAuth;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  User? loggedInUser;

  AuthenticationCubit(this.firebaseAuth) : super(AuthenticationInitial());

  Future<void> autoLogin() async {
    const storage = FlutterSecureStorage();
    final email = await storage.read(key: 'email');
    final password = await storage.read(key: 'password');

    if (email != null && password != null) {
      if (firebaseAuth != null) {
        try {
          final userCredential = await firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          loggedInUser = userCredential.user;

          emit(LoginSuccess(userCredential.user!, isAdmin: false));
        } catch (e) {
          emit(LoginFailure('An error occurred during auto login.'));
        }
      } else {
        emit(LoginFailure('firebaseAuth is null.'));
      }
    } else {
      emit(LoginInitial());
    }
  }

  // Future<void> logIn(String email, String password) async {
  //   try {
  //     emit(LoginInProgress());
  //
  //     final UserCredential userCredential = await firebaseAuth
  //         .signInWithEmailAndPassword(email: email, password: password);
  //     final storage = FlutterSecureStorage();
  //     await storage.write(key: 'email', value: email);
  //     await storage.write(key: 'password', value: password);
  //
  //     final userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user!.uid)
  //         .get();
  //     final userData = userDoc.data() as Map<String, dynamic>;
  //
  //     // Check the user's role
  //     final role = userData['role'];
  //     if (role == 'admin') {
  //       // Redirect to the admin screen
  //       emit(LoginSuccess(userCredential.user!, isAdmin: true));
  //     } else {
  //       // Redirect to the home screen
  //       emit(LoginSuccess(userCredential.user!));
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       UtilsConfig.showSnackBarMessage(
  //           message: 'No user found for that email.', status: false);
  //     } else if (e.code == 'wrong-password') {
  //       UtilsConfig.showSnackBarMessage(
  //           message: 'Wrong password provided for that user.', status: false);
  //     }
  //   } catch (e) {
  //     emit(LoginFailure('An unknown error occurred.'));
  //   }
  // }

  Future<void> logIn(String email, String password) async {
    try {
      emit(LoginInProgress());

      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      final role = userData['role'];

      if (role == 'user') {
        // Navigate to the home screen
        AppRouter.goToAndRemove(routeName: NamedRouter.mainScreen);
      } else if (role == 'admin') {
        // Navigate to the admin screen
        ///TODO Start Work on Admin Screens
        AppRouter.goToAndRemove(routeName: NamedRouter.employeeScreen);
      } else {
        // Unknown role, show an error message
        UtilsConfig.showSnackBarMessage(
            message: 'Unknown user role.', status: false);
        return;
      }

      const storage = FlutterSecureStorage();
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'password', value: password);

      UtilsConfig.showSnackBarMessage(
          message: ' Login Success !', status: true);
      emit(LoginSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        UtilsConfig.showSnackBarMessage(
            message: 'No user found for that email.', status: false);
      } else if (e.code == 'wrong-password') {
        UtilsConfig.showSnackBarMessage(
            message: 'Wrong password provided for that user.', status: false);
      }
    } catch (e) {
      emit(LoginFailure('An unknown error occurred.'));
    }
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String username,
      required String phone}) async {
    try {
      emit(SignUpProgress());

      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;

      await _fireStore.collection('users').doc(userId).set({
        'username': username,
        'phone': phone,
        'role': 'user',
        'profileImageUrl': '',
        'position': '',
        'email': email, // add email field to the document
      });

      User user = userCredential.user!;

      print('success');
      emit(SignUpSuccess(user));
      AppRouter.goToAndRemove(routeName: NamedRouter.mainScreen);
    } on FirebaseAuthException catch (e) {
      emit(SignUpFailure(e.message ?? 'An unknown error occurred.'));
    } catch (e) {
      emit(SignUpFailure('An unknown error occurred.'));
    }
  }

  Future<void> logOut() async {
    await firebaseAuth.signOut();

    // Remove user info from secure storage
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'email');
    await storage.delete(key: 'password');

    emit(LoginInitial());
  }
}
