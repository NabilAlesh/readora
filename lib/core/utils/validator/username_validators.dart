
const Map<String, Map<String, String>> messages = {
  "ar": {
    "field_required": "اسم المستخدم لا يمكن أن يكون فارغًا.",
    "username_min_length": "اسم المستخدم يجب أن يكون 3 أحرف على الأقل.",
    "username_max_length": "اسم المستخدم لا يمكن أن يزيد عن 20 حرفًا."
  },
  "en": {
    "field_required": "company Name cannot be empty.",
    "companyName_min_length":
        "company Name must be at least 3 characters long.",
    "companyName_max_length":
        "company Name cannot be more than 20 characters long."
  }
};

class UsernameValidator {
  static String? validate(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'field_required';
    } else if (value.length < 3) {
      return 'username_min_length';
    } else if (value.length > 20) {
      return 'username_max_length';
    }
    return null;
  }
}
