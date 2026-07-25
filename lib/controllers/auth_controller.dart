import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/route.dart';
import '../../services/api_service.dart';
import '../../utils/api_constants.dart';

class AuthController extends GetxController {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;

  AuthController({required this.apiService, required this.sharedPreferences});

  // Loading state
  var isLoading = false.obs;

  // Email storage for OTP verification
  var storedEmail = ''.obs;

  // Session ID for OTP verification
  var storedSessionId = ''.obs;

  // Session ID for forgot password flow
  var forgotPasswordSessionId = ''.obs;

  // Check if username exists
  Future<bool> checkUsername(String username) async {
    try {
      final String fullUrl =
          '${ApiConstants.checkUsername}?username=${Uri.encodeComponent(username)}';
      print('=== CHECK USERNAME REQUEST ===');
      print('Base URL: ${ApiConstants.baseUrl}');
      print('Full URL: $fullUrl');
      print('Username: $username');
      print('==============================');

      final response = await apiService.get(fullUrl);

      print('=== CHECK USERNAME RESPONSE ===');
      print('Username: $username');
      print('Response: $response');
      print('Response type: ${response.runtimeType}');

      if (response is Map) {
        print('Success: ${response['success']}');
        print('Data: ${response['data']}');
        print('Exists: ${response['data']?['exists']}');
      }
      print('================================');

      // API returns: { success: true, data: { exists: true/false } }
      if (response is Map && response['success'] == true) {
        bool exists = response['data']?['exists'] ?? false;
        print('Username exists: $exists');
        return exists; // Returns true if username exists, false if available
      }

      print('Unexpected response format, returning false (available)');
      return false; // If response format unexpected, assume username is available
    } catch (e) {
      print('=== CHECK USERNAME ERROR ===');
      print('Username: $username');
      print('Error: $e');
      print('Error type: ${e.runtimeType}');
      print('=============================');

      Fluttertoast.showToast(
        msg: "Check error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      return false; // If error occurs, assume username is available to let user proceed
    }
  }

  // Register user
  Future<bool> registerUser({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String gender,
    required String birthday,
    required String country,
    required String state,
    required String city,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender.toUpperCase(),
        "birthDate": birthday,
        "location": country, // Location as string (country)
        "country": country,
        "state": state,
        "city": city,
        "email": email,
        "password": password,
      };

      final response = await apiService.post(
        ApiConstants.register,
        body: requestBody,
      );

      if (response != null && response['success'] == true) {
        // Store session ID for OTP verification
        String sessionId = response['data']['sessionId'] ?? '';
        storedSessionId.value = sessionId;
        await sharedPreferences.setString(ApiConstants.keySessionId, sessionId);

        // Store email for OTP verification
        storedEmail.value = email;
        await sharedPreferences.setString(ApiConstants.keyUserEmail, email);

        isLoading.value = false;
        update();

        Fluttertoast.showToast(
          msg: response['message'] ??
              "Registration successful! Please verify your email.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        return true;
      }

      isLoading.value = false;
      update();
      return false;
    } catch (e) {
      isLoading.value = false;
      update();

      String errorMessage = 'Registration failed. Please try again.';
      if (e is String) {
        String error = e.toLowerCase();

        if (error.contains('username already exists')) {
          errorMessage = 'Username already exists. Please choose another.';
        } else if (error.contains('email already registered')) {
          errorMessage = 'Email already registered. Please sign in.';
        } else if (error.contains('password must be at least 8 characters')) {
          errorMessage = 'Password must be at least 8 characters.';
        } else if (error.contains('password is too common')) {
          errorMessage =
              'This password is too common. Please choose a stronger password.';
        } else {
          errorMessage = e;
        }
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    }
  }

  // Verify email with OTP
  Future<bool> verifyEmail({
    required String sessionId,
    required String otp,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "sessionId": sessionId,
        "otp": otp,
      };

      final response = await apiService.post(
        ApiConstants.verifyEmail,
        body: requestBody,
      );

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        // Save tokens from nested structure
        if (response['data']['tokens'] != null) {
          await apiService.saveTokens(
            accessToken: response['data']['tokens']['accessToken'],
            refreshToken: response['data']['tokens']['refreshToken'],
            accessTokenExpiresAt: '', // Not provided in response
            refreshTokenExpiresAt: '', // Not provided in responses
          );
        }

        // Save user data
        if (response['data']['user'] != null) {
          await apiService.saveUserData(response['data']['user']);
        }

        Fluttertoast.showToast(
          msg: response['message'] ?? "Email verified successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        // Navigate to home screen after successful verification
        Get.offAllNamed(AppRoutes.homeScreen);
        return true;
      }

      Fluttertoast.showToast(
        msg: response['message'] ?? "Verification failed. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    } catch (e) {
      isLoading.value = false;
      update();

      String errorMessage = 'Verification failed. Please try again.';
      if (e is String) {
        errorMessage = e;
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    }
  }

  // Resend verification OTP
  Future<bool> resendVerificationOTP({
    required String sessionId,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "sessionId": sessionId,
      };

      final response = await apiService.post(
        ApiConstants.verifyresendOTP,
        body: requestBody,
      );

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Verification code resent successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        return true;
      }

      Fluttertoast.showToast(
        msg: response['message'] ?? "Failed to resend verification code.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    } catch (e) {
      isLoading.value = false;
      update();

      String errorMessage = 'Failed to resend verification code.';
      if (e is String) {
        errorMessage = e;
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    }
  }

  // Login user
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "email": email,
        "password": password,
      };

      final response = await apiService.post(
        ApiConstants.login,
        body: requestBody,
      );

      if (response != null && response['success'] == true) {
        // Save tokens from nested structure
        if (response['data']['tokens'] != null) {
          await apiService.saveTokens(
            accessToken: response['data']['tokens']['accessToken'],
            refreshToken: response['data']['tokens']['refreshToken'],
            accessTokenExpiresAt: '', // Not provided in response
            refreshTokenExpiresAt: '', // Not provided in response
          );
        }

        // Save user data
        if (response['data']['user'] != null) {
          await apiService.saveUserData(response['data']['user']);
        }

        isLoading.value = false;
        update();

        Fluttertoast.showToast(
          msg: response['message'] ?? "Login successful!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        // Navigate to home screen
        Get.offAllNamed(AppRoutes.homeScreen);
        return true;
      }

      isLoading.value = false;
      update();
      return false;
    } catch (e) {
      isLoading.value = false;
      update();

      String errorMessage = 'Login failed. Please check your credentials.';
      if (e is String) {
        errorMessage = e;
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await apiService.clearUserData();
    Get.offAllNamed(AppRoutes.signInScreen);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return sharedPreferences.getBool(ApiConstants.keyIsLoggedIn) ?? false;
  }

  // Get stored email
  String getStoredEmail() {
    return sharedPreferences.getString(ApiConstants.keyUserEmail) ?? '';
  }

  // Forgot password - send verification code
  Future<bool> forgotPassword({
    required String email,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "email": email,
      };

      final response = await apiService.post(
        ApiConstants.forgotpassword,
        body: requestBody,
      );

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        // Store sessionId for forgot password flow
        String sessionId = response['data']?['sessionId']?.toString() ?? '';
        forgotPasswordSessionId.value = sessionId;
        if (sessionId.isNotEmpty) {
          await sharedPreferences.setString(
              'forgot_password_session_id', sessionId);
        }

        // Store email for forgot password flow
        storedEmail.value = email;
        await sharedPreferences.setString(ApiConstants.keyUserEmail, email);

        Fluttertoast.showToast(
          msg: response['message'] ??
              "If the email exists, a password reset OTP has been sent.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        return sessionId.isNotEmpty;
      }

      return false;
    } catch (e) {
      isLoading.value = false;
      update();

      String errorMessage = 'Failed to send verification code.';
      if (e is String) {
        errorMessage = e;
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    }
  }

  // Verify forgot password OTP
  Future<Map<String, dynamic>?> verifyForgotPasswordOTP({
    required String sessionId,
    required String otp,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "sessionId": sessionId,
        "otp": otp,
      };

      final response = await apiService.post(
        ApiConstants.verifyforgotpassword,
        body: requestBody,
      );

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Email verified successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        // Store resetToken from response if available
        String resetToken = response['data']?['resetToken'] ?? '';
        if (resetToken.isNotEmpty) {
          await sharedPreferences.setString('reset_token', resetToken);
        }

        return response;
      }

      Fluttertoast.showToast(
        msg: response['message'] ?? "Verification failed. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return null;
    } catch (e) {
      isLoading.value = false;
      update();

      String errorMessage = 'Verification failed. Please try again.';
      if (e is String) {
        errorMessage = e;
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return null;
    }
  }

  // Resend forgot password OTP
  Future<bool> resendForgotPasswordOTP({
    required String sessionId,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "sessionId": sessionId,
      };

      final response = await apiService.post(
        ApiConstants.resendforgotpassword,
        body: requestBody,
      );

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Verification code resent successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        return true;
      }

      Fluttertoast.showToast(
        msg: response['message'] ?? "Failed to resend verification code.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    } catch (e) {
      isLoading.value = false;
      update();

      String errorMessage = 'Failed to resend verification code.';
      if (e is String) {
        errorMessage = e;
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "resetToken": resetToken,
        "newPassword": newPassword,
      };

      final response = await apiService.post(
        ApiConstants.resetPass,
        body: requestBody,
      );

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Password reset successful!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        // Navigate to sign in screen
        Get.offAllNamed(AppRoutes.signInScreen);
        return true;
      }

      return false;
    } catch (e) {
      isLoading.value = false;
      update();

      String errorMessage = 'Password reset failed. Please try again.';
      if (e is String) {
        errorMessage = e;
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    }
  }

  // User profile data
  var userProfile = Rxn<Map<String, dynamic>>();

  // Edit options from API
  final RxList<int> editOptionYears = <int>[].obs;
  final RxList<Map<String, String>> editOptionPrograms = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> editOptionGenders = <Map<String, String>>[].obs;
  final RxBool isLoadingEditOptions = false.obs;

  // Fetch user profile
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      update();

      final response = await apiService.get(ApiConstants.myProfile);

      if (response != null && response['success'] == true) {
        userProfile.value = response['data'];
        await apiService.saveUserData(response['data']);
      }

      isLoading.value = false;
      update();
    } catch (e) {
      isLoading.value = false;
      update();
      print('Error fetching profile: $e');
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? gender,
    String? birthDate,
    String? phoneNumber,
    String? country,
    String? state,
    String? city,
    String? username,
    String? imagePath,
    List<String>? skills,
  }) async {
    try {
      isLoading.value = true;
      update();

      dynamic response;
      // Construct location string as backend likely expects a single string or uses it as a label
      String? location;
      if (city != null || state != null || country != null) {
        location = "${city ?? ''}, ${state ?? ''}, ${country ?? ''}".trim();
        // Clean up leading/trailing commas if some parts are null
        location = location.replaceAll(RegExp(r'^,\s*'), '').replaceAll(RegExp(r',\s*$'), '');
      }

      if (imagePath != null && imagePath.isNotEmpty) {
        final Map<String, String> fields = {};
        if (firstName != null) fields['firstName'] = firstName;
        if (lastName != null) fields['lastName'] = lastName;
        if (gender != null) fields['gender'] = gender;
        if (birthDate != null) fields['birthDate'] = birthDate;
        if (phoneNumber != null) fields['phoneNumber'] = phoneNumber;
        if (location != null) fields['location'] = location;
        if (state != null) fields['state'] = state;
        if (city != null) fields['city'] = city;
        if (username != null) fields['username'] = username;
        if (skills != null) fields['skills'] = skills.join(',');

        response = await apiService.multipartRequest(
          ApiConstants.updateProfile,
          method: 'PATCH',
          fields: fields,
          files: {'profilePicture': imagePath},
        );
      } else {
        final Map<String, dynamic> requestBody = {};
        if (firstName != null) requestBody['firstName'] = firstName;
        if (lastName != null) requestBody['lastName'] = lastName;
        if (gender != null) requestBody['gender'] = gender;
        if (birthDate != null) requestBody['birthDate'] = birthDate;
        if (phoneNumber != null) requestBody['phoneNumber'] = phoneNumber;
        if (location != null) requestBody['location'] = location;
        if (state != null) requestBody['state'] = state;
        if (city != null) requestBody['city'] = city;
        if (username != null) requestBody['username'] = username;
        if (skills != null) requestBody['skills'] = skills;

        response = await apiService.patch(
          ApiConstants.updateProfile,
          body: requestBody,
        );
      }

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        // Merge with existing profile
        Map<String, dynamic> currentProfile = Map<String, dynamic>.from(userProfile.value ?? {});
        Map<String, dynamic> updatedData = Map<String, dynamic>.from(response['data']);
        
        currentProfile.addAll(updatedData);
        userProfile.value = currentProfile;
        
        await apiService.saveUserData(userProfile.value!);
        
        Fluttertoast.showToast(
          msg: response['message'] ?? "Profile updated successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        
        await fetchUserProfile();
        return true;
      }

      return false;
    } catch (e) {
      isLoading.value = false;
      update();
      Fluttertoast.showToast(
        msg: "Failed to update profile: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      };

      final response = await apiService.post(
        ApiConstants.changePass,
        body: requestBody,
      );

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Password changed successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        return true;
      }

      return false;
    } catch (e) {
      isLoading.value = false;
      update();
      Fluttertoast.showToast(
        msg: "Failed to change password: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  // Fetch edit options (skills/programs, years, genders)
  Future<void> fetchEditOptions() async {
    try {
      isLoadingEditOptions.value = true;
      update();

      final response = await apiService.get(ApiConstants.getSkills);

      if (response != null && response['success'] == true) {
        final data = response['data'];

        // Parse years
        final List<dynamic> years = data['startYears'] ?? [];
        editOptionYears.value = years.map((e) => e as int).toList();

        // Parse programs
        final List<dynamic> programs = data['programs'] ?? [];
        editOptionPrograms.value = programs
            .map<Map<String, String>>((e) => {
                  'id': e['id']?.toString() ?? '',
                  'name': e['name']?.toString() ?? '',
                })
            .toList();

        // Parse genders
        final List<dynamic> genders = data['genders'] ?? [];
        editOptionGenders.value = genders
            .map<Map<String, String>>((e) => {
                  'value': e['value']?.toString() ?? '',
                  'label': e['label']?.toString() ?? '',
                })
            .toList();
      }
    } catch (e) {
      print('fetchEditOptions error: $e');
    } finally {
      isLoadingEditOptions.value = false;
      update();
    }
  }
}
