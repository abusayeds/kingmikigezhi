import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_list_tile.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class OwnerProfileDetailsScreen extends StatefulWidget {
  OwnerProfileDetailsScreen({super.key});

  @override
  State<OwnerProfileDetailsScreen> createState() =>
      _OwnerProfileDetailsScreenState();
}

class _OwnerProfileDetailsScreenState
    extends State<OwnerProfileDetailsScreen> {
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
        title: CustomText(
          text: AppStrings.ownerProfile,
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
                  color: Color(0xFF285B75),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Profile Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16),
                      // Name and Icon
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name Text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Labu Bashar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SvgPicture.asset(AppIcons.medalStar),
                              ],
                            ),
                            // Icon

                          ],
                        ),
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
                                    style: TextStyle(color: Colors.black),
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
                                    text: 'Math since 2021',
                                    style: TextStyle(color: Colors.black),
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
                                    style: TextStyle(color: Colors.black),
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
