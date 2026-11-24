import 'package:event_sharing/models/event_model.dart';
import 'package:get/get.dart';

/// In-memory cache so opened posts / lists are not re-fetched with a full loader.
class ContentCache extends GetxService {
  static ContentCache get to => Get.find<ContentCache>();

  final Map<String, EventModel> _events = {};
  final Map<String, DateTime> _fetchedAt = {};

  /// How long a cached event is considered fresh (skip network).
  Duration ttl = const Duration(minutes: 8);

  EventModel? getEvent(String? id) {
    if (id == null || id.isEmpty) return null;
    return _events[id];
  }

  bool isFresh(String? id) {
    if (id == null || id.isEmpty) return false;
    final at = _fetchedAt[id];
    if (at == null || !_events.containsKey(id)) return false;
    return DateTime.now().difference(at) < ttl;
  }

  void putEvent(EventModel? event, {bool isDetail = false}) {
    final id = event?.id;
    if (id == null || id.isEmpty) return;
    final incoming = event!;
    final existing = _events[id];

    // Never let a thin list stub wipe a richer detail payload (e.g. creator).
    if (!isDetail &&
        existing != null &&
        _isRicher(existing, incoming)) {
      return;
    }

    _events[id] = incoming;
    _fetchedAt[id] = DateTime.now();
  }

  bool _isRicher(EventModel existing, EventModel incoming) {
    final existingHasCreator =
        (existing.creator?.id?.isNotEmpty == true) ||
        (existing.creatorId?.isNotEmpty == true);
    final incomingHasCreator =
        (incoming.creator?.id?.isNotEmpty == true) ||
        (incoming.creatorId?.isNotEmpty == true);
    if (existingHasCreator && !incomingHasCreator) return true;
    final existingHasGroups = existing.groups?.isNotEmpty == true;
    final incomingHasGroups = incoming.groups?.isNotEmpty == true;
    if (existingHasGroups && !incomingHasGroups) return true;
    return false;
  }

  /// True when we already have enough ownership metadata to render owner actions.
  bool hasOwnershipInfo(String? id) {
    final e = getEvent(id);
    if (e == null) return false;
    return (e.creator?.id?.isNotEmpty == true) ||
        (e.creatorId?.isNotEmpty == true);
  }

  void putEvents(Iterable<EventModel> events) {
    for (final e in events) {
      putEvent(e);
    }
  }

  void invalidateEvent(String? id) {
    if (id == null || id.isEmpty) return;
    _events.remove(id);
    _fetchedAt.remove(id);
  }

  void invalidateAll() {
    _events.clear();
    _fetchedAt.clear();
  }
}
