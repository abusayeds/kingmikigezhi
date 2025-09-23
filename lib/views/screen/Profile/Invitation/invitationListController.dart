import 'package:get/get.dart';

enum InvitationStatus { pending, accepted, rejected }

class InvitationListController extends GetxController {
  RxInt cardIndex = 100.obs;

  // Map to track the status of each invitation by index
  RxMap<int, InvitationStatus> invitationStatusMap = <int, InvitationStatus>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize all invitations as pending
    for (int i = 0; i < 6; i++) {
      invitationStatusMap[i] = InvitationStatus.pending;
    }
  }

  // Accept invitation
  void acceptInvitation(int index) {
    invitationStatusMap[index] = InvitationStatus.accepted;
    invitationStatusMap.refresh();
  }

  // Reject invitation
  void rejectInvitation(int index) {
    invitationStatusMap[index] = InvitationStatus.rejected;
    invitationStatusMap.refresh();
  }

  // Accept all invitations
  void acceptAllInvitations() {
    for (int i = 0; i < 6; i++) {
      if (invitationStatusMap[i] == InvitationStatus.pending) {
        invitationStatusMap[i] = InvitationStatus.accepted;
      }
    }
    invitationStatusMap.refresh();
  }

  // Reject all invitations
  void rejectAllInvitations() {
    for (int i = 0; i < 6; i++) {
      if (invitationStatusMap[i] == InvitationStatus.pending) {
        invitationStatusMap[i] = InvitationStatus.rejected;
      }
    }
    invitationStatusMap.refresh();
  }

  // Get invitation status
  InvitationStatus getInvitationStatus(int index) {
    return invitationStatusMap[index] ?? InvitationStatus.pending;
  }
}