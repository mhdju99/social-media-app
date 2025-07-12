class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Invalid email format';
    }

    return null;
  }

  static String? confirmPasswordValidator(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateuserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (value.length < 3) {
      return 'Username is too short';
    }
    return null;
  }

  static String? validateGeneral(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    return null;
  }
}
