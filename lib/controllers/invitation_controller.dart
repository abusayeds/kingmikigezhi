import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  Future<void> fetchMyConnections() async {
    try {
      isLoadingConnections.value = true;
      final response = await apiService.get(
          '${ApiConstants.getMyConnections}?page=1&limit=100');
      if (response != null && response['success'] == true) {
        myConnections.value = response['data'] ?? [];
      }
    } catch (e) {
      debugPrint('fetchMyConnections error: $e');
    } finally {
      isLoadingConnections.value = false;
    }
  }

  // ── Fetch received invitations ────────────────────────────────
  Future<void> fetchReceivedInvitations() async {
    try {
      isLoadingReceived.value = true;
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
      isLoadingSent.value = true;
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
      Fluttertoast.showToast(
          msg: 'Please select at least one person to invite.',
          gravity: ToastGravity.BOTTOM);
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
        Fluttertoast.showToast(
            msg: response['message'] ?? 'Invitations sent!',
            gravity: ToastGravity.BOTTOM);
        return true;
      }
      return false;
    } catch (e) {
      isSending.value = false;
      Fluttertoast.showToast(
          msg: 'Failed to send invitations: $e',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
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
        Fluttertoast.showToast(
            msg: response['message'] ?? 'Invitation accepted.',
            gravity: ToastGravity.BOTTOM);
        return true;
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Failed to accept: $e', gravity: ToastGravity.BOTTOM);
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
        Fluttertoast.showToast(
            msg: response['message'] ?? 'Invitation declined.',
            gravity: ToastGravity.BOTTOM);
        return true;
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Failed to decline: $e', gravity: ToastGravity.BOTTOM);
      return false;
    }
  }

  // ── Accept all received invitations ──────────────────────────
  Future<void> acceptAllInvitations(String eventId) async {
    try {
      final response = await apiService
          .patch(ApiConstants.acceptByAll(eventId), body: {});
      if (response != null && response['success'] == true) {
        receivedInvitations.clear();
        Fluttertoast.showToast(
            msg: response['message'] ?? 'All invitations accepted.',
            gravity: ToastGravity.BOTTOM);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Failed to accept all: $e', gravity: ToastGravity.BOTTOM);
    }
  }

  // ── Decline all received invitations ─────────────────────────
  Future<void> declineAllInvitations(String eventId) async {
    try {
      final response = await apiService
          .patch(ApiConstants.declineByAll(eventId), body: {});
      if (response != null && response['success'] == true) {
        receivedInvitations.clear();
        Fluttertoast.showToast(
            msg: response['message'] ?? 'All invitations declined.',
            gravity: ToastGravity.BOTTOM);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Failed to decline all: $e', gravity: ToastGravity.BOTTOM);
    }
  }

  void _removeFromReceived(String id) {
    receivedInvitations.removeWhere((inv) => inv['id'] == id);
  }

  // ── Helper: get the "other" user from a connection ────────────
  /// The API returns requester + receiver. The current user is one of them.
  /// This returns the other person's data.
  Map<String, dynamic> getConnectionPeer(
      Map<String, dynamic> connection, String currentUserId) {
    final requester = connection['requester'] as Map<String, dynamic>? ?? {};
    final receiver = connection['receiver'] as Map<String, dynamic>? ?? {};
    return requester['id'] == currentUserId ? receiver : requester;
  }
}
