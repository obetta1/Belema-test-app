class Validator{
  static String? validatePassword(String? value) {
    final upperCase = RegExp(r".*[A-Z].*");
    final lowerCase = RegExp(r".*[a-z].*");
    final number = RegExp(r".*[0-9].*");
    final specialCharacter = RegExp(r"[`!@#$%^&*()_+\-=\[\]{};':\\|,.<>\/?~]");

    if (value == null || value.isEmpty) {
      return "Please enter password";
    }
    // else if (!upperCase.hasMatch(value)) {
    //   return "Password must contain at least one uppercase character.";
    // }
    else if (value.length < 7) {
      return "Must be greater than 7 characters.";
    } else if (!lowerCase.hasMatch(value)) {
      return "Password must contain at least one lowercase character.";
    } else if (!number.hasMatch(value)) {
      return "Password must contain at least one number.";
    }
    // else if (!specialCharacter.hasMatch(value)) {
    //   return "Password must contain at least one special character.";
    // }
    else {
      return null;
    }
  }
}