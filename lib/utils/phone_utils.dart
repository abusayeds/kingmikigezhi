import 'package:country_code_picker/country_code_picker.dart';

/// Helpers for detecting the country from a typed phone number
/// like "+880177..." so the CountryCodePicker flag updates automatically.
class PhoneUtils {
  PhoneUtils._();

  /// Country codes sorted by dial code length (longest first) so that
  /// e.g. "+1684" (American Samoa) matches before "+1" (US/Canada).
  static final List<Map<String, String>> _sortedCodes =
      List<Map<String, String>>.from(codes)
        ..sort((a, b) =>
            (b['dial_code']?.length ?? 0).compareTo(a['dial_code']?.length ?? 0));

  /// Detects the country from typed input like "+880177...".
  ///
  /// Returns a record with the ISO code (e.g. 'BD') and dial code
  /// (e.g. '+880'), or null when the input doesn't start with '+'
  /// or no dial code matches.
  static ({String iso, String dialCode})? detectCountry(String input) {
    final text = input.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (!text.startsWith('+')) return null;

    for (final c in _sortedCodes) {
      final dial = c['dial_code'];
      final iso = c['code'];
      if (dial == null || iso == null) continue;
      if (text.startsWith(dial)) return (iso: iso, dialCode: dial);
    }
    return null;
  }

  /// Strips a known dial code prefix so the local number can be shown
  /// beside [CountryCodePicker].
  static String stripDialCode(String phone, String dialCode) {
    final text = phone.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (dialCode.isEmpty) return text;
    if (text.startsWith(dialCode)) {
      return text.substring(dialCode.length);
    }
    final detected = detectCountry(text);
    if (detected != null && text.startsWith(detected.dialCode)) {
      return text.substring(detected.dialCode.length);
    }
    return text;
  }

  /// Builds E.164-style number from dial code + local digits.
  /// If [localNumber] already starts with '+', it is returned as-is.
  static String formatWithDialCode(String dialCode, String localNumber) {
    final local = localNumber.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (local.isEmpty) return '';
    if (local.startsWith('+')) return local;
    final dial = dialCode.trim().isEmpty ? '' : dialCode.trim();
    final digits = local.startsWith('0') ? local.substring(1) : local;
    return '$dial$digits';
  }
}
