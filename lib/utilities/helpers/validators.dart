String? emailValidationFct(String? inputVal) {
  const pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  final regex = RegExp(pattern);

  if (inputVal!.isEmpty) {
    return "Email can't be empty ";
  } else if (!regex.hasMatch(inputVal)) {
    return "Enter a valid email address";
  }

  return null;
}

String? pwdValidationFct(String? inputVal) {
  const pattern = r'^(?=.*[A-Z])(?=.*?[0-9])(?=.*?[ @#\&*~]).{8,}';

  final regex = RegExp(pattern);

  if (inputVal!.isEmpty) {
    return "Password can't be empty ";
  } else if (!regex.hasMatch(inputVal)) {
    return "The password must be at least 8 characters \n and should contain at least one uppercase, \n one digit,and one special character among (@#\&*~)";
  }

  return null;
}

String? pwdConfirmValidationFct(String? inputVal, String? pwdValue) {
  if (inputVal!.isEmpty) {
    return "Confirm password can't be empty ";
  } else if (inputVal != pwdValue) {
    return "Confirm password should be the same as password";
  }
  return null;
}

// Correction : Ajout du type de retour 'String?' et de 'return null'
String? emptyValidationFct(String? inputVal) {
  if (inputVal!.isEmpty) {
    return "This field can't be empty ";
  }
  return null;
}
