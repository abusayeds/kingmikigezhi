import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/family_model.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class FamilyController extends GetxController {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;

  FamilyController({required this.apiService, required this.sharedPreferences});

  var families = <FamilyModel>[].obs;
  var isLoading = false.obs;
  var isCreating = false.obs;
  var isUpdating = false.obs;

  var currentFamily = Rxn<FamilyModel>();

  var familyMembers = <FamilyMemberModel>[].obs;
  var familyOwners = <FamilyMemberModel>[].obs;

  int currentPage = 1;
  int totalPages = 1;
  bool hasNext = false;
  bool hasPrev = false;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchFamilies({int page = 1, bool showErrorToast = true}) async {
    try {
      isLoading.value = true;
      update();

      final String url = '${ApiConstants.myFamilies}?page=$page&limit=10';
      final response = await apiService.get(url);

      if (response != null && response['success'] == true) {
        FamilyPaginationResponse paginationResponse =
            FamilyPaginationResponse.fromJson(response);

        families.value = paginationResponse.families;
        currentPage = paginationResponse.page;
        totalPages = paginationResponse.totalPages;
        hasNext = paginationResponse.hasNext;
        hasPrev = paginationResponse.hasPrev;
      }

      isLoading.value = false;
      update();
    } catch (e) {
      isLoading.value = false;
      update();
      if (showErrorToast) {
        Fluttertoast.showToast(
          msg: "Failed to load families: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> loadNextPage() async {
    if (hasNext && !isLoading.value) {
      await fetchFamilies(page: currentPage + 1);
    }
  }

  Future<void> loadPreviousPage() async {
    if (hasPrev && !isLoading.value) {
      await fetchFamilies(page: currentPage - 1);
    }
  }

  Future<bool> createFamily({
    required String name,
    String? description,
    String? imagePath,
  }) async {
    try {
      isCreating.value = true;
      update();

      final Map<String, String> fields = {
        'name': name,
        if (description != null && description.isNotEmpty)
          'description': description,
      };

      final dynamic response;
      if (imagePath != null && imagePath.isNotEmpty) {
        response = await apiService.multipartRequest(
          ApiConstants.createFamily,
          method: 'POST',
          fields: fields,
          files: {'imageUrl': imagePath},
        );
      } else {
        response = await apiService.post(
          ApiConstants.createFamily,
          body: fields,
        );
      }

      isCreating.value = false;
      update();

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Family created successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        await fetchFamilies();
        return true;
      }

      Fluttertoast.showToast(
        msg: response?['message']?.toString() ?? "Failed to create family",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    } catch (e) {
      isCreating.value = false;
      update();
      Fluttertoast.showToast(
        msg: "Failed to create family: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> deleteFamily(String familyId) async {
    try {
      isLoading.value = true;
      update();

      final response = await apiService
          .delete(ApiConstants.deleteFamily.replaceAll(':familyId', familyId));

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Family deleted successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        families.removeWhere((family) => family.id == familyId);
        return true;
      }

      return false;
    } catch (e) {
      isLoading.value = false;
      update();
      Fluttertoast.showToast(
        msg: "Failed to delete family: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<FamilyModel?> getFamilyById(String familyId) async {
    try {
      isLoading.value = true;
      update();

      final String url =
          ApiConstants.getFamily.replaceAll(':familyId', familyId);
      final response = await apiService.get(url);

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        final family = FamilyModel.fromJson(response['data']);
        currentFamily.value = family;
        return family;
      }

      return null;
    } catch (e) {
      isLoading.value = false;
      update();
      Fluttertoast.showToast(
        msg: "Failed to load family: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  Future<bool> updateFamily({
    required String familyId,
    String? name,
    String? description,
    String? imagePath,
  }) async {
    try {
      isUpdating.value = true;
      update();

      final String url =
          ApiConstants.updateFamily.replaceAll(':familyId', familyId);

      final Map<String, String> fields = {};
      if (name != null && name.isNotEmpty) fields['name'] = name;
      if (description != null) fields['description'] = description;

      final dynamic response;
      if (imagePath != null && imagePath.isNotEmpty) {
        response = await apiService.multipartRequest(
          url,
          method: 'PATCH',
          fields: fields,
          files: {'imageUrl': imagePath},
        );
      } else {
        response = await apiService.patch(url, body: fields);
      }

      isUpdating.value = false;
      update();

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Family updated successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        await fetchFamilies();
        return true;
      }

      Fluttertoast.showToast(
        msg: response?['message']?.toString() ?? "Failed to update family",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    } catch (e) {
      isUpdating.value = false;
      update();
      Fluttertoast.showToast(
        msg: "Failed to update family: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<void> fetchFamilyMembers(String familyId,
      {bool isOwner = false, bool showErrorToast = true}) async {
    try {
      isLoading.value = true;
      update();

      String url =
          ApiConstants.familyMemberbyFamilyId.replaceAll(':familyId', familyId);

      // Only add role filter for OWNER tab
      if (isOwner) {
        url = '$url?role=OWNER';
      }
      // For MEMBER tab, fetch ALL members (no role filter) - includes owners who are also members

      final response = await apiService.get(url);

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        List<FamilyMemberModel> membersList = [];
        if (response['data'] != null && response['data'] is List) {
          membersList = (response['data'] as List)
              .map((member) => FamilyMemberModel.fromJson(member))
              .toList();
        }

        if (isOwner) {
          familyOwners.value = membersList;
        } else {
          familyMembers.value = membersList;
        }
      }
    } catch (e) {
      isLoading.value = false;
      update();
      if (showErrorToast) {
        Fluttertoast.showToast(
          msg: "Failed to load family members: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<bool> addFamilyMember({
    required String familyId,
    required String firstName,
    required String lastName,
    required String gender,
    required String birthDate,
    required String location,
    required String country,
    required String state,
    required String city,
    required String email,
    required String password,
    required String username,
    required String relationShip,
    List<String>? skills,
    bool isIndependent = false,
    String role = 'MEMBER',
  }) async {
    try {
      isCreating.value = true;
      update();

      // Matches POST /family-members body contract
      final Map<String, dynamic> requestBody = {
        'familyId': familyId,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'birthDate': birthDate,
        'location': location,
        'country': country,
        'state': state,
        'city': city,
        'email': email,
        'password': password,
        'username': username,
        'relationShip': relationShip,
        'skills': skills ?? <String>[],
        'isIndependent': isIndependent,
        'role': role,
      };

      final response = await apiService.post(
        ApiConstants.addFamilyMember,
        body: requestBody,
      );

      isCreating.value = false;
      update();

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Family member added successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        await fetchFamilyMembers(familyId);
        return true;
      }

      final errors = response?['errors'];
      final detail = errors is List && errors.isNotEmpty
          ? errors.map((e) => e.toString()).join('\n')
          : null;
      Fluttertoast.showToast(
        msg: detail ??
            response?['message']?.toString() ??
            "Failed to add family member",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    } catch (e) {
      isCreating.value = false;
      update();
      Fluttertoast.showToast(
        msg: "Failed to add family member: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> makeOwner({
    required String familyId,
    required String newOwnerUserId,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        'familyId': familyId,
        'newOwnerUserId': newOwnerUserId,
      };

      final response = await apiService.patch(
        ApiConstants.addOwner,
        body: requestBody,
      );

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Owner added successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        await fetchFamilyMembers(familyId, isOwner: true);
        return true;
      }

      return false;
    } catch (e) {
      isLoading.value = false;
      update();
      Fluttertoast.showToast(
        msg: "Failed to add owner: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> removeFamilyMember({
    required String familyId,
    required String userId,
  }) async {
    try {
      isLoading.value = true;
      update();

      final String url = ApiConstants.removeFamilyMember
          .replaceAll(':familyId', familyId)
          .replaceAll(':userId', userId);

      final response = await apiService.delete(url);

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Member removed successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        familyMembers.removeWhere((member) => member.userId == userId);
        familyOwners.removeWhere((member) => member.userId == userId);
        return true;
      }

      return false;
    } catch (e) {
      isLoading.value = false;
      update();
      Fluttertoast.showToast(
        msg: "Failed to remove member: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }
}
