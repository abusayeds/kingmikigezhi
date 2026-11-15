/// Builds query maps for GET /events/feed/search and related feed filters.
class FeedSearchQuery {
  static String? normalizeEventType(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final value = raw.trim();
    const allowed = ['Onsite', 'Online', 'Hybrid'];
    for (final type in allowed) {
      if (type.toLowerCase() == value.toLowerCase()) return type;
    }
    return value;
  }

  static String normalizeCategoryGroup(String? displayValue) {
    if (displayValue == null || displayValue.trim().isEmpty) return '';
    switch (displayValue) {
      case '6 Year - 10 Year':
      case '6year-10year':
        return '6year-10year';
      case '11 Year - 16 Year':
      case '11year-16year':
        return '11year-16year';
      case '17 Year+':
      case '17year+':
        return '17year+';
      default:
        return displayValue.toLowerCase().replaceAll(' ', '');
    }
  }

  static Map<String, String> build({
    required int page,
    int limit = 10,
    String? searchTerm,
    String? programId,
    String? type,
    String? location,
    String? categoryGroup,
    double? priceMin,
    double? priceMax,
  }) {
    final params = <String, String>{
      'page': '$page',
      'limit': '$limit',
    };

    final term = searchTerm?.trim();
    if (term != null && term.isNotEmpty) {
      params['searchTerm'] = term;
    }

    final program = programId?.trim();
    if (program != null && program.isNotEmpty) {
      params['programId'] = program;
    }

    final eventType = normalizeEventType(type);
    if (eventType != null) {
      params['type'] = eventType;
    }

    final loc = location?.trim();
    if (loc != null && loc.isNotEmpty) {
      params['location'] = loc;
    }

    final category = normalizeCategoryGroup(categoryGroup);
    if (category.isNotEmpty) {
      params['categoryGroup'] = category;
    }

    if (priceMin != null) {
      params['priceMin'] = priceMin.toString();
    }
    if (priceMax != null) {
      params['priceMax'] = priceMax.toString();
    }

    return params;
  }
}