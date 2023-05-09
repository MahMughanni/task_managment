import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:task_mangment/utils/utils_config.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final FirebaseAuth firebaseAuth ;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  User? loggedInUser;

  AuthenticationCubit(this.firebaseAuth) : super(AuthenticationInitial());

  Future<void> autoLogin() async {
    const storage = FlutterSecureStorage();
    final email = await storage.read(key: 'email');
    final password = await storage.read(key: 'password');

    if (email != null && password != null) {
      try {
        final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        loggedInUser = userCredential.user;

        emit(LoginSuccess(userCredential.user!));
      } catch (e) {
        emit(LoginFailure('An error occurred during auto login.'));
      }
    } else {
      emit(LoginInitial());
    }
  }

  Future<void> logIn(String email, String password) async {
    try {
      emit(LoginInProgress());

      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Save user info to secure storage
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
      String email, String password, String username, String phone) async {
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
      });
      User user = userCredential.user!;
      emit(SignUpSuccess(user));
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
