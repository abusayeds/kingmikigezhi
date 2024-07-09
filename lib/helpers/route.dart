import 'package:get/get.dart';
import '../views/base/bottom_menu..dart';
import '../views/screen/Auth/ForgotPass/forgot_password_screen.dart';
import '../views/screen/Auth/LogIn/log_in_screen.dart';
import '../views/screen/Auth/ResetPass/reset_password_screen.dart';
import '../views/screen/Auth/SignUp/sign_up_screen.dart';
import '../views/screen/Auth/Verification/verification_code_screen.dart';
import '../views/screen/Calender/InnerWidget/filter_screen.dart';
import '../views/screen/Calender/calender_screen.dart';
import '../views/screen/Categories/categories_screen.dart';
import '../views/screen/DetailsEvent/details_event_screen.dart';
import '../views/screen/Home/home_screen.dart';
import '../views/screen/Notifications/notifications_screen.dart';
import '../views/screen/Onboard/onboard_screen.dart';
import '../views/screen/Onboard/onboard_second_screen.dart';
import '../views/screen/Profile/EditProfile/edit_profile_screen.dart';
import '../views/screen/Profile/MemberProfile/member_profile_screen.dart';
import '../views/screen/Profile/Personalinform/personal_information_screen.dart';
import '../views/screen/Profile/profileScreen/profile_screen.dart';
import '../views/screen/SearchEvent/search_event_screen.dart';
import '../views/screen/Settings/AboutUs/aboutus_screen.dart';
import '../views/screen/Settings/ChangePass/change_password.dart';
import '../views/screen/Settings/ChangePass/change_password.dart';
import '../views/screen/Settings/ChangePass/change_password.dart';
import '../views/screen/Settings/PrivacyPolicy/privacy_policy_screen.dart';
import '../views/screen/Settings/TermsConditions/terms_condition_screen.dart';
import '../views/screen/Settings/settingsScreen/settings_screen.dart';
import '../views/screen/Splash/splash_screen.dart';
import '../views/screen/UpComingEvent/upcoming_event_screen.dart';
import '../views/screen/Wallet/wallet_screen.dart';

class AppRoutes{

  static String splashScreen ="/splash_screen";
  static String homeScreen ="/home_screen";
  static String profileScreen ="/profile_screen";
  static String walletScreen ="/wallet_screen";
  static String onboardScreen ="/onboarding_screen";
  static String onboardSecondScreen ="/onboard_second_screen";
  static String logInScreen ="/log_in_screen";
  static String signUpScreen ="/sign_up_screen";
  static String forgotPasswordScreen ="/forgot_password_screen";
  static String verificationCodeScreen ="/verification_code_screen";
  static String resetPasswordScreen ="/reset_password_screen";
  static String categoriesScreen ="/categories_screen";
  static String calenderScreen ="/calender_screen";
  static String personalInformationScreen ="/personal_information_screen";
  static String editProfileScreen ="/edit_profile_screen";
  static String memberProfileScreen ="/member_profile_screen";
  static String settingsScreen ="/settings_screen";
  static String changePasswordScreen ="/change_password_screen";
  static String privacyPolicyScreen ="/privacy_policy_screen";
  static String termsConditionScreen ="/terms_condition_screen";
  static String aboutusScreen ="/aboutus_screen";
  static String upcomingEventScreen ="/upcoming_event_screen";
  static String detailsEventScreen ="/details_event_screen";
  static String searchEventScreen ="/search_event_screen";
  static String notificationsScreen ="/notifications_screen";
  static String filterScreen ="/filter_screen";
  //static String bottomMenu ="/bottom_menu";

 static List<GetPage> page=[
    GetPage(name:splashScreen, page: ()=>const SplashScreen()),
    GetPage(name:homeScreen, page: ()=>const HomeScreen()),
    GetPage(name:walletScreen, page: ()=>const WalletScreen()),
    GetPage(name:profileScreen, page: ()=>const ProfileScreen()),
    GetPage(name:onboardScreen, page: ()=>const OnboardScreen()),
    GetPage(name:onboardSecondScreen, page: ()=>const OnboardSecondScreen()),
    GetPage(name:logInScreen, page: ()=>const LogInScreen()),
    GetPage(name:signUpScreen, page: ()=>const SignUpScreen()),
    GetPage(name:forgotPasswordScreen, page: ()=>const ForgotPasswordScreen()),
    GetPage(name:verificationCodeScreen, page: ()=>const VerificationCodeScreen()),
    GetPage(name:resetPasswordScreen, page: ()=>const ResetPasswordScreen()),
    GetPage(name:categoriesScreen, page: ()=> CategoriesScreen()),
    GetPage(name:calenderScreen, page: ()=>const CalenderScreen()),
    GetPage(name:personalInformationScreen, page: ()=>const PersonalInformationScreen()),
    GetPage(name:editProfileScreen, page: ()=>const EditProfileScreen()),
    GetPage(name:memberProfileScreen, page: ()=>const MemberProfileScreen()),
    GetPage(name:settingsScreen, page: ()=>const SettingsScreen()),
    GetPage(name:changePasswordScreen, page: ()=>const ChangePasswordScreen()),
    GetPage(name:privacyPolicyScreen, page: ()=> PrivacyPolicyScreen()),
    GetPage(name:termsConditionScreen, page: ()=> TermsConditionScreen()),
    GetPage(name:aboutusScreen, page: ()=> AboutusScreen()),
    GetPage(name:upcomingEventScreen, page: ()=> UpcomingEventScreen()),
    GetPage(name:detailsEventScreen, page: ()=> DetailsEventScreen()),
    GetPage(name:searchEventScreen, page: ()=> SearchEventScreen()),
    GetPage(name:notificationsScreen, page: ()=> NotificationsScreen()),
    GetPage(name:filterScreen, page: ()=> FilterScreen()),
    //GetPage(name:bottomMenu, page: ()=> BottomMenu()),

  ];
}