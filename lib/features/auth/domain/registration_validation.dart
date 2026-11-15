int ageOnDate(DateTime birthDate, DateTime today) {
  var age = today.year - birthDate.year;
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}

String? validateRegistrationEmail(String? value) {
  final email = value?.trim() ?? '';
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
    return 'Adresse e-mail invalide.';
  }
  return null;
}

String? validateRegistrationPhone(String? value) {
  final phone = value?.trim() ?? '';
  if (phone.isEmpty) return 'Champ obligatoire.';
  if (!RegExp(r'^\+?[0-9 ()-]+$').hasMatch(phone) ||
      RegExp(r'\d').allMatches(phone).length < 7) {
    return 'Entrez un numéro valide (au moins 7 chiffres).';
  }
  return null;
}

String normalizePhone(String value) {
  final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
  return digits.startsWith('00') ? digits.substring(2) : digits;
}

String normalizeIdentityNumber(String value) =>
    value.trim().toUpperCase().replaceAll(RegExp(r'[\s-]+'), '');

String? validateRegistrationPassword(String? value) {
  final password = value ?? '';
  if (password.length < 8 ||
      !RegExp(r'[A-Z]').hasMatch(password) ||
      !RegExp(r'[a-z]').hasMatch(password) ||
      !RegExp(r'[0-9]').hasMatch(password) ||
      !RegExp(r'[^A-Za-z0-9\s]').hasMatch(password)) {
    return '8 caractères minimum, avec majuscule, minuscule, chiffre et symbole.';
  }
  return null;
}
