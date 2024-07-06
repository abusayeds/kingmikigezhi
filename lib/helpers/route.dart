import 'package:get/get.dart';
import '../views/base/bottom_menu..dart';
import '../views/screen/Auth/ForgotPass/forgot_password_screen.dart';
import '../views/screen/Auth/LogIn/log_in_screen.dart';
import '../views/screen/Auth/ResetPass/reset_password_screen.dart';
import '../views/screen/Auth/SignUp/sign_up_screen.dart';
import '../views/screen/Auth/Verification/verification_code_screen.dart';
import '../views/screen/Calender/calender_screen.dart';
import '../views/screen/Categories/categories_screen.dart';
import '../views/screen/Home/home_screen.dart';
import '../views/screen/Onboard/onboard_screen.dart';
import '../views/screen/Onboard/onboard_second_screen.dart';
import '../views/screen/Profile/EditProfile/edit_profile_screen.dart';
import '../views/screen/Profile/MemberProfile/member_profile_screen.dart';
import '../views/screen/Profile/Personalinform/personal_information_screen.dart';
import '../views/screen/Profile/profileScreen/profile_screen.dart';
import '../views/screen/Splash/splash_screen.dart';
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
    GetPage(name:categoriesScreen, page: ()=>const CategoriesScreen()),
    GetPage(name:calenderScreen, page: ()=>const CalenderScreen()),
    GetPage(name:personalInformationScreen, page: ()=>const PersonalInformationScreen()),
    GetPage(name:editProfileScreen, page: ()=>const EditProfileScreen()),
    GetPage(name:memberProfileScreen, page: ()=>const MemberProfileScreen()),
    //GetPage(name:bottomMenu, page: ()=> BottomMenu()),

  ];
}