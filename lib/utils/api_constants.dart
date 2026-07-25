class ApiConstants {
  // TODO: Change this to your actual backend API base URL
  static const String baseUrl = 'http://206.162.244.11:7788'; // Replace with your actual base URL
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
  static const String deleteAccount = '$apiUrl/users/me';
  static const String getSkills = '$apiUrl/users/edit-options';



  //Get User
  static const String getUserProfile = '$apiUrl/users/:userId';




  // Family
  static const String createFamily = '$apiUrl/families';
  static const String myFamilies = '$apiUrl/families';
  static const String getFamily = '$apiUrl/families/:familyId';
  static const String updateFamily = '$apiUrl/families/:familyId';
  static const String deleteFamily = '$apiUrl/families/:familyId';


  // Family Members
  static const String addFamilyMember = '$apiUrl/family-members';
  static const String familyMemberbyFamilyId = '$apiUrl/family-members/family/:familyId';
  static const String familyOwnerbyFamilyId = '$apiUrl/family-members/family/:familyId?role=OWNER';
  static const String removeFamilyMember = '$apiUrl/family-members//family/:familyId/user/:userId';
  static const String addOwner = '$apiUrl/family-members/add-owner';




  //Programs
  static const String programs = '$apiUrl/programs';



  //Connections
  static const String createConnections = '$apiUrl/connections/requests/create';
  static const String suggestConnections = '$apiUrl/connections/suggestions';
  static const String myConnections = '$apiUrl/connections/my-connections';
  static const String sendRequestConnections = '$apiUrl/connections/requests/sent';
  static const String reciveRequestConnections = '$apiUrl/connections/requests/received';
  static const String acceptRequestConnection = '$apiUrl/connections/requests/accept/{{id}}';
  static const String rejectRequestConnection = '$apiUrl/connections/requests/reject/{{id}}';
  static const String cancelRequestConnection = '$apiUrl/connections/requests/cancel/{{id}}';
  static const String removeRequestConnection = '$apiUrl/connections/requests/remove/{{id}}';





  // Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyAccessTokenExpiresAt = 'access_token_expires_at';
  static const String keyRefreshTokenExpiresAt = 'refresh_token_expires_at';
  static const String keyUserData = 'user_data';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserEmail = 'user_email_for_otp';
  static const String keySessionId = 'session_id';


  // Categories
  static const String categoriesEvent = '$apiUrl/categories';
  static String subCategoriesEvent(String categoryId) => '$apiUrl/subcategories?categoryId=$categoryId';
  static String getProgrambySubCategory(String subcategoryId) => '$apiUrl/programs?subcategoryId=$subcategoryId';
  static String getProgrambyCategory(String categoryId) => '$apiUrl/programs?categoryId=$categoryId';
  static String categorieDetailsEvent(String categoryId) => '$apiUrl/categories/$categoryId';




  // Events
  static const String createEvent = '$apiUrl/events';
  static const String todayEvents = '$apiUrl/events/feed/today';
  static const String familySelfUsersEvents = '$apiUrl/events/feed/by-family-relation?relationShip=Self';
  static const String familySpousUsersEvents = '$apiUrl/events/feed/by-family-relation?relationShip=Spous';
  static const String familyChildStephanieUsersEvents = '$apiUrl/events/feed/by-family-relation?relationShip=ChildStephanie';
  static const String familyChildSophiaUsersEvents = '$apiUrl/events/feed/by-family-relation?relationShip=ChildSophia';
  static const String familyOtherUsersEvents = '$apiUrl/events/feed/by-family-relation?relationShip=Other';
  static const String getActiveEvents = '$apiUrl/events/feed/active';
  static const String getUpcomingEvents = '$apiUrl/events/feed/upcoming';
  static const String getHistoryEvents = '$apiUrl/events/feed/history';
  static const String getEventsDetails = '$apiUrl/events/:eventId';
  static const String updateEvents = '$apiUrl/events/:eventId';






  static const String appliedEvents = '$apiUrl/event-applications/my';

  //Settings
  static const String getAboutSettings = '$apiUrl/settings/about';
  static const String getTermsSettings = '$apiUrl/settings/terms';
  static const String getPrivacySettings = '$apiUrl/settings/privacy';




  //notification
  static const String getMyNotification = '$apiUrl/notifications/my';
  static const String readAllNotification = '$apiUrl/notifications/my/read-all';



  //contributions
  static const String getAllContributions = '$apiUrl/contributions';
  static const String getFilterContributions = '$apiUrl/contributions/filter-options';

  // User Settings
  static const String getUserSettings = '$apiUrl/user-settings';
  static const String updateUserSettings = '$apiUrl/user-settings';
  static const String getUserSettingsOptions = '$apiUrl/user-settings/options';


  // Invitations
  static const String getMyConnections = '$apiUrl/connections/my-connections';
  static String sendInvitations(String eventId) => '$apiUrl/event-invitations/share/$eventId';
  static const String getSentInvitation = '$apiUrl/event-invitations/sent';
  static const String getReceiveInvitation = '$apiUrl/event-invitations/received';
  static String acceptById(String userId) => '$apiUrl/event-invitations/$userId/accept';
  static String declineById(String userId) => '$apiUrl/event-invitations/$userId/decline';
  static String acceptByAll(String userId) => '$apiUrl/event-invitations/$userId/accept-all';
  static String declineByAll(String userId) => '$apiUrl/event-invitations/$userId/decline-all';




  
  
  
  
    //Feedback
  static const String createFeedback = '$apiUrl/feedbacks';



  //Search
  static const String searchEvents = '$apiUrl/events/feed/search';

  // Event Types
  static const String onsite = 'Onsite';
  static const String online = 'Online';
  static const String hybrid = 'Hybrid';
}
