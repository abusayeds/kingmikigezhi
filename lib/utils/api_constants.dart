class ApiConstants {
  // TODO: Change this to your actual backend API base URL
  static const String baseUrl = 'http://10.10.11.17:8057'; // Replace with your actual base URL
  static const String apiUrl = '$baseUrl/api/v1';


  //Refresh Token
  static const String refreshToken = '$apiUrl/auth/refresh';

  // Username check
  static const String checkUsername = '$apiUrl/users/check-username';
  
  // Auth endpoints
  static const String register = '$apiUrl/auth/register';
  static const String verifyEmail = '$apiUrl/auth/verify-email';
  static const String verifyresendOTP = '$apiUrl/auth/resend-verification-otp';
  static const String login = '$apiUrl/auth/login';
  static const String forgotpassword = '$apiUrl/auth/forgot-password';
  static const String verifyforgotpassword = '$apiUrl/auth/verify-forgot-password-otp';
  static const String resendforgotpassword = '$apiUrl/auth/resend-forgot-password-otp';
  static const String resetpassVerifyOTP = '$apiUrl/auth/reset-password/verify-otp';
  static const String resetPass = '$apiUrl/auth/reset-password';
  static const String changePass = '$apiUrl/auth/change-password';

  static const String logout = '$apiUrl/auth/logout';



  // Profile
  static const String myProfile = '$apiUrl/users/me';
  static const String updateProfile = '$apiUrl/users/update-me';


  // Family
  static const String createFamily = '$apiUrl/families';
  static const String myFamilies = '$apiUrl/families';
  static const String getFamily = '$apiUrl/families/:userId';
  static const String updateFamily = '$apiUrl/families/:userId';
  static const String deleteFamily = '$apiUrl/families/:userId';


  // Family Members
  static const String addFamilyMember = '$apiUrl/family-members';
  static const String familyMemberbyFamilyId = '$apiUrl/family-members/family/:userId';
  static const String removeFamilyMember = '$apiUrl/family-members//family/:familyId/user/:userId';
  static const String addOwner = '$apiUrl/family-members/add-owner';



  // Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyAccessTokenExpiresAt = 'access_token_expires_at';
  static const String keyRefreshTokenExpiresAt = 'refresh_token_expires_at';
  static const String keyUserData = 'user_data';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserEmail = 'user_email_for_otp';
  static const String keySessionId = 'session_id';
}
