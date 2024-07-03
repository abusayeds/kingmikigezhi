import 'package:get/get.dart';
import '../views/screen/Home/home_screen.dart';
import '../views/screen/Onboard/onboard_screen.dart';
import '../views/screen/Onboard/onboard_second_screen.dart';
import '../views/screen/Profile/profile_screen.dart';
import '../views/screen/Splash/splash_screen.dart';
import '../views/screen/Wallet/wallet_screen.dart';

class AppRoutes{

  static String splashScreen="/splash_screen";
  static String homeScreen="/home_screen";
  static String profileScreen="/profile_screen";
  static String walletScreen="/wallet_screen";
  static String onboardScreen="/onboarding_screen";
  static String onboardSecondScreen="/onboard_second_screen";

 static List<GetPage> page=[
    GetPage(name:splashScreen, page: ()=>const SplashScreen()),
    GetPage(name:homeScreen, page: ()=>const HomeScreen()),
    GetPage(name:walletScreen, page: ()=>const WalletScreen()),
    GetPage(name:profileScreen, page: ()=>const ProfileScreen()),
    GetPage(name:onboardScreen, page: ()=>const OnboardScreen()),
    GetPage(name:onboardSecondScreen, page: ()=>const OnboardSecondScreen()),

  ];
}