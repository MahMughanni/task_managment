import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:task_mangment/utils/utils_config.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  AuthenticationCubit() : super(AuthenticationInitial());

  Future<void> logIn(String email, String password) async {
    try {
      emit(LoginInProgress());

      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

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

      UserCredential userCredential = await _firebaseAuth
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
}
