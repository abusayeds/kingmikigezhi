import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../helpers/route.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';

class BottomMenu extends StatelessWidget {
  final int menuIndex;
  const BottomMenu(this.menuIndex, {super.key});

  Color colorByIndex(ThemeData theme, int index) {
    return index == menuIndex ? AppColors.white : AppColors.white;
  }

  BottomNavigationBarItem getItem(
      String image, String title, ThemeData theme, int index) {
    return BottomNavigationBarItem(
        label: title,
        icon: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: SvgPicture.asset(
            image,
            height: 24.0.h,
            width: 24.0.w,
          ),
        ));
  }

  Widget getAddItem() {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, //
      ),
      child: Center(
        child:Icon(Icons.add,color: AppColors.primaryColor,size: 35,)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<BottomNavigationBarItem> menuItems = [
      getItem(menuIndex == 0 ? AppIcons.selHome : AppIcons.homeIcons, 'Home', theme, 0),
      getItem(menuIndex == 1 ? AppIcons.selCategories : AppIcons.categories, 'Categories', theme, 1),
      BottomNavigationBarItem(label: '', icon: getAddItem(),),
      getItem(menuIndex == 2 ? AppIcons.selCalendar : AppIcons.calendarOutline, 'Event', theme, 2),
      getItem(menuIndex == 3 ? AppIcons.selNavProfile : AppIcons.navProfile, 'Profile', theme, 3),
    ];

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.r), topLeft: Radius.circular(10.r)),
          color: AppColors.primaryColor,
          boxShadow: const [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10)
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)),
        child: BottomNavigationBar(
          backgroundColor: AppColors.primaryColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.white,
          currentIndex: menuIndex,
          onTap: (value) {
            switch (value) {
              case 0:
                Get.offAndToNamed(AppRoutes.homeScreen);
                break;
              case 1:
                Get.offAndToNamed(AppRoutes.categoriesScreen);
                break;
              case 2:
                Get.toNamed(AppRoutes.createEventOne);
                break;
              case 3:
                Get.offAndToNamed(AppRoutes.myEventScreen);
                break;
              case 4:
                Get.offAndToNamed(AppRoutes.profileScreen);
                break;
            }
          },
          items: menuItems,
        ),
      ),
    );
  }
}
