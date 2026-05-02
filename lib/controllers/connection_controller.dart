import 'package:event_sharing/services/api_service.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionController extends GetxController {
  final SharedPreferences sharedPreferences;
  final ApiService apiService;

  ConnectionController(
      {required this.sharedPreferences, required this.apiService});

  // Invitations
  RxList<dynamic> invitations = <dynamic>[].obs;
  RxInt invitationPage = 1.obs;
  RxInt invitationTotal = 0.obs;
  RxBool isLoadingInvitations = false.obs;
  RxBool hasMoreInvitations = true.obs;

  // Connections
  RxList<dynamic> connections = <dynamic>[].obs;
  RxInt connectionPage = 1.obs;
  RxInt connectionTotal = 0.obs;
  RxBool isLoadingConnections = false.obs;
  RxBool hasMoreConnections = true.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInvitations();
    fetchConnections();
  }

  // Fetch received connection requests
  Future<void> fetchInvitations({bool isRefresh = true}) async {
    if (isRefresh) {
      invitationPage.value = 1;
      invitations.clear();
      hasMoreInvitations.value = true;
    }

    if (isLoadingInvitations.value || !hasMoreInvitations.value) return;

    try {
      isLoadingInvitations.value = true;
      final String url =
          '${ApiConstants.reciveRequestConnections}?page=${invitationPage.value}&limit=10';

      final response = await apiService.get(url);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        final meta = response['meta'];

        invitations.addAll(data);
        invitationTotal.value = meta['total'] ?? 0;
        hasMoreInvitations.value = meta['hasNext'] ?? false;

        if (hasMoreInvitations.value) {
          invitationPage.value++;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load invitations: ${e.toString()}');
    } finally {
      isLoadingInvitations.value = false;
    }
  }

  // Accept connection request
  Future<void> acceptConnection(String requestId, {bool shouldRefresh = true}) async {
    try {
      final String url =
          ApiConstants.acceptRequestConnection.replaceAll('{{id}}', requestId);

      final response = await apiService.patch(url, body: {});

      if (response != null && response['success'] == true) {
        invitations.removeWhere((item) => item['id'] == requestId);
        invitationTotal.value--;
        if (shouldRefresh) {
          fetchConnections(isRefresh: true);
        }
        if (shouldRefresh) {
          Get.snackbar('Success', response['message'] ?? 'Connection accepted');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept connection: ${e.toString()}');
    }
  }

  // Reject connection request
  Future<void> rejectConnection(String requestId, {bool shouldRefresh = true}) async {
    try {
      final String url =
          ApiConstants.rejectRequestConnection.replaceAll('{{id}}', requestId);

      final response = await apiService.patch(url, body: {});

      if (response != null && response['success'] == true) {
        invitations.removeWhere((item) => item['id'] == requestId);
        invitationTotal.value--;
        if (shouldRefresh) {
          Get.snackbar('Success', response['message'] ?? 'Connection rejected');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject connection: ${e.toString()}');
    }
  }

  // Accept all connection requests
  Future<void> acceptAllConnections() async {
    try {
      final List<String> requestIds =
          invitations.map((item) => item['id'] as String).toList();

      for (String id in requestIds) {
        await acceptConnection(id, shouldRefresh: false);
      }
      fetchConnections(isRefresh: true);
      fetchInvitations(isRefresh: true);
      Get.snackbar('Success', 'All connections accepted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept all connections: ${e.toString()}');
    }
  }

  // Reject all connection requests
  Future<void> rejectAllConnections() async {
    try {
      final List<String> requestIds =
          invitations.map((item) => item['id'] as String).toList();

      for (String id in requestIds) {
        await rejectConnection(id, shouldRefresh: false);
      }
      fetchInvitations(isRefresh: true);
      Get.snackbar('Success', 'All connections rejected');
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject all connections: ${e.toString()}');
    }
  }

  // Fetch my connections
  Future<void> fetchConnections({bool isRefresh = true}) async {
    if (isRefresh) {
      connectionPage.value = 1;
      connections.clear();
      hasMoreConnections.value = true;
    }

    if (isLoadingConnections.value || !hasMoreConnections.value) return;

    try {
      isLoadingConnections.value = true;
      final String url =
          '${ApiConstants.myConnections}?page=${connectionPage.value}&limit=10';

      final response = await apiService.get(url);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        final meta = response['meta'];

        connections.addAll(data);
        connectionTotal.value = meta['total'] ?? 0;
        hasMoreConnections.value = meta['hasNext'] ?? false;

        if (hasMoreConnections.value) {
          connectionPage.value++;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load connections: ${e.toString()}');
    } finally {
      isLoadingConnections.value = false;
    }
  }

  // Remove connection
  Future<void> removeConnection(String connectionId) async {
    try {
      final String url = ApiConstants.removeRequestConnection
          .replaceAll('{{id}}', connectionId);

      final response = await apiService.delete(url);

      if (response['success'] == true) {
        connections.removeWhere((item) => item['id'] == connectionId);
        Get.snackbar('Success', 'Connection removed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove connection: ${e.toString()}');
    }
  }

  // Search connections
  List<dynamic> getFilteredConnections() {
    if (searchQuery.value.isEmpty) {
      return connections;
    }
    final query = searchQuery.value.toLowerCase();
    return connections.where((connection) {
      final requester = connection['requester'];
      final receiver = connection['receiver'];
      final name =
          '${requester['firstName']} ${requester['lastName']}'.toLowerCase();
      final username = requester['username'].toLowerCase();
      final email = requester['email'].toLowerCase();

      return name.contains(query) ||
          username.contains(query) ||
          email.contains(query);
    }).toList();
  }
}
