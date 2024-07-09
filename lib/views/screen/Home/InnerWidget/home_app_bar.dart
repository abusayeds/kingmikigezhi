import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_images.dart';
import '../../../base/custom_text.dart';

class HomeAppBar extends StatelessWidget {
  HomeAppBar({
    super.key,
  });

  //final HomeController _homeController = Get.put(HomeController());
  //final ProfileController _profileController = Get.put(ProfileController());
  // final dataController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    //_profileController.getProfileData();
//_profileController.getProfileData();
    return Row(
      children: [
        //==========================> Profile image <=============================
        // _profileController.profileModel.value.data?.attributes?.image?.publicFileUrl == null?
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.locationIcon,
                    height: 20.h,
                    width: 22.w,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  CustomText(
                    text: 'Dhaka',
                    fontsize: 14.h,
                    fontWeight: FontWeight.w500,
                  ),
                  SvgPicture.asset(
                    AppIcons.downArrowIcon,
                    width: 20.w,
                    height: 22.h,
                  )
                ],
              ),
              CustomText(
                text: 'Banasree, Rampura',
                //"${_profileController.profileModel.value.data?.attributes?.name}" ?? '',
              )
            ],
          ),
        ),
        SizedBox(width: 10.w),
        //=======================> Notifications Button <=======================
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.notificationsScreen);
          },
          child: Badge(
              backgroundColor: Colors.red,
              smallSize: 10,
              child: SvgPicture.asset(
                AppIcons.notificationIcon,
                color: AppColors.primaryColor,
                height: 28.h,
                width: 32.w,
              )),
        ),
        SizedBox(width: 13.w),
        //=======================> Profile Icon <=======================
        CircleAvatar(
            radius: 20.r,
            backgroundImage: const NetworkImage(
                "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg")),
      ],
    );
  }
}
