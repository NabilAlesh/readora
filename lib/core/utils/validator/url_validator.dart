
final messages = {
  "en": {
    'field_required': 'This field is required',
    'username_min_length': 'Username must be at least 3 characters',
    'username_max_length': 'Username cannot exceed 20 characters',
    'invalid_url': 'Please enter a valid URL (e.g., https://example.com)',
    'invalid_url_tld':
        'URL must contain a valid domain extension (like .com, .org)',
    'url_missing_protocol': 'URL must start with http:// or https://',
    'url_too_short': 'URL is too short',
    'url_invalid_chars': 'URL contains invalid characters',
    'url_no_spaces': 'URL cannot contain spaces',
  },
};

class UrlValidator {
  static String? validate(String? value, {bool requireProtocol = false}) {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    // Check for spaces
    if (value.contains(' ')) {
      return 'url_no_spaces';
    }

    // Optionally require http/https protocol
    if (requireProtocol &&
        !value.startsWith('http://') &&
        !value.startsWith('https://')) {
      return 'url_missing_protocol';
    }

    // URL pattern check
    const urlPattern = r'^(https?:\/\/)?' // http:// or https://
        r'((([a-z\d]([a-z\d-]*[a-z\d])*)\.)+[a-z]{2,}|' // domain name
        r'((\d{1,3}\.){3}\d{1,3}))' // OR ip (v4) address
        r'(\:\d+)?' // port
        r'(\/[-a-z\d%_.~+]*)*' // path
        r'(\?[;&a-z\d%_.~+=-]*)?' // query string
        r'(\#[-a-z\d_]*)?$'; // fragment

    final regex = RegExp(urlPattern, caseSensitive: false);

    if (!regex.hasMatch(value)) {
      return 'invalid_url';
    }

    // Check for valid TLD
    const tldPattern = r'\.[a-z]{2,}$';
    final tldRegex = RegExp(tldPattern, caseSensitive: false);
    if (!tldRegex.hasMatch(value)) {
      return messages["en"]!['invalid_url_tld'];
    }

    return null;
  }
}
