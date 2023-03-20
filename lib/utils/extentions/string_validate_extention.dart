extension StringValidateExtention on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp = RegExp(r"^[A-Za-z]");
    return nameRegExp.hasMatch(this);
  }

  bool isContainSmallLetter(String value) {
    String pattern = r'^(?=.*?[a-z])';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isContainCapitalLetter(String value) {
    String pattern = r'^(?=.*?[A-Z])';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isContainSpecialCharacter(String value) {
    String pattern = r'^(?=.*[!@#\$%\^&\*])';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isContainNumber(String value) {
    String pattern = r"^(?=.*[0-9])";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isValidPassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$\~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool get isValidNumber {
    final phoneRegExp = RegExp(r"^\+?\d{12}$");
    return phoneRegExp.hasMatch(this);
  }
}
