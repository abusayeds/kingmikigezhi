import 'package:get/get.dart';

/// Safe GetX argument helpers.
/// After visiting screens that pass non-Map args (e.g. EventModel),
/// leftover Get.arguments can crash later screens that do `args['key']`
/// or `args as Map`. Always use these helpers instead.
Map<String, dynamic> routeArgsMap([dynamic raw]) {
  final value = raw ?? Get.arguments;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

T? routeArg<T>(String key, [dynamic raw]) {
  final map = routeArgsMap(raw);
  final value = map[key];
  if (value is T) return value;
  if (T == String && value != null) return value.toString() as T;
  return null;
}

String routeArgString(String key, {String fallback = '', dynamic raw}) {
  final value = routeArgsMap(raw)[key];
  if (value == null) return fallback;
  final text = value.toString().trim();
  return text.isEmpty ? fallback : text;
}
