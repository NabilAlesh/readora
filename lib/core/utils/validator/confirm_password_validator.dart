


const Map<String, Map<String, String>> messages = {
  "ar": {
    "field_required": "هذا الحقل مطلوب.",
    "password_min_length": "كلمة المرور يجب أن تكون 8 محارف على الأقل.",
    "passwords_do_not_match": "كلمة المرور غير متطابقة."
  },
  "en": {
    "field_required": "This field is required.",
    "password_min_length": "Password must be at least 8 characters long.",
    "passwords_do_not_match": "Passwords do not match."
  }
};

class ConfirmPasswordValidator {
  static String? validate(String? password, String? confirmPassword) {

    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'field_required';
    }
    if (confirmPassword.length < 8) {
      return 'password_min_length';
    }
    if (confirmPassword != password) {
      return 'passwords_do_not_match';
    }
    return null;
  }
}
