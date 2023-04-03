import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userName, uId, role, phone;

  UserModel({
    this.userName = '',
    this.uId = '',
    this.role = '',
    this.phone = '',
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      uId: snapshot.id,
      userName: data['username'],
      role: data['role'],
      phone: data['phone'],
    );
  }

  @override
  String toString() {
    return 'UserModel{userName: $userName, uId: $uId, role: $role, phone: $phone}';
  }
}
