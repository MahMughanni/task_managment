class UserModel {
  final String? userName, uId, role, phone;

  UserModel({
    this.userName = '',
    this.uId= '',
    this.role= '',
    this.phone= '',
  });

  @override
  String toString() {
    return 'UserModel{userName: $userName, uId: $uId, role: $role, phone: $phone}';
  }
}
