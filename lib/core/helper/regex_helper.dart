class RegexHelper {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";

  String? checkEmail(String? mail) {
    RegExp regex = RegExp(pattern);
    if (mail == null || mail.isEmpty || !regex.hasMatch(mail)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? checkPassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  String? checkName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? checkPhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Please enter your phone';
    }
    return null;
  }

  String? checkCity(String? city) {
    if (city == null || city == "Choose") {
      return 'Please select your city';
    }
    return null;
  }
}
