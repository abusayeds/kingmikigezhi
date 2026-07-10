import 'package:event_sharing/views/screen/OwnerShip/InnerWidget/make_owner_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final List<Map<String, String>> ownerShipMembers = [
    {
      "imageUrl": "assets/images/concert.png",
      "title": "Mr Swapon",
      "mail": "mrswapon15@gmail.com",
      "phone": "+8801610663268",
    },
    // Add more members as needed
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
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            //==============================> Add Ownership Button <=======================
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // Get.toNamed(AppRoutes.createEventOne);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    border: Border.all(width: 1.w, color: AppColors.primaryColor),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_outlined,
                          color: Colors.white,
                          size: 16.h,
                        ),
                        SizedBox(width: 5.w),
                        const CustomText(
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
                itemCount: ownerShipMembers.length,
                itemBuilder: (context, index) {
                  final member = ownerShipMembers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    color: const Color(0xffedf2f4),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Row(
                        children: [
                          //=====================> Owner Image Section <=========================
                          CircleAvatar(
                            backgroundImage: AssetImage(member['imageUrl']!),
                          ),
                          SizedBox(width: 16.w),
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
                                //=====================> Owner Mail Section <=========================
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.mailIcon,
                                      color: AppColors.primaryColor,
                                      width: 16.w,
                                      height: 16.w,
                                    ),
                                    SizedBox(width: 6.w),
                                    CustomText(
                                      text: member['mail']!,
                                      fontsize: 10.sp,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                //=====================> Owner Phone Section <=========================
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.phoneIcon,
                                      color: AppColors.primaryColor,
                                      width: 16.w,
                                      height: 16.w,
                                    ),
                                    SizedBox(width: 6.w),
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
                                      return const RemoveAlert();
                                    },
                                  );
                                },
                                child: SvgPicture.asset(
                                  AppIcons.delete,
                                  width: 32.w,
                                  height: 32.w,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              //=====================> Make Owner Button <=========================
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const MakeOwnerAlert();
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                                    border: Border.all(width: 1.w, color: AppColors.primaryColor),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                    child: const CustomText(
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
