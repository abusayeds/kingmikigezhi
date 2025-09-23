import 'dart:ui';

import 'package:get/get.dart';

enum InvitationStatus { pending, accepted, rejected }

class InvitationListController extends GetxController {
  // Observable list to track individual invitation statuses
  RxList<InvitationStatus> invitationStatuses = <InvitationStatus>[].obs;

  // Observable to track if all invitations have been processed
  RxBool allAccepted = false.obs;
  RxBool allRejected = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with 6 pending invitations
    initializeInvitations();
  }

  void initializeInvitations() {
    invitationStatuses.value = List.generate(6, (index) => InvitationStatus.pending);
  }

  // Accept individual invitation
  void acceptInvitation(int index) {
    if (index < invitationStatuses.length) {
      invitationStatuses[index] = InvitationStatus.accepted;
      invitationStatuses.refresh(); // Trigger UI update

      // Reset global states if individual action is taken
      allAccepted.value = false;
      allRejected.value = false;
    }
  }

  // Reject individual invitation
  void rejectInvitation(int index) {
    if (index < invitationStatuses.length) {
      invitationStatuses[index] = InvitationStatus.rejected;
      invitationStatuses.refresh(); // Trigger UI update

      // Reset global states if individual action is taken
      allAccepted.value = false;
      allRejected.value = false;
    }
  }

  // Accept all invitations
  void acceptAllInvitations() {
    for (int i = 0; i < invitationStatuses.length; i++) {
      invitationStatuses[i] = InvitationStatus.accepted;
    }
    allAccepted.value = true;
    allRejected.value = false;
    invitationStatuses.refresh();
  }

  // Reject all invitations
  void rejectAllInvitations() {
    for (int i = 0; i < invitationStatuses.length; i++) {
      invitationStatuses[i] = InvitationStatus.rejected;
    }
    allRejected.value = true;
    allAccepted.value = false;
    invitationStatuses.refresh();
  }

  // Check if individual invitation is pending
  bool isInvitationPending(int index) {
    return index < invitationStatuses.length &&
        invitationStatuses[index] == InvitationStatus.pending;
  }

  // Check if individual invitation is accepted
  bool isInvitationAccepted(int index) {
    return index < invitationStatuses.length &&
        invitationStatuses[index] == InvitationStatus.accepted;
  }

  // Check if individual invitation is rejected
  bool isInvitationRejected(int index) {
    return index < invitationStatuses.length &&
        invitationStatuses[index] == InvitationStatus.rejected;
  }

  // Get status text for individual invitations
  String getStatusText(int index) {
    if (index >= invitationStatuses.length) return '';

    switch (invitationStatuses[index]) {
      case InvitationStatus.accepted:
        return 'Invitation request accepted';
      case InvitationStatus.rejected:
        return 'Invitation request rejected';
      case InvitationStatus.pending:
      default:
        return '';
    }
  }

  // Get status color for individual invitations
  // Color getStatusColor(int index) {
  //   if (index >= invitationStatuses.length) return Colors.black;
  //
  //   switch (invitationStatuses[index]) {
  //     case InvitationStatus.accepted:
  //       return Color(0xFF28AC4B);
  //     case InvitationStatus.rejected:
  //       return Color(0xFFD54444);
  //     case InvitationStatus.pending:
  //     default:
  //       return Colors.black;
  //   }
  // }
}