class Patterns {
  static final String cprPattern = r'^\d{2}(0[1-9]|1[0-2])\d{5}$';
  static final String phonePattern = r'^(66\d{6}|3[2-9]\d{6})$';
  static final String passwordPattern =
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$';
  static final String specialCharacters =
      '[!@#\$%^&*()_+-=\\[\\]{};:\'",.<>?/\\\\|`~]';
  static final String upperCase = r'^(?=.*[A-Z])';
  static final String lowerCase = r'^(?=.*[a-z])';
  static final String dobPattern =
      r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$';
  static final String emailPattern =
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
}
