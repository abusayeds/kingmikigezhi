import 'package:country_code_picker/country_code_picker.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:event_sharing/views/screen/Profile/Account/InnerWidget/top_profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_list_tile.dart';

class PersonalInformationScreen extends StatefulWidget {
   PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {

  final TextEditingController birthDayYearController = TextEditingController();
  final TextEditingController birthDayMonthController = TextEditingController();
  final TextEditingController birthDayDayController = TextEditingController();

   final TextEditingController locationCountryController = TextEditingController();
   final TextEditingController locationStateController = TextEditingController();
   final TextEditingController locationCityController = TextEditingController();
   final TextEditingController phoneNumberController = TextEditingController();

   String selectedCountryCodes = '+880';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.account,
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
              TopProfileSection(),
              SizedBox(height: 24.h),
              //=================================> Profile Name <==========================
             Padding(
               padding: const EdgeInsets.all(4),
               child: Text('Account ID',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
             ),
              CustomListTile(
                backgroundColor: AppColors.colorEDF2F4,
                title: '20103200'??'',),
              //=================================> Email Name <==========================
              Padding( padding: const EdgeInsets.all(4),
                child: Text('First Name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
              ),
              CustomListTile(title: 'Mahafujer'??'',  backgroundColor: AppColors.colorEDF2F4,),
              //=================================> Phone Number <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Last Name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
              ),
              CustomListTile(title:'Rahman'??'',backgroundColor: AppColors.colorEDF2F4,),
              //=================================> Address Number <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Public Display Name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
              ),
              CustomListTile(title: 'Dhaka'??'',backgroundColor: AppColors.colorEDF2F4,),
              //=================================> Gender <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Gender',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
              ),
              CustomListTile(title: 'Male'??'',backgroundColor: AppColors.colorEDF2F4,),
              //==========================> Birth Date Text Field Row <=======================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Birthday',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 108.w,
                    child: CustomTextField(
                      controller: birthDayYearController,
                      hintText: 'Day',
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                          color: AppColors.primaryColor,
                        ),
                      ),

                    ),
                  ),
                  SizedBox(
                    width: 108.w,
                    child: CustomTextField(
                      controller: birthDayMonthController,
                      hintText: 'Month',
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                          color: AppColors.primaryColor,
                        ),
                      ),

                    ),
                  ),
                  SizedBox(
                    width: 108.w,
                    child: CustomTextField(
                      controller: birthDayYearController,
                      hintText: 'Year',
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //=================================> Email <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Email',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
              ),
              CustomListTile(
                prefixIcon: Icon(Icons.email_rounded,color: AppColors.primaryColor),
                title: 'email@gmail.com'??'',backgroundColor: AppColors.colorEDF2F4,),
              //=======================> Phone Number Text Field <======================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Phone Number',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.fillColor,
                        border: Border.all(
                            width: 1.w, color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(8.r)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //=================================> Country Code Picker Widget <============================
                        CountryCodePicker(
                          showFlag: false,
                          showFlagDialog: true,
                          onChanged: (countryCode) {
                            setState(() {
                              selectedCountryCodes = countryCode.dialCode!;
                            });
                          },
                          initialSelection: 'BD',
                          favorite: ['+880', 'BD'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 5.w),
                            child: Icon(Icons.arrow_drop_down_sharp)
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomTextField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      hintText: AppStrings.phoneNumberHintText,
                      ),
                    ),
                ],
              ),

              //=================================> Location <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Location',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 108.w,
                    child: CustomTextField(
                      controller: locationCountryController,
                      hintText: 'Country',
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                        ),
                      ),

                    ),
                  ),
                  SizedBox(
                    width: 108.w,
                    child: CustomTextField(
                      controller: locationStateController,
                      hintText: 'State',
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                        ),
                      ),

                    ),
                  ),
                  SizedBox(
                    width: 108.w,
                    child: CustomTextField(
                      controller: locationCityController,
                      hintText: 'City',
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //=================================> Skill <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Skill',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
              ),
          Container(
            decoration: BoxDecoration(
              color:AppColors.colorEDF2F4,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: AppColors.primaryColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '\u2022 ',
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                              TextSpan(
                                text: 'Chess since 2020',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: (){
                              Get.back();
                            },
                            child: SvgPicture.asset(AppIcons.editIcon)
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '\u2022 ',
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                              TextSpan(
                                text: 'Math since 2021',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: (){
                              Get.back();
                            },
                            child: SvgPicture.asset(AppIcons.editIcon)
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '\u2022 ',
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                              TextSpan(
                                text: 'Piano since 2023',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: (){
                              Get.back();
                            },
                            child: SvgPicture.asset(AppIcons.editIcon)
                        )
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