import 'package:event_sharing/helpers/app_feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class InvitationController extends GetxController {
  final SharedPreferences sharedPreferences;
  final ApiService apiService;

  InvitationController(
      {required this.sharedPreferences, required this.apiService});

  // ── My Connections (for sending invitations) ──────────────────
  final RxList<dynamic> myConnections = <dynamic>[].obs;
  final RxBool isLoadingConnections = false.obs;

  // ── Received Invitations ──────────────────────────────────────
  final RxList<dynamic> receivedInvitations = <dynamic>[].obs;
  final RxBool isLoadingReceived = false.obs;

  // ── Sent Invitations ──────────────────────────────────────────
  final RxList<dynamic> sentInvitations = <dynamic>[].obs;
  final RxBool isLoadingSent = false.obs;

  // ── Sending state ─────────────────────────────────────────────
  final RxBool isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // ── Fetch my connections (people list for invitation) ─────────
  Future<void> fetchMyConnections({String? eventId}) async {
    try {
      isLoadingConnections.value = myConnections.isEmpty;
      // Prefer event-scoped share connections (flat user rows + alreadyInvited).
      final url = (eventId != null && eventId.isNotEmpty)
          ? '${ApiConstants.shareInvitationConnections(eventId)}?page=1&limit=100'
          : '${ApiConstants.getMyConnections}?page=1&limit=100';
      final response = await apiService.get(url);
      if (response != null && response['success'] == true) {
        myConnections.value = response['data'] ?? [];
      } else {
        AppFeedback.error(
          response?['message']?.toString() ??
              'Could not load connections. Please try again.',
        );
      }
    } catch (e) {
      debugPrint('fetchMyConnections error: $e');
      AppFeedback.error(e.toString(), title: 'Could not load connections');
    } finally {
      isLoadingConnections.value = false;
    }
  }

  // ── Fetch received invitations ────────────────────────────────
  Future<void> fetchReceivedInvitations() async {
    try {
      isLoadingReceived.value = receivedInvitations.isEmpty;
      final response =
          await apiService.get(ApiConstants.getReceiveInvitation);
      if (response != null && response['success'] == true) {
        receivedInvitations.value = response['data'] ?? [];
      }
    } catch (e) {
      debugPrint('fetchReceivedInvitations error: $e');
    } finally {
      isLoadingReceived.value = false;
    }
  }

  // ── Fetch sent invitations ────────────────────────────────────
  Future<void> fetchSentInvitations() async {
    try {
      isLoadingSent.value = sentInvitations.isEmpty;
      final response =
          await apiService.get(ApiConstants.getSentInvitation);
      if (response != null && response['success'] == true) {
        sentInvitations.value = response['data'] ?? [];
      }
    } catch (e) {
      debugPrint('fetchSentInvitations error: $e');
    } finally {
      isLoadingSent.value = false;
    }
  }

  // ── Send invitations ──────────────────────────────────────────
  /// [eventId] - the event being shared
  /// [inviteeIds] - list of user IDs to invite
  /// [message] - optional message
  Future<bool> sendInvitations({
    required String eventId,
    required List<String> inviteeIds,
    String message = '',
  }) async {
    if (inviteeIds.isEmpty) {
      AppFeedback.validation('Select at least one person to invite.');
      return false;
    }
    try {
      isSending.value = true;
      final Map<String, dynamic> body = {
        'inviteeIds': inviteeIds,
        if (message.isNotEmpty) 'message': message,
      };
      final response = await apiService.post(
        ApiConstants.sendInvitations(eventId),
        body: body,
      );
      isSending.value = false;
      if (response != null && response['success'] == true) {
        // Success UI (toast + redirect) is handled by the caller screen.
        return true;
      }
      AppFeedback.error(
        response?['message']?.toString() ??
            'Could not send the invitation. Please try again.',
      );
      return false;
    } catch (e) {
      isSending.value = false;
      AppFeedback.error(e.toString(), title: 'Could not send invitation');
      return false;
    }
  }

  // ── Accept a received invitation ──────────────────────────────
  Future<bool> acceptInvitation(String invitationId) async {
    try {
      final response =
          await apiService.patch(ApiConstants.acceptById(invitationId), body: {});
      if (response != null && response['success'] == true) {
        _removeFromReceived(invitationId);
        AppFeedback.success(response['message']?.toString() ?? 'Invitation accepted.');
        return true;
      }
      return false;
    } catch (e) {
      AppFeedback.error('Could not accept this invitation.');
      return false;
    }
  }

  // ── Decline a received invitation ─────────────────────────────
  Future<bool> declineInvitation(String invitationId) async {
    try {
      final response = await apiService
          .patch(ApiConstants.declineById(invitationId), body: {});
      if (response != null && response['success'] == true) {
        _removeFromReceived(invitationId);
        AppFeedback.success(response['message']?.toString() ?? 'Invitation ignored.');
        return true;
      }
      return false;
    } catch (e) {
      AppFeedback.error('Could not ignore this invitation.');
      return false;
    }
  }

  // ── Accept all received invitations ──────────────────────────
  Future<void> acceptAllInvitations() async {
    try {
      final response =
          await apiService.patch(ApiConstants.acceptByAll, body: {});
      if (response != null && response['success'] == true) {
        receivedInvitations.clear();
        AppFeedback.success(response['message']?.toString() ?? 'All invitations accepted.');
      }
    } catch (e) {
      AppFeedback.error('Could not accept all invitations.');
    }
  }

  // ── Decline / Ignore all received invitations ────────────────
  Future<void> declineAllInvitations() async {
    try {
      final response =
          await apiService.patch(ApiConstants.declineByAll, body: {});
      if (response != null && response['success'] == true) {
        receivedInvitations.clear();
        AppFeedback.success(response['message']?.toString() ?? 'All invitations ignored.');
      }
    } catch (e) {
      AppFeedback.error('Could not ignore all invitations.');
    }
  }

  void _removeFromReceived(String id) {
    receivedInvitations.removeWhere((inv) => inv['id'] == id);
  }

  // ── Helper: get the "other" user from a connection ────────────
  /// Supports:
  /// - share connections API (flat user object with `id`)
  /// - my-connections API (`requester` + `receiver`)
  Map<String, dynamic> getConnectionPeer(
      Map<String, dynamic> connection, String currentUserId) {
    if (connection['requester'] == null && connection['receiver'] == null) {
      return connection;
    }
    final requester = connection['requester'] as Map<String, dynamic>? ?? {};
    final receiver = connection['receiver'] as Map<String, dynamic>? ?? {};
    if (currentUserId.isNotEmpty && requester['id']?.toString() == currentUserId) {
      return receiver;
    }
    if (currentUserId.isNotEmpty && receiver['id']?.toString() == currentUserId) {
      return requester;
    }
    // Fallback when profile id is not loaded yet.
    return receiver.isNotEmpty ? receiver : requester;
  }
}
