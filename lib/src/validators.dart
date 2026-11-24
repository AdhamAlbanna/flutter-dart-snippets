/// Why a value was rejected. Map these to translated messages in the UI layer,
/// so the validation logic itself stays free of any localization framework.
enum ValidationError { required, tooShort, tooLong, invalidEmail, invalidPhone }

final RegExp _emailPattern = RegExp(r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,}$');
final RegExp _phonePattern = RegExp(r'^\+?[0-9]{7,15}$');

/// Returns the first problem with [value], or `null` when it is valid.
///
/// Whitespace is trimmed first. [email] and [phone] enable format checks.
ValidationError? validate(
  String? value, {
  int min = 1,
  int max = 255,
  bool email = false,
  bool phone = false,
}) {
  final text = value?.trim() ?? '';

  if (text.isEmpty) return ValidationError.required;
  if (email && !_emailPattern.hasMatch(text)) {
    return ValidationError.invalidEmail;
  }
  if (phone && !_phonePattern.hasMatch(text)) {
    return ValidationError.invalidPhone;
  }
  if (text.length < min) return ValidationError.tooShort;
  if (text.length > max) return ValidationError.tooLong;
  return null;
}
