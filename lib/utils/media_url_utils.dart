import 'package:event_sharing/utils/api_constants.dart';

/// Resolves backend media fields into a usable absolute network URL.
///
/// Uses the backend URL as-is when it is already absolute (`https://...`).
/// Relative paths are prefixed with [ApiConstants.baseUrl].
class MediaUrlUtils {
  MediaUrlUtils._();

  static String? resolve(dynamic raw) {
    if (raw == null) return null;

    String? value;
    if (raw is String) {
      value = raw.trim();
    } else if (raw is Map) {
      value = (raw['url'] ??
              raw['imageUrl'] ??
              raw['path'] ??
              raw['src'] ??
              raw['location'])
          ?.toString()
          .trim();
    } else {
      value = raw.toString().trim();
    }

    if (value == null || value.isEmpty || value.toLowerCase() == 'null') {
      return null;
    }

    // Data URI / local asset — leave untouched.
    if (value.startsWith('data:') || value.startsWith('assets/')) {
      return value;
    }

    // Absolute URL from backend — use exactly as returned.
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return _usableOrNull(value);
    }

    final base = ApiConstants.baseUrl.endsWith('/')
        ? ApiConstants.baseUrl.substring(0, ApiConstants.baseUrl.length - 1)
        : ApiConstants.baseUrl;

    if (value.startsWith('/')) {
      return _usableOrNull('$base$value');
    }

    return _usableOrNull('$base/$value');
  }

  /// Skip SVG defaults — Flutter [Image.network] cannot decode SVG.
  static String? _usableOrNull(String url) {
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    if (path.endsWith('.svg')) return null;
    return url;
  }

  /// Pulls an image URL from a category / subcategory / media JSON map.
  static String? fromMap(Map<dynamic, dynamic>? json) {
    if (json == null) return null;
    return resolve(
      json['imageUrl'] ??
          json['image'] ??
          json['icon'] ??
          json['thumbnail'] ??
          json['coverImage'] ??
          json['photo'],
    );
  }
}
