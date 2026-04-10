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
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender.toLowerCase(),
        "birthday": birthday,
        "location": {
          "country": country,
          "state": state,
          "city": city,
        },
        "password": password,
        "confirmPassword": confirmPassword,
        "acceptTerms": acceptTerms,
      };

      final response = await apiService.post(
        ApiConstants.register,
        body: requestBody,
      );

      if (response != null) {
        // Save tokens
        await apiService.saveTokens(
          accessToken: response['accessToken'],
          refreshToken: response['refreshToken'],
          accessTokenExpiresAt: response['accessTokenExpiresAt'],
          refreshTokenExpiresAt: response['refreshTokenExpiresAt'],
        );

        // Save user data
        if (response['user'] != null) {
          await apiService.saveUserData(response['user']);
        }

        // Store email for OTP verification
        storedEmail.value = email;
        await sharedPreferences.setString(ApiConstants.keyUserEmail, email);

        isLoading.value = false;
        update();

        Fluttertoast.showToast(
          msg: "Registration successful! Please verify your email.",
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
          errorMessage = 'This password is too common. Please choose a stronger password.';
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
    required String email,
    required String otp,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "email": email,
        "otp": otp,
      };

      final response = await apiService.post(
        ApiConstants.verifyEmail,
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
        String error = e.toLowerCase();
        
        if (error.contains('no otp found')) {
          errorMessage = 'No OTP found for this email. Please request a new one.';
        } else if (error.contains('invalid otp') || error.contains('otp expired')) {
          errorMessage = 'Invalid or expired OTP. Please try again.';
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

  // Resend verification OTP
  Future<bool> resendVerificationOTP({
    required String email,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "email": email,
      };

      final response = await apiService.post(
        ApiConstants.verifyresendOTP,
        body: requestBody,
      );

      isLoading.value = false;
      update();

      if (response != null) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Verification code resent successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        return true;
      }

      return false;
    } catch (e) {
      isLoading.value = false;
      update();

      String errorMessage = 'Failed to resend verification code.';
      if (e is String) {
        String error = e.toLowerCase();
        
        if (error.contains('email is already verified')) {
          errorMessage = 'Email is already verified. Please sign in.';
          // Navigate to sign in screen
          Future.delayed(Duration(seconds: 2), () {
            Get.offAllNamed(AppRoutes.signInScreen);
          });
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

      if (response != null) {
        // Save tokens
        await apiService.saveTokens(
          accessToken: response['accessToken'],
          refreshToken: response['refreshToken'],
          accessTokenExpiresAt: response['accessTokenExpiresAt'],
          refreshTokenExpiresAt: response['refreshTokenExpiresAt'],
        );

        // Save user data
        if (response['user'] != null) {
          await apiService.saveUserData(response['user']);
        }

        isLoading.value = false;
        update();

        Fluttertoast.showToast(
          msg: "Login successful!",
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
        String error = e.toLowerCase();
        
        if (error.contains('email verification required') || error.contains('email_not_verified')) {
          errorMessage = 'Email not verified. Please check your email for the OTP.';
          // Store email for OTP verification
          storedEmail.value = email;
          await sharedPreferences.setString(ApiConstants.keyUserEmail, email);
          // Navigate to OTP verification
          Future.delayed(Duration(seconds: 2), () {
            Get.offAllNamed(AppRoutes.signUpOtpVerificationScreen, arguments: email);
          });
        } else if (error.contains('invalid credentials')) {
          errorMessage = 'Invalid email or password. Please try again.';
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

      if (response != null) {
        // Store email for OTP verification
        storedEmail.value = email;
        await sharedPreferences.setString(ApiConstants.keyUserEmail, email);

        Fluttertoast.showToast(
          msg: response['message'] ?? "Verification code sent to your email.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        return true;
      }

      return false;
    } catch (e) {
      isLoading.value = false;
      update();

      String errorMessage = 'Failed to send verification code.';
      if (e is String) {
        String error = e.toLowerCase();
        
        if (error.contains('too many')) {
          errorMessage = 'Too many password reset requests. Please try again later.';
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

  // Verify forgot password OTP
  Future<bool> verifyForgotPasswordOTP({
    required String email,
    required String otp,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "email": email,
        "otp": otp,
      };

      final response = await apiService.post(
        ApiConstants.resetpassVerifyOTP,
        body: requestBody,
      );

      isLoading.value = false;
      update();

      if (response != null) {
        Fluttertoast.showToast(
          msg: "Email verified successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        return true;
      }

      Fluttertoast.showToast(
        msg: "Verification failed. Please try again.",
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
        String error = e.toLowerCase();
        
        if (error.contains('invalid') || error.contains('verification code')) {
          errorMessage = 'Invalid verification code. Please try again.';
        } else if (error.contains('too many') || error.contains('failed attempts')) {
          errorMessage = 'Too many failed attempts. Please request a new verification code.';
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

  // Reset password
  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> requestBody = {
        "email": email,
        "token": token,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      final response = await apiService.post(
        ApiConstants.resetPass,
        body: requestBody,
      );

      isLoading.value = false;
      update();

      if (response != null) {
        Fluttertoast.showToast(
          msg: "Password reset successful!",
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
}
