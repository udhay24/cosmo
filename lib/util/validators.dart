class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static final RegExp _phoneNumberRegExp = RegExp(
    r'^[0-9]{10}$'
  );

  static bool isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static bool isValidName(String name) {
    if ((name != null) && (name.isNotEmpty) && (name.length >= 2)) {
      return true;
    } else {
      return false;
    }
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    return _phoneNumberRegExp.hasMatch(phoneNumber);
  }

  static bool isMembersListValid(List<String> members) {
    var isMembersValid = members.map((e) => isValidName(e)).every((
        element) => element);
    return isMembersValid && (members.length >= 1);
  }
}