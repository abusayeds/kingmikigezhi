class ApiConstants {
  // TODO: Change this to your actual backend API base URL
  static const String baseUrl = 'https://hrm.merinasib.shop'; // Replace with your actual base URL
  static const String apiUrl = '$baseUrl/api/v1';


  //Refresh Token
  static const String refreshToken = '$apiUrl/auth/refresh';

  
  // Auth endpoints
  static const String register = '$apiUrl/auth/register';
  static const String verifyEmail = '$apiUrl/auth/verify-email';
  static const String verifyresendOTP = '$apiUrl/auth/verify-email/resend';
  static const String login = '$apiUrl/auth/login';
  static const String forgotpassword = '$apiUrl/auth/forgot-password';
  static const String resetpassVerifyOTP = '$apiUrl/auth/reset-password/verify-otp';
  static const String resetPass = '$apiUrl/auth/reset-password';



  static const String logout = '$apiUrl/auth/logout';



  // Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyAccessTokenExpiresAt = 'access_token_expires_at';
  static const String keyRefreshTokenExpiresAt = 'refresh_token_expires_at';
  static const String keyUserData = 'user_data';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserEmail = 'user_email_for_otp';
}
