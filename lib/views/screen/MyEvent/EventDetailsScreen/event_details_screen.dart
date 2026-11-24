import 'package:event_sharing/controllers/home_controller.dart';
import 'package:event_sharing/helpers/app_feedback.dart';
import 'package:event_sharing/helpers/event_actions.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/models/event_model.dart';
import 'package:event_sharing/services/api_service.dart';
import 'package:event_sharing/services/content_cache.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/app_remote_image.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/pull_to_refresh.dart';
import 'package:event_sharing/views/base/skeletons.dart';
import 'package:event_sharing/views/screen/MyEvent/controller/applied_event_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  EventModel? event;
  bool isLoading = true;
  bool _isApplying = false;
  bool _isVerifying = false;
  String? error;

  /// Edit history (point 8): who edited/verified this event, newest first.
  List<Map<String, dynamic>> _editLogs = [];
  bool _isLoadingEditLogs = false;
  /// Shown under "Created at" — uses last update date (updatedAt).
  String? _lastUpdatedDisplay;

  String? _selectedAge;

  // ── Editable cost estimate ──
  bool _includeCost = true;
  bool _includeLateFee = true;
  /// Round keys currently included in the estimate (`groupId|roundId|index`).
  final Set<String> _includedRoundKeys = {};
  final TextEditingController _totalCostController = TextEditingController();
  bool _isEditingTotal = false;
  bool _manualTotalOverride = false;

  @override
  void initState() {
    super.initState();
    _fetchEventDetails();
    // Warm applied list so Apply / Applied state is accurate.
    _appliedController().fetchAppliedEvents(silent: true).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _totalCostController.dispose();
    super.dispose();
  }

  /// Share this event with people inside the app (connections) or outside it
  /// (any installed app), or just copy the link.
  Future<void> _shareEventLink() async {
    final current = event;
    if (current == null) return;

    final link = buildEventShareLink(current);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.colorEDF2F4,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Share event',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color414141,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  current.eventName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12.sp, color: AppColors.greyColor),
                ),
                SizedBox(height: 16.h),
                _shareOption(
                  icon: Icons.group_outlined,
                  title: 'Share with your connections',
                  subtitle: 'Send an in-app invitation',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    openEventInvitationPage(current);
                  },
                ),
                _shareOption(
                  icon: Icons.ios_share,
                  title: 'Share outside the app',
                  subtitle: 'WhatsApp, Messages, Email and more',
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await shareEventViaChannel(
                      channel: 'system',
                      eventTitle: current.eventName ?? 'Event',
                      eventLink: link,
                    );
                  },
                ),
                _shareOption(
                  icon: Icons.link,
                  title: 'Copy link',
                  subtitle: link.isEmpty ? 'No link available' : link,
                  enabled: link.isNotEmpty,
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await Clipboard.setData(ClipboardData(text: link));
                    Fluttertoast.showToast(msg: 'Event link copied');
                  },
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shareOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.colorEDF2F4,
                ),
                child: Icon(icon, size: 20.sp, color: AppColors.primaryColor),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.color414141,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11.sp, color: AppColors.greyColor),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  size: 20.sp, color: AppColors.greyColor),
            ],
          ),
        ),
      ),
    );
  }

  bool get _isOwner => isEventOwner(event);

  bool get _isVerified => event?.isVerified == true;

  /// Pull the edit history so the page can show who changed what, and build
  /// the contributor avatar row from real editors.
  Future<void> _loadEditHistory() async {
    final eventId = event?.id;
    if (eventId == null || eventId.isEmpty) return;

    if (mounted) setState(() => _isLoadingEditLogs = _editLogs.isEmpty);
    try {
      final api = Get.find<ApiService>();
      final response = await api.get(
        '${ApiConstants.eventEditLogs(eventId)}?page=1&limit=50',
      );
      if (response is Map && response['success'] == true) {
        final data = response['data'];
        final logs = data is List
            ? data
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList()
            : <Map<String, dynamic>>[];
        if (mounted) setState(() => _editLogs = logs);
      }
    } catch (_) {
      // History is supplementary — never block the page on it.
    } finally {
      if (mounted) setState(() => _isLoadingEditLogs = false);
    }
  }

  /// Unique contributors (editors + verifiers) taken from the edit history.
  List<Map<String, dynamic>> get _contributors {
    final seen = <String>{};
    final people = <Map<String, dynamic>>[];
    for (final log in _editLogs) {
      final editor = log['editor'];
      if (editor is! Map) continue;
      final id = editor['id']?.toString() ?? '';
      if (id.isEmpty || seen.contains(id)) continue;
      seen.add(id);
      people.add(Map<String, dynamic>.from(editor));
    }
    return people;
  }

  String _editorName(Map<String, dynamic>? editor) {
    if (editor == null) return 'Someone';
    final first = editor['firstName']?.toString().trim() ?? '';
    final last = editor['lastName']?.toString().trim() ?? '';
    final full = '$first $last'.trim();
    if (full.isNotEmpty) return full;
    final username = editor['username']?.toString().trim() ?? '';
    return username.isNotEmpty ? '@$username' : 'Someone';
  }

  /// Turn raw field names into something a reader understands.
  String _changedFieldsLabel(dynamic changedFields) {
    if (changedFields is! List || changedFields.isEmpty) {
      return 'Updated the event';
    }
    const labels = {
      'programId': 'Program',
      'organizer': 'Organizer',
      'location': 'Location',
      'eventPortal': 'Event portal',
      'registrationPortal': 'Registration portal',
      'description': 'Description',
      'note': 'Note',
      'coverImage': 'Cover photo',
      'schedule': 'Schedule',
      'groups': 'Groups',
      'previousEvents': 'History',
      'repeatConfig': 'Repeat settings',
      'isVerified': 'Verification',
      'isPublished': 'Published',
      'isActive': 'Active',
      'isSharedToCommunity': 'Community sharing',
      'isUserAgreementAccepted': 'User agreement',
    };
    final readable = changedFields
        .map((f) => labels[f.toString()] ?? f.toString())
        .toSet()
        .toList();
    return 'Updated ${readable.join(', ')}';
  }

  Future<void> _verifyEvent() async {
    final current = event;
    if (current == null || _isVerifying) return;

    if (_isVerified) {
      AppFeedback.info('This event is already verified.');
      return;
    }

    setState(() => _isVerifying = true);
    try {
      final updated = await verifyEvent(current);
      if (!mounted) return;
      if (updated != null) {
        setState(() {
          event = updated;
          _lastUpdatedDisplay = _formatDateOnly(updated.updatedAt) ??
              _formatDateOnly(updated.createdAt);
        });
        _refreshHomeFeedsSilently();
        _loadEditHistory();
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  bool get _hasApplied {
    final eventId = event?.id;
    if (eventId == null) return false;
    final me = currentUserId();
    if (me != null &&
        event?.eventApplieds?.any((a) => a.userId == me) == true) {
      return true;
    }
    if (Get.isRegistered<AppliedEventController>()) {
      return Get.find<AppliedEventController>().hasApplied(eventId);
    }
    return false;
  }

  AppliedEventController _appliedController() {
    if (Get.isRegistered<AppliedEventController>()) {
      return Get.find<AppliedEventController>();
    }
    return Get.put(AppliedEventController());
  }

  Future<void> _applyToEvent() async {
    final eventId = event?.id;
    if (eventId == null || eventId.isEmpty) {
      AppFeedback.validation('This event is missing an ID. Please reopen it.');
      return;
    }
    if (_isOwner) {
      AppFeedback.info('You created this event, so Apply is not needed.');
      return;
    }
    if (_hasApplied || _isApplying) return;

    setState(() => _isApplying = true);
    final ok = await _appliedController().applyToEvent(eventId);
    if (!mounted) return;
    setState(() => _isApplying = false);

    if (ok) {
      // Refresh details so applicant avatars / counts update.
      await _fetchEventDetails();
      if (!mounted) return;
      Get.toNamed(AppRoutes.appliedSearchEventListScreen);
    }
  }

  Future<void> _confirmAndDeleteEvent() async {
    if (event == null) return;
    await deleteEventEverywhere(event!, popDetails: true);
  }

  double _parseMoney(dynamic raw) {
    if (raw == null) return 0;
    if (raw is num) return raw.toDouble();
    final cleaned = raw.toString().replaceAll(RegExp(r'[^0-9.\-]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  String _roundKey(Group group, Round round, int roundIndex) {
    final gId = group.id ?? group.name ?? 'g';
    final rId = round.id ?? '${round.roundType}_$roundIndex';
    return '$gId|$rId';
  }

  void _initCostSelection(EventModel e) {
    _includeCost = true;
    final lateFee = _parseMoney(e.schedule?.lateFee);
    _includeLateFee = lateFee > 0 || e.schedule?.hasFinalDeadline == true;
    _includedRoundKeys.clear();
    final groups = e.groups ?? [];
    for (final group in groups) {
      final rounds = group.rounds ?? [];
      for (var i = 0; i < rounds.length; i++) {
        _includedRoundKeys.add(_roundKey(group, rounds[i], i));
      }
    }
    _manualTotalOverride = false;
    _recalculateTotal(updateController: true);
  }

  /// Sum schedule cost/late fee + included round costs for the visible group(s).
  double _calculateEstimatedTotal() {
    if (event == null) return 0;
    double total = 0;

    if (_includeCost) {
      total += _parseMoney(event!.schedule?.cost);
    }
    if (_includeLateFee) {
      total += _parseMoney(event!.schedule?.lateFee);
    }

    final groups = event!.groups ?? [];
    for (final group in groups) {
      // Only count rounds for the selected group (or all if none selected).
      if (_selectedAge != null && _selectedAge != (group.name ?? 'Group')) {
        continue;
      }
      final rounds = group.rounds ?? [];
      for (var i = 0; i < rounds.length; i++) {
        final round = rounds[i];
        final key = _roundKey(group, round, i);
        if (!_includedRoundKeys.contains(key)) continue;
        total += _parseMoney(round.cost);
        // Include round late fee when that round has a final deadline.
        if (round.hasFinalDeadline == true) {
          total += _parseMoney(round.lateFee);
        }
      }
    }
    return total;
  }

  void _recalculateTotal({bool updateController = true}) {
    final total = _calculateEstimatedTotal();
    _manualTotalOverride = false;
    if (updateController) {
      final text = total == total.roundToDouble()
          ? total.toInt().toString()
          : total.toStringAsFixed(2);
      _totalCostController.text = text;
    }
  }

  /// Point 11: real profile images of everyone who updated or verified this
  /// event, read from the edit history.
  Widget _contributorsRow() {
    final people = _contributors;
    final shown = people.take(5).toList();
    final extra = people.length - shown.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          people.isEmpty
              ? 'No one has contributed or verified this event yet'
              : 'Already contributed or verified by (${people.length}) '
                  '${people.length == 1 ? 'user' : 'users'}',
          style: TextStyle(fontSize: 12.sp, color: AppColors.color414141),
        ),
        if (shown.isNotEmpty) ...[
          SizedBox(height: 10.h),
          SizedBox(
            height: 44.h,
            child: Stack(
              children: [
                for (var i = 0; i < shown.length; i++)
                  Positioned(
                    left: i * 28.w,
                    child: Tooltip(
                      message: _editorName(shown[i]),
                      child: _profileAvatar(
                        rawUrl: shown[i]['profilePicture']?.toString(),
                        radius: 20.r,
                      ),
                    ),
                  ),
                if (extra > 0)
                  Positioned(
                    left: shown.length * 28.w,
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: AppColors.colorEDF2F4,
                      child: Text(
                        '+$extra',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.color414141,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// Point 8: transparent record of every change, shown at the bottom of the
  /// event detail page.
  Widget _editHistorySection() {
    if (_isLoadingEditLogs && _editLogs.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: AppColors.colorEDF2F4, thickness: 1),
        SizedBox(height: 12.h),
        Text(
          'Edit history',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.color414141,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Anyone can improve this event. Every change is recorded here.',
          style: TextStyle(fontSize: 11.sp, color: AppColors.greyColor),
        ),
        SizedBox(height: 12.h),
        if (_editLogs.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'No edits yet.',
              style: TextStyle(fontSize: 12.sp, color: AppColors.greyColor),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _editLogs.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final log = _editLogs[index];
              final editor = log['editor'] is Map
                  ? Map<String, dynamic>.from(log['editor'] as Map)
                  : null;
              final when = _formatDateOnly(log['createdAt']) ?? '';
              final version = log['version']?.toString() ?? '';

              return Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.colorEDF2F4,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _profileAvatar(
                      rawUrl: editor?['profilePicture']?.toString(),
                      radius: 16.r,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _editorName(editor),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.color414141,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            _changedFieldsLabel(log['changedFields']),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.color414141,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          when,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.greyColor,
                          ),
                        ),
                        if (version.isNotEmpty)
                          Text(
                            'v$version',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.greyColor,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _editableCheckBox({
    required bool checked,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: checked ? Colors.blueGrey : Colors.transparent,
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.check,
          color: checked ? Colors.white : Colors.transparent,
          size: 10,
        ),
      ),
    );
  }

  String? _formatDateOnly(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) {
      return DateFormat('yyyy-MM-dd').format(value.toUtc());
    }
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;
    final parsed = DateTime.tryParse(raw);
    if (parsed != null) {
      return DateFormat('yyyy-MM-dd').format(parsed.toUtc());
    }
    // Fallback for ISO strings like 2026-06-22T09:28:46.091Z
    if (raw.length >= 10 && RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(raw)) {
      return raw.substring(0, 10);
    }
    return null;
  }

  Future<void> _fetchEventDetails({bool force = false}) async {
    final dynamic args = Get.arguments;
    String? eventId;
    EventModel? argEvent;

    if (args is EventModel) {
      eventId = args.id;
      argEvent = args;
      _lastUpdatedDisplay =
          _formatDateOnly(args.updatedAt) ?? _formatDateOnly(args.createdAt);
    } else if (args is String) {
      eventId = args;
    } else if (args is Map) {
      eventId = args['id']?.toString() ?? args['eventId']?.toString();
      _lastUpdatedDisplay = _formatDateOnly(
            args['updatedAt'] ?? args['updated_at'],
          ) ??
          _formatDateOnly(args['createdAt'] ?? args['created_at']);
    }

    if (eventId == null) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        error = 'No event ID provided';
      });
      return;
    }

    final cache =
        Get.isRegistered<ContentCache>() ? ContentCache.to : null;
    final cached = cache?.getEvent(eventId);

    // Show cached / route argument immediately — stay on the same post.
    final seed = cached ?? argEvent ?? event;
    if (seed != null && !force) {
      if (!mounted) return;
      setState(() {
        event = seed;
        isLoading = false;
        error = null;
        _initCostSelection(seed);
      });
      cache?.putEvent(seed);
      // Only skip network when cache is fresh AND we already know the creator
      // (otherwise Edit/Delete stay hidden because ownership can't be resolved).
      final ownershipReady = (seed.creator?.id?.isNotEmpty == true) ||
          (seed.creatorId?.isNotEmpty == true);
      if (cache != null &&
          cache.isFresh(eventId) &&
          cached != null &&
          ownershipReady) {
        _loadEditHistory();
        return;
      }
      // Soft refresh in background (no skeleton).
      await _loadEventFromApi(eventId, showLoader: false);
      _loadEditHistory();
      return;
    }

    await _loadEventFromApi(eventId, showLoader: event == null);
    _loadEditHistory();
  }

  Future<void> _loadEventFromApi(
    String eventId, {
    required bool showLoader,
  }) async {
    if (showLoader && mounted) {
      setState(() {
        isLoading = true;
        error = null;
      });
    }

    try {
      final apiService = Get.find<ApiService>();
      final response = await apiService.get(
        ApiConstants.getEventsDetails.replaceAll(':eventId', eventId),
      );
      if (!mounted) return;

      if (response['success'] == true) {
        final rawData = response['data'];
        final Map<String, dynamic> data = rawData is Map<String, dynamic>
            ? rawData
            : Map<String, dynamic>.from(rawData as Map);

        final parsedEvent = EventModel.fromJson(data);
        final updatedFromApi = _formatDateOnly(
          parsedEvent.updatedAt ??
              data['updatedAt'] ??
              data['updated_at'] ??
              parsedEvent.createdAt ??
              data['createdAt'] ??
              data['created_at'],
        );

        if (Get.isRegistered<ContentCache>()) {
          ContentCache.to.putEvent(parsedEvent, isDetail: true);
        }

        setState(() {
          event = parsedEvent;
          _lastUpdatedDisplay = updatedFromApi ??
              _formatDateOnly(parsedEvent.updatedAt) ??
              _formatDateOnly(parsedEvent.createdAt) ??
              _lastUpdatedDisplay;
          isLoading = false;
          error = null;
          _initCostSelection(parsedEvent);
        });
      } else if (event == null) {
        setState(() {
          error = response['message']?.toString() ??
              'Could not load this event. It may have been removed.';
          isLoading = false;
        });
      } else if (mounted) {
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      if (event != null) {
        setState(() => isLoading = false);
        return;
      }
      final raw = e.toString().toLowerCase();
      final friendly = raw.contains('not found')
          ? 'This event is no longer available. It may have been deleted.'
          : 'Could not load this event right now. Please try again.';
      setState(() {
        error = friendly;
        isLoading = false;
      });
    }
  }

  Future<void> _openEditAndVerify() async {
    final result = await Get.toNamed(
      AppRoutes.createEventOne,
      arguments: event,
    );
    if (!mounted) return;
    if (result is EventModel) {
      setState(() {
        event = result;
        _lastUpdatedDisplay = _formatDateOnly(result.updatedAt) ??
            _formatDateOnly(result.createdAt);
        _initCostSelection(result);
      });
      if (Get.isRegistered<ContentCache>()) {
        ContentCache.to.putEvent(result);
      }
      AppFeedback.success('Event updated successfully.');
      _refreshHomeFeedsSilently();
    } else if (result == true) {
      AppFeedback.success('Event updated successfully.');
      await _fetchEventDetails(force: true);
      _refreshHomeFeedsSilently();
    } else {
      _fetchEventDetails();
    }
  }

  void _refreshHomeFeedsSilently() {
    if (!Get.isRegistered<HomeController>()) return;
    final home = Get.find<HomeController>();
    home.fetchTodayEvents();
    home.fetchUpcomingEvents();
    home.fetchHistoryEvents();
    home.fetchCreatedEvents();
  }

  Widget _profileAvatar({
    required String? rawUrl,
    required double radius,
  }) {
    final size = radius * 2;
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: Colors.grey[200],
        child: AppRemoteImage(
          url: rawUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: Image.asset(
            AppImages.logo,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('d-M-yyyy').format(date);
  }

  String _formatTime(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && event == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Event Details',
              style: GoogleFonts.poppins(
                  fontSize: 18.sp, fontWeight: FontWeight.w500)),
          centerTitle: true,
        ),
        body: const EventDetailsSkeleton(),
      );
    }

    if (error != null && event == null) {
      return Scaffold(body: Center(child: Text(error!, style: const TextStyle(color: Colors.red))));
    }

    if (event == null) {
      return const Scaffold(body: Center(child: Text('Event not found')));
    }

    final schedule = event!.schedule;
    final program = event!.program;
    final creator = event!.creator;

    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        title: Text('Event Details',
            style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor)),
        centerTitle: true,
      ),
      //=======================> Body Section <============================
      body: PullToRefresh(
        onRefresh: () => _fetchEventDetails(force: true),
        child: SingleChildScrollView(
        physics: PullToRefresh.alwaysScrollable(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //=======================> Event Image Section <============================
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: AppRemoteImage(
                      url: event!.coverImage,
                      height: 180.h,
                      width: 345.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(event!.eventName ?? 'Unknown Event',
                      style: AppStyles.headTitle().copyWith(
                        fontSize: 15.sp,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        decorationThickness: 1.0,
                      )),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Shared community platform: any signed-in user may edit
                      // any event. Only the creator can delete it.
                      Tooltip(
                        message: 'Edit event',
                        child: Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.colorEDF2F4,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: _openEditAndVerify,
                              child: Center(
                                  child: SvgPicture.asset(AppIcons.editIcon)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // Verify: any signed-in user can confirm the event is
                      // still active and its details are accurate.
                      Tooltip(
                        message: _isVerified
                            ? 'Already verified'
                            : 'Verify this event',
                        child: Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isVerified
                                ? AppColors.primaryColor
                                : AppColors.colorEDF2F4,
                          ),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: _isVerifying ? null : _verifyEvent,
                            child: Center(
                              child: _isVerifying
                                  ? SizedBox(
                                      width: 16.w,
                                      height: 16.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  : Icon(
                                      Icons.done,
                                      size: 18.sp,
                                      color: _isVerified
                                          ? Colors.white
                                          : AppColors.primaryColor,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.colorEDF2F4,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: _shareEventLink,
                          child: SvgPicture.asset(AppIcons.share)),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),
                            _buildInfoRow('Program', program?.name ?? 'N/A'),
                            SizedBox(height: 17.h),
                            _buildInfoRow('Type', schedule?.eventType ?? 'N/A'),
                            SizedBox(height: 17.h),
                            _buildInfoRow('Location', event!.location ?? 'N/A'),
                            SizedBox(height: 18.h),
                            _buildInfoRowWithDateTime(
                                'Deadline',
                                _formatDate(schedule?.deadline),
                                _formatTime(schedule?.deadline)),
                            SizedBox(height: 18.h),
                            _buildInfoRow('Final Deadline', _formatDate(schedule?.finalDeadline)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),
                            _buildInfoRow('Competition Level', schedule?.competitionLevel ?? 'N/A'),
                            SizedBox(height: 17.h),
                            _buildInfoRowWithDateTime(
                                'Registration Open',
                                _formatDate(schedule?.registrationDate),
                                _formatTime(schedule?.registrationDate)),
                            SizedBox(height: 17.h),
                            _buildInfoRow('Repeat Function', event!.repeatConfig?.frequency ?? 'Never'),
                            SizedBox(height: 18.h),
                            _buildInfoRowWithCheck(
                              'Cost',
                              '\$${schedule?.cost ?? '0'}',
                              checked: _includeCost,
                              onChanged: () {
                                setState(() {
                                  _includeCost = !_includeCost;
                                  _recalculateTotal();
                                });
                              },
                            ),
                            SizedBox(height: 18.h),
                            _buildInfoRowWithCheck(
                              'Late Fee',
                              '\$${schedule?.lateFee ?? '0'}',
                              checked: _includeLateFee,
                              onChanged: () {
                                setState(() {
                                  _includeLateFee = !_includeLateFee;
                                  _recalculateTotal();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 24.h),
              Text(AppStrings.description,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Text(
                event!.description ?? 'No description available',
                maxLines: 20,
                textAlign: TextAlign.start,
                style: AppStyles.fieldContent(color: AppColors.color414141),
              ),
              SizedBox(height: 16.h),
              Text(AppStrings.note,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Text(
                event!.note ?? 'No note available',
                maxLines: 20,
                textAlign: TextAlign.start,
                style: AppStyles.fieldContent(color: AppColors.color414141),
              ),
              SizedBox(height: 20.h),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.buttonColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.buttonColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.buttonColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    isExpanded: true,
                    value: _selectedAge,
                    style: AppStyles.fontSize18(
                        color: AppColors.blackColor, fontWeight: FontWeight.w500),
                    hint: CustomText(text: 'Select Ages', fontsize: 13.sp),
                    icon: SvgPicture.asset(
                      AppIcons.downArrowIcon,
                      width: 16.w,
                      color: AppColors.blackColor,
                    ),
                    items: (event?.groups?.map((g) => g.name ?? 'Group').toList() ?? [])
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedAge = newValue;
                        _recalculateTotal();
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              if (event?.groups != null)
                ...event!.groups!
                    .where((group) =>
                        _selectedAge == null ||
                        _selectedAge == (group.name ?? 'Group'))
                    .map((group) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.displayValue.isEmpty
                              ? (group.name ?? 'Group')
                              : '${group.name ?? 'Group'} (Value: ${group.displayValue})',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        if (group.rounds != null)
                          ...group.rounds!.asMap().entries.map((entry) {
                            final roundIndex = entry.key;
                            final round = entry.value;
                            final key = _roundKey(group, round, roundIndex);
                            final isIncluded =
                                _includedRoundKeys.contains(key);
                            return Padding(
                              padding: EdgeInsets.only(bottom: 14.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppIcons.myEventIcon,
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          round.roundType ?? 'Round',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      _editableCheckBox(
                                        checked: isIncluded,
                                        onTap: () {
                                          setState(() {
                                            if (isIncluded) {
                                              _includedRoundKeys.remove(key);
                                            } else {
                                              _includedRoundKeys.add(key);
                                            }
                                            _recalculateTotal();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      AppIcons.dotIconForFamily),
                                                  SizedBox(width: 5.w),
                                                  Flexible(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: 'Deadline: ',
                                                            style: AppStyles
                                                                .fontSize12(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: _formatDate(
                                                                round.deadline),
                                                            style: AppStyles
                                                                .fontSize12(),
                                                          ),
                                                        ],
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                    AppIcons.dotIconForFamily),
                                                SizedBox(width: 5.w),
                                                Text(
                                                  'Cost: \$${round.cost ?? '0'}',
                                                  style: AppStyles.fontSize12(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                                AppIcons.dotIconForFamily),
                                            SizedBox(width: 5.w),
                                            Expanded(
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Description: ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: round.description ??
                                                          'N/A',
                                                      style: AppStyles
                                                          .fontSize12(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  );
                }),
              SizedBox(height: 8.h),
              // ── Previous Events / History ──────────────────────────
              if (event!.previousEvents != null &&
                  event!.previousEvents!.isNotEmpty) ...[
                const Divider(thickness: 1, color: Color(0xFFD0D5D8)),
                SizedBox(height: 12.h),
                Text(
                  'History',
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8.h),
                ...event!.previousEvents!.map((prev) {
                  final yearStr =
                      prev.date != null ? prev.date!.year.toString() : '';
                  final record = prev.recordName ?? '';
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        SvgPicture.asset(AppIcons.dotIconForFamily),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            yearStr.isNotEmpty
                                ? '$yearStr - $record'
                                : record,
                            style: AppStyles.fieldContent(
                                color: AppColors.color414141),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 12.h),
              ],
              const Divider(thickness: 1, color: Color(0xFFD0D5D8)),
              SizedBox(height: 16.h),
              Text(
                'Estimation Total Cost',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.fillColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: _isEditingTotal
                        ? AppColors.buttonColor
                        : AppColors.colorC8D7DE.withValues(alpha: 0.6),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '\$',
                      style: AppStyles.fontSize14(
                        color: AppColors.color414141,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: TextField(
                        controller: _totalCostController,
                        enabled: _isEditingTotal,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: AppStyles.fontSize14(
                          color: AppColors.color414141,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (_) {
                          _manualTotalOverride = true;
                        },
                        onSubmitted: (_) {
                          setState(() => _isEditingTotal = false);
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isEditingTotal = !_isEditingTotal;
                          if (!_isEditingTotal) {
                            _manualTotalOverride = true;
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: SvgPicture.asset(
                          AppIcons.editIcon,
                          height: 14.w,
                          width: 14.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Created By',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.color414141,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  _profileAvatar(
                    rawUrl: creator?.profilePicture,
                    radius: 22.r,
                  ),
                  const Spacer(),
                  Text(
                    'Updated\n${_lastUpdatedDisplay ?? 'N/A'}',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.color414141,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _contributorsRow(),
              SizedBox(height: 8.h),
              Text(
                'Latest active ${_formatDate(event!.updatedAt)}',
                style: TextStyle(
                    fontSize: 12.sp, color: AppColors.color414141),
              ),
              SizedBox(height: 24.h),
              // Any signed-in user may edit and verify this event.
              CustomButton(
                borderColor: AppColors.buttonColor,
                onTap: _openEditAndVerify,
                text: "Edit & Verify",
                color: AppColors.fillColor,
                textColor: Colors.black,
              ),
              SizedBox(height: 12.h),
              if (!_isOwner) ...[
                CustomButton(
                  onTap: _applyToEvent,
                  loading: _isApplying,
                  enabled: !_hasApplied,
                  text: _hasApplied ? "Applied" : "Apply",
                  textColor: Colors.white,
                  color: _hasApplied
                      ? AppColors.greyColor
                      : AppColors.buttonColor,
                  borderColor: _hasApplied
                      ? AppColors.greyColor
                      : AppColors.buttonColor,
                ),
              ] else ...[
                // Only the creator can delete.
                CustomButton(
                  color: AppColors.colorD9A951,
                  borderColor: AppColors.colorD9A951,
                  textColor: AppColors.white,
                  onTap: _confirmAndDeleteEvent,
                  text: 'Delete',
                ),
              ],
              SizedBox(height: 24.h),
              _editHistorySection(),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [
          SizedBox(height: 4.h),
          SvgPicture.asset(AppIcons.dotIconForFamily, height: 12.h, width: 12.h)
        ]),
        SizedBox(width: 5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 5.h),
              Text(value, style: AppStyles.fieldContent(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithDateTime(String label, String date, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [
          SizedBox(height: 4.h),
          SvgPicture.asset(AppIcons.dotIconForFamily, height: 12.h, width: 12.h)
        ]),
        SizedBox(width: 5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 5.h),
              Row(children: [
                Text(date, style: AppStyles.fieldContent(color: Colors.grey.shade600)),
                SizedBox(width: 5.w),
                Text(time, style: AppStyles.fieldContent(color: Colors.grey.shade600)),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithCheck(
    String label,
    String value, {
    required bool checked,
    required VoidCallback onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              SizedBox(height: 4.h),
              SvgPicture.asset(AppIcons.dotIconForFamily, height: 12.h, width: 12.h)
            ]),
            SizedBox(width: 5.w),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                  _editableCheckBox(checked: checked, onTap: onChanged),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.only(left: 17.w),
          child: Text(value, style: AppStyles.fieldContent(color: Colors.grey.shade600)),
        ),
      ],
    );
  }
}
