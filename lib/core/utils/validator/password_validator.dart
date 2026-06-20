


const Map<String, Map<String, String>> messages = {
  "ar": {
    "field_required": "هذا الحقل مطلوب.",
    "password_min_length": "كلمة المرور يجب أن تكون 8 محارف على الأقل."
  },
  "en": {
    "field_required": "This field is required.",
    "password_min_length": "Password must be at least 8 characters long."
  }
};

class PasswordValidator {
  static String? validate(String? password) {

    if (password == null || password.isEmpty) {
      return 'field_required';
    }
    if (password.length < 8) {
      return 'password_min_length';
    }
    return null;
  }
}
