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
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  User? loggedInUser;
  String? userRole;

  AuthenticationCubit({required this.firebaseAuth}) : super(LoginInitial());

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
          emit(AuthFailure('An error occurred during auto login.'));
        }
      } else {
        emit(AuthFailure('firebaseAuth is null.'));
      }
    } else {
      emit(LoginInitial());
    }
  }

  Future<void> checkLoginStatus() async {
    await autoLogin();
    if (loggedInUser != null) {
      final userData =
          await fireStore.collection('users').doc(loggedInUser!.uid).get();
      userRole = userData['role'];
      if (userRole == 'user' || userRole == 'admin') {
        AppRouter.goToAndRemove(
          routeName: NamedRouter.mainScreen,
          arguments: userRole,
        );
      } else {
        AppRouter.goToAndRemove(routeName: NamedRouter.loginScreen);
      }
    } else {
      AppRouter.goToAndRemove(routeName: NamedRouter.loginScreen);
    }
  }

  String? getUserRole() {
    return userRole;
  }

  Future<void> logIn(String email, String password) async {
    try {
      emit(LoginInProgress());

      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      final userRole = userData['role'];

      if (userRole == 'user') {
        AppRouter.goToAndRemove(
            routeName: NamedRouter.mainScreen,
            arguments: userData['role'].toString());
      } else if (userRole == 'admin') {
        AppRouter.goToAndRemove(
            routeName: NamedRouter.mainScreen,
            arguments: userData['role'].toString());
      } else {
        UtilsConfig.showSnackBarMessage(
            message: 'Unknown user role.', status: false);
      }

      const storage = FlutterSecureStorage();
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'password', value: password);

      UtilsConfig.showSnackBarMessage(message: ' Login Success!', status: true);
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
      debugPrint(e.toString());
      emit(AuthFailure('An unknown error occurred.'));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    try {
      emit(SignUpProgress());

      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await fireStore.collection('users').doc(userId).set({
        'username': username,
        'phone': phone,
        'role': 'user',
        'profileImageUrl': '',
        'position': '',
        'email': email, // add email field to the document
      });

      loggedInUser = userCredential.user!;
      await loggedInUser!.updateDisplayName(username);

      AppRouter.goToAndRemove(
          routeName: NamedRouter.mainScreen, arguments: 'user');
      emit(SignUpSuccess(loggedInUser!));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        UtilsConfig.showSnackBarMessage(
            message: 'email already used', status: false);
        emit(AuthFailure('The email address is already in use.'));
      } else if (e.code == 'phone-number-already-exists') {
        UtilsConfig.showSnackBarMessage(
            message: 'phone already used', status: false);

        emit(AuthFailure('The phone number is already in use.'));
      } else {
        emit(AuthFailure(e.message ?? 'An unknown error occurred.'));
      }
    } catch (e) {
      emit(AuthFailure('An unknown error occurred.'));
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
