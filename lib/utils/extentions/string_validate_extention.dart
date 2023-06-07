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
    final phoneRegExp = RegExp(r"^\+?\d{9}$");
    return phoneRegExp.hasMatch(this);
  }
}

class Validator {
  static String? validateEmail(String value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(value)) {
      return '';
    } else {
      return null;
    }
  }

  static String? validateDropDefaultData(value) {
    if (value == null) {
      return 'Please select an item.';
    } else {
      return null;
    }
  }

  static String? validatePassword(String value) {
    Pattern pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(value)) {
      return '';
    } else {
      return null;
    }
  }

  static String? validateName(String value) {
    if (value.length < 3) {
      return '🚩 Note is too short.';
    } else {
      return null;
    }
  }

  static String? validateText(String value) {
    if (value.isEmpty) {
      return '🚩 Text is too short.';
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String value) {
    final RegExp regex = RegExp(r'^[0-9]{9}$');
    if (!regex.hasMatch(value)) {
      return '';
    } else {
      return null;
    }
  }
}
