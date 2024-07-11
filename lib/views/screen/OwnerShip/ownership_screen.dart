import 'package:event_sharing/views/screen/OwnerShip/InnerWidget/make_owner_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_text.dart';
import 'InnerWidget/remove_alert.dart';

class OwnershipScreen extends StatefulWidget {
  const OwnershipScreen({super.key});

  @override
  State<OwnershipScreen> createState() => _OwnershipScreenState();
}

class _OwnershipScreenState extends State<OwnershipScreen> {
  final List<Map<String, String>> members = [
    {
      "imageUrl": "assets/images/concert.png",
      "title": "Mr Swapon",
      "mail": "mrswapon15@gmail.com",
      "phone": "+8801610663268",
    },
    {
      "imageUrl": "assets/images/concert.png",
      "title": "Mr Swapon",
      "mail": "mrswapon15@gmail.com",
      "phone": "+8801610663268",
    },
    {
      "imageUrl": "assets/images/concert.png",
      "title": "Mr Swapon",
      "mail": "mrswapon15@gmail.com",
      "phone": "+8801610663268",
    },
    {
      "imageUrl": "assets/images/concert.png",
      "title": "Mr Swapon",
      "mail": "mrswapon15@gmail.com",
      "phone": "+8801610663268",
    },
    {
      "imageUrl": "assets/images/concert.png",
      "title": "Mr Swapon",
      "mail": "mrswapon15@gmail.com",
      "phone": "+8801610663268",
    },
    {
      "imageUrl": "assets/images/concert.png",
      "title": "Mr Swapon",
      "mail": "mrswapon15@gmail.com",
      "phone": "+8801610663268",
    },
    {
      "imageUrl": "assets/images/concert.png",
      "title": "Mr Swapon",
      "mail": "mrswapon15@gmail.com",
      "phone": "+8801610663268",
    },
    {
      "imageUrl": "assets/images/concert.png",
      "title": "Mr Swapon",
      "mail": "mrswapon15@gmail.com",
      "phone": "+8801610663268",
    },
    {
      "imageUrl": "assets/images/concert.png",
      "title": "Mr Swapon",
      "mail": "mrswapon15@gmail.com",
      "phone": "+8801610663268",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.ownershipList,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            //==============================> Add Ownership Button <=======================
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: (){
                 // Get.toNamed(AppRoutes.createEventOne);
                },
                child: Container(
                  width: 135.w,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      border: Border.all(width: 1.w, color: AppColors.primaryColor)
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outlined, color: Colors.white,size: 16.h,),
                        SizedBox(width: 5.w),
                        CustomText(
                          text: 'Add Ownership',
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            //=================================> Member List view <========================
            Expanded(
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    color: const Color(0xffedf2f4),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Row(
                        children: [
                          //=====================> Owner Image Section <=========================
                          CircleAvatar(
                            child: Image.asset(
                              member['imageUrl']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16.h),
                          //=====================> Owner Title Section <=========================
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: member['title']!,
                                  fontsize: 14.sp,
                                ),
                                SizedBox(height: 8.h),
                                //=====================> Owner Location Section <=========================
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      width: 16.w,
                                      height: 12.h,
                                      AppIcons.mailIcon,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(width: 6.h),
                                    CustomText(
                                      text: member['mail']!,
                                      fontsize: 10.sp,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      width: 16.w,
                                      height: 12.h,
                                      AppIcons.phoneIcon,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(width: 6.h),
                                    CustomText(
                                      text: member['phone']!,
                                      fontsize: 10.sp,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              //===========================> Delete Icon Button <======================
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return RemoveAlert();
                                      });
                                },
                                child:  SvgPicture.asset(
                                  AppIcons.delete,width: 32.w,height: 32.h,
                                ),),
                              SizedBox(height: 8.h),
                              //=====================> Event Time Section <=========================
                              GestureDetector(
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return MakeOwnerAlert();
                                      });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                                      border: Border.all(width: 1.w, color: AppColors.primaryColor)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                                    child: CustomText(
                                      text: 'Owner',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
