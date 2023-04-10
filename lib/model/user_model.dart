import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userName,
      uId,
      role,
      phone,
      profileImageUrl,
      position,
      email,
      password;

  UserModel({
    this.userName = '',
    this.uId = '',
    this.role = '',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.profileImageUrl = '',
    this.position = '',
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      uId: snapshot.id,
      userName: data['username'],
      role: data['role'],
      phone: data['phone'],
      email: data['email'],
      password: data['password'],
      profileImageUrl: data['profileImageUrl'],
      position: data['position'],
    );
  }

  @override
  String toString() {
    return 'UserModel{userName: $userName, uId: $uId, role: $role, phone: $phone, profileImageUrl: $profileImageUrl, position: $position, email: $email, password: $password}';
  }
}
