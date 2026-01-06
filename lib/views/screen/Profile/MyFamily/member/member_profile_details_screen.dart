import 'package:event_sharing/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style.dart';
import '../../../../base/custom_text.dart';
import '../../../../base/custom_list_tile.dart';

class MemberProfileDetailsScreen extends StatefulWidget {
  MemberProfileDetailsScreen({super.key});

  @override
  State<MemberProfileDetailsScreen> createState() =>
      _MemberProfileDetailsScreenState();
}

class _MemberProfileDetailsScreenState
    extends State<MemberProfileDetailsScreen> {
  final TextEditingController birthDayYearController = TextEditingController();
  final TextEditingController birthDayMonthController = TextEditingController();
  final TextEditingController birthDayDayController = TextEditingController();

  final TextEditingController locationCountryController = TextEditingController();
  final TextEditingController locationStateController = TextEditingController();
  final TextEditingController locationCityController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: CustomText(
          text: AppStrings.memberProfile,

          fontWeight: FontWeight.w500,
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor),
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //=================================> Profile image <==========================
                          Container(
                            height: 120.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.r),
                                ),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                    width: 2.w, color: AppColors.primaryColor)),
                            child: Image.network(
                              'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 8),
                          //=================================> Profile Name <==========================
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Mr.Profile Member',
                                  textAlign: TextAlign.start,
                                  fontsize: 20.sp,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              //=================================> Relationship Name <==========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Relationship', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              CustomListTile(
                backgroundColor: AppColors.colorEDF2F4,
                title: 'Spous' ?? '',
              ),
              //=================================> Account Id  <==========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Account ID', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              CustomListTile(
                backgroundColor: AppColors.colorEDF2F4,
                title: '20103200' ?? '',
              ),
              //=================================> First Name <==========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('First Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              CustomListTile(
                title: 'Member' ?? '',
                backgroundColor: AppColors.colorEDF2F4,
              ),
              //=================================> Phone Number <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Last Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              CustomListTile(
                title: 'Rahman' ?? '',
                backgroundColor: AppColors.colorEDF2F4,
              ),
              //=================================> Address Number <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Public Display Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              CustomListTile(
                title: 'Dhaka' ?? '',
                backgroundColor: AppColors.colorEDF2F4,
              ),
              //=================================> Gender <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Gender',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              CustomListTile(
                title: 'Male' ?? '',
                backgroundColor: AppColors.colorEDF2F4,
              ),
              //==========================> Birth Date Text Field Row <=======================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Birthday',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              CustomListTile(
                title: '12-5-1995' ?? '',
                backgroundColor: AppColors.colorEDF2F4,
              ),

              //==========================> Birth Date Text Field Row <=======================

              //=================================> Email <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Email',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              CustomListTile(
                prefixIcon:
                    Icon(Icons.email_rounded, color: AppColors.primaryColor),
                title: 'email@gmail.com' ?? '',
                backgroundColor: AppColors.colorEDF2F4,
              ),
              //=======================> Phone Number Text Field <======================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Phone Number',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              CustomListTile(
                prefixIcon:
                Icon(Icons.email_rounded, color: AppColors.primaryColor),
                title: '+88111111188888' ?? '',
                backgroundColor: AppColors.colorEDF2F4,
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Location',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              CustomListTile(
                title: 'Ulon , Rampura' ?? '',
                backgroundColor: AppColors.colorEDF2F4,
              ),
              //=================================> Skill <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Skill',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.colorEDF2F4,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: AppColors.primaryColor, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '\u2022 ',
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                  TextSpan(
                                      text: 'Chess since 2020',
                                      style: AppStyles.fontSize14(
                                          color: AppColors.color414141))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '\u2022 ',
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                  TextSpan(
                                    text: 'Math since 2021',
                                    style:AppStyles.fontSize14(
                                        color: AppColors.color414141),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '\u2022 ',
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                  TextSpan(
                                    text: 'Piano since 2023',
                                    style: AppStyles.fontSize14(
                                        color: AppColors.color414141),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
