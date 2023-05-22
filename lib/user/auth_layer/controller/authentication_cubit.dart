import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:task_management/core/routes/app_router.dart';
import 'package:task_management/core/routes/named_router.dart';
import 'package:task_management/utils/utils_config.dart';

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

      if (userData.exists) {
        final userRole = userData['role'];

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
        UtilsConfig.showSnackBarMessage(
          message: 'User data not found.',
          status: false,
        );
        emit(AuthFailure('User data not found.'));
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

      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // Get the FCM token for the user
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      String? fcmToken = await messaging.getToken();

      // Listen for token refresh events and update the token accordingly
      messaging.onTokenRefresh.listen((newToken) async {
        fcmToken = newToken;
        await updateFCMToken(userId, fcmToken);
      });

      await fireStore.collection('users').doc(userId).set({
        'username': username,
        'phone': phone,
        'role': 'user',
        'profileImageUrl': '',
        'position': '',
        'email': email,
        'fcmToken': fcmToken,
      });

      loggedInUser = userCredential.user!;
      await loggedInUser!.updateDisplayName(username);

      AppRouter.goToAndRemove(
        routeName: NamedRouter.mainScreen,
        arguments: 'user',
      );
      emit(SignUpSuccess(loggedInUser!));
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      print('FirebaseAuthException: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      print('Error during sign-up: $e');
    }
  }

  Future<void> updateFCMToken(String userId, String? fcmToken) async {
    try {
      await fireStore.collection('users').doc(userId).update({
        'fcmToken': fcmToken,
      });
    } catch (e) {
      // Handle Firestore update error
      print('Error updating FCM token: $e');
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
