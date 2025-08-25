import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

class EventDetailsScreen extends StatefulWidget {
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final List<String> _agesList = [
    'Age up to 10 years old',
    'Age up to 15 years old'
  ];
  String? _selectedAge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        title: Text('Event Details',
            style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor)),
        centerTitle: true,
      ),
      //=======================> Body Section <============================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //=======================> Event Image Section <============================
              Stack(
                children: [
                  Container(
                    height: 180.h,
                    width: 345.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.transparent,
                      image: const DecorationImage(
                        // image: NetworkImage('https://static.gltjp.com/glt/data/directory/13000/12058/20210822_040201_6908e9ec_w1920.webp'),
                        image: AssetImage('assets/images/concert.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Piano Star Event',
                      style: AppStyles.headTitle()
                          .copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black, // Color of the underline
                        decorationThickness: 1.0, // Thickness of the underline
                      )),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.colorEDF2F4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () {},
                              child: Center(child: SvgPicture.asset(AppIcons.editIcon))),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.colorEDF2F4,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Center(
                              child: Icon(
                                size: 20,
                                Icons.done,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            onPressed: () {
                              // Edit action
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.colorEDF2F4,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(AppIcons.share)),
                    ),
                  ),
                ],
              ),
              Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),
                            _buildInfoRow('Program', 'Piano'),
                            SizedBox(height: 17.h),
                            _buildInfoRow('Type', 'Onsite Event'),
                            SizedBox(height: 17.h),
                            _buildInfoRow('Location', 'Dhaka Bangladesh'),
                            SizedBox(height: 18.h),
                            _buildInfoRowWithDateTime('Deadline', '1-5-2025', '7:00 PM'),
                            SizedBox(height: 18.h),
                            _buildInfoRow('Final Deadline', '1-5-2025'),
                          ],
                        ),
                      ),
                      // Right Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),
                            _buildInfoRow('Competition Level', 'Primary Round'),
                            SizedBox(height: 17.h),
                            _buildInfoRowWithDateTime('Registration Open', '1-1-2025', '7.00 AM'),
                            SizedBox(height: 17.h),
                            _buildInfoRow('Repeat Function', 'Never'),
                            SizedBox(height: 18.h),
                            _buildInfoRowWithCheck('Cost', '\$100'),
                            SizedBox(height: 18.h),
                            _buildInfoRowWithCheck('Late Fee', '\$100'),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),

              //=======================> Description Event Section <============================
              SizedBox(height: 24.h),
              Text(AppStrings.description,
                  style: AppStyles.fieldTitle()),
              SizedBox(height: 8.h),
              Text(
                'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
                maxLines: 20,
                textAlign: TextAlign.start,
                style: AppStyles.fieldContent(
                  color: AppColors.color414141,
                ),
              ),
              SizedBox(height: 16.w),

              // Note
              Text(AppStrings.note,
                  style: AppStyles.fieldTitle()),
              SizedBox(height: 8.h),
              Text(
                'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
                maxLines: 20,
                textAlign: TextAlign.start,
                style: AppStyles.fieldContent(
                  color: AppColors.color414141,
                ),
              ),
              SizedBox(height: 16.h),
              //=======================> Age up to 10 years old Section <============================
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  // labelText: 'Select',
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.buttonColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.buttonColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.buttonColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    padding: EdgeInsets.symmetric(vertical: 5.w),
                    // focusColor:  AppColors.primaryColor,
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    isExpanded: true,
                    value: _selectedAge,
                    style: AppStyles.fontSize18(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w500),
                    hint: CustomText(text: 'Select Ages', fontsize: 14.sp),
                    icon: SvgPicture.asset(
                      AppIcons.downArrowIcon,
                      width: 16.w,
                      color: AppColors.blackColor,
                    ),
                    items: _agesList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedAge = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Preliminary section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.myEventIcon,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 8.w),
                      Text('Preliminary',
                          style: AppStyles.fieldTitle()),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding:  EdgeInsets.only(left: 7.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 5.w),
                                Text('Deadline: ',
                                    style: AppStyles.fontSize12(
                                        fontWeight: FontWeight.w600)),
                                Text( ' 1-1-2024', style: AppStyles.fontSize12()),
                              ],
                            ),

                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 5),
                                Text('Cost: ',
                                    style: AppStyles.fontSize12(
                                        fontWeight: FontWeight.w600)),
                                Text('\$100', style: AppStyles.fontSize12()),
                                SizedBox(width: 10),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 10,
                              ),
                              padding: EdgeInsets.all(4),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            SvgPicture.asset(AppIcons.dotIconForFamily),
                            SizedBox(width: 5),
                            Text('Type: ',
                                style: AppStyles.fontSize12(
                                    fontWeight: FontWeight.w600)),
                            Text('Onsite Event', style: AppStyles.fontSize12()),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(AppIcons.dotIconForFamily),
                            SizedBox(width: 5),
                            Text('Description: ',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            Expanded(
                              child: Text(
                                  'The point of using Lorem Ipsum is that it has a more or less normal',
                                  style: AppStyles.fontSize12()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(thickness: 1, color: Colors.grey),
              // Semi Final section
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.myEventIcon,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 8.w),
                      Text('Semi Final',
                          style: AppStyles.fieldTitle()),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding:  EdgeInsets.only(left: 7.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 5.w),
                                Text('Deadline: ',
                                    style: AppStyles.fontSize12(
                                        fontWeight: FontWeight.w600)),
                                Text( ' 1-1-2024', style: AppStyles.fontSize12()),
                              ],
                            ),

                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 5),
                                Text('Cost: ',
                                    style: AppStyles.fontSize12(
                                        fontWeight: FontWeight.w600)),
                                Text('\$100', style: AppStyles.fontSize12()),
                                SizedBox(width: 10),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 10,
                              ),
                              padding: EdgeInsets.all(4),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            SvgPicture.asset(AppIcons.dotIconForFamily),
                            SizedBox(width: 5.w),
                            Text('Type: ',
                                style: AppStyles.fontSize12(
                                    fontWeight: FontWeight.w600)),
                            Text('Onsite Event', style: AppStyles.fontSize12()),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(AppIcons.dotIconForFamily),
                            SizedBox(width: 5.w),
                            Text('Description: ',
                                style: TextStyle(fontWeight: FontWeight.w500,)),
                            Expanded(
                              child: Text(
                                  'The point of using Lorem Ipsum is that it has a more or less normal',
                                  style: AppStyles.fontSize12()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(thickness: 1, color: Colors.grey),
              // Final section
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.myEventIcon,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 8.w),
                      Text('Final',
                          style: AppStyles.fontSize12(
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding:  EdgeInsets.only(left: 7.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 5.w),
                                Text('Deadline: ',
                                    style: AppStyles.fontSize12(
                                        fontWeight: FontWeight.w600)),
                                Text( ' 1-1-2024', style: AppStyles.fontSize12()),
                              ],
                            ),

                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 5),
                                Text('Cost: ',
                                    style: AppStyles.fontSize12(
                                        fontWeight: FontWeight.w600)),
                                Text('\$100', style: AppStyles.fontSize12()),
                                SizedBox(width: 10),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 10,
                              ),
                              padding: EdgeInsets.all(4),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            SvgPicture.asset(AppIcons.dotIconForFamily),
                            SizedBox(width: 5),
                            Text('Type: ',
                                style: AppStyles.fontSize12(
                                    fontWeight: FontWeight.w600)),
                            Text('Onsite Event', style: AppStyles.fontSize12()),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(AppIcons.dotIconForFamily),
                            SizedBox(width: 5),
                            Text('Description: ',
                                style: TextStyle(fontWeight: FontWeight.w500,)),
                            Expanded(
                              child: Text(
                                  'The point of using Lorem Ipsum is that it has a more or less normal',
                                  style: AppStyles.fontSize12()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(thickness: 1, color: Colors.grey),
              //history
              Padding(
                padding:  EdgeInsets.only(left: 7.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Text('Preliminary',
                        style: AppStyles.fontSize12(fontWeight: FontWeight.w600)),
                    SizedBox(height: 8.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text('2021 - 1st place winner',
                                style: TextStyle(color: AppColors.color414141)),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text('2022 - 2nd place winner',
                                style: TextStyle(color: AppColors.color414141)),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text('2023 - 1st place winner',
                                style: TextStyle(color: AppColors.color414141)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    const Divider(thickness: 1, color: Colors.grey),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.w),
                        decoration: BoxDecoration(
                          color: AppColors.fillColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Estimation Total Cost: 400',
                                style: AppStyles.fontSize14(
                                  color: AppColors.color414141,
                                  fontWeight: FontWeight.w500,
                                ).copyWith(
                                  fontSize: 10.sp,
                                )),
                            SizedBox(width: 8.w),
                            SvgPicture.asset(
                              AppIcons.editIcon,
                              height: 12.w,
                              width: 12.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // Created By Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('Created By',
                                style: AppStyles.fontSize14(
                                    color: AppColors.color414141,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(width: 8.w),
                            CircleAvatar(
                              radius: 30.r,
                              backgroundImage: NetworkImage(
                                  'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'), // Placeholder image
                            ),
                          ],
                        ),
                        Text(
                          'Created at\n1-1-2022',
                          textAlign: TextAlign.right,
                          style: AppStyles.fontSize14(
                              color: AppColors.color414141,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),

                    // User Contribution Section
                    Text(
                      'Has already contribute or verification by (10) Users',
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Transform.translate(
                          offset: Offset(0, 0),
                          child: CircleAvatar(
                            radius: 25.r,
                            backgroundImage: NetworkImage(
                                'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'), // Placeholder image
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(-15, 0),
                          child: CircleAvatar(
                            radius: 25.r,
                            backgroundImage: NetworkImage(
                                'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400'), // Placeholder image
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(-30, 0),
                          child: CircleAvatar(
                            radius: 25.r,
                            backgroundImage: NetworkImage(
                                'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'), // Placeholder image
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(-50, 0),
                          child: CircleAvatar(
                            radius: 25.r,
                            backgroundImage: NetworkImage(
                                'https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?auto=compress&cs=tinysrgb&w=400'), // Placeholder image
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    // Latest active info
                    Text(
                      'Latest active 3 days ago',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.color414141,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 164.w,
                            child: CustomButton(
                              borderColor: AppColors.buttonColor,
                              onTap: () {},
                              text: "Edit & Verify",
                              color: AppColors.fillColor,
                              textColor: Colors.black,
                            )),
                        SizedBox(
                            width: 164.w,
                            child: CustomButton(
                              onTap: () {
                                Get.toNamed(
                                    AppRoutes.appliedSearchEventListScreen);
                              },
                              text: "Apply",
                              textColor: Colors.white,
                              color: AppColors.buttonColor,
                            )),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Delete Button
                    CustomButton(
                        color: AppColors.colorD9A951,
                        borderColor: AppColors.colorD9A951,
                        textColor: AppColors.white,
                        onTap: () {},
                        text: 'Delete')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  // Helper methods to ensure consistent alignment
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Column(
         children: [
           SizedBox(
             height: 4.h,
           ),
           SvgPicture.asset(
             AppIcons.dotIconForFamily,
             height: 12.h,
             width: 12.h,
           )
         ],
       )
        ,
        SizedBox(width: 5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.fieldTitle(),
              ),
              SizedBox(height: 5.h),
              Text(
                value,
                style: AppStyles.fieldContent(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithDateTime(String label, String date, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(
              height: 4.h,
            ),
            SvgPicture.asset(
              AppIcons.dotIconForFamily,
              height: 12.h,
              width: 12.h,
            )
          ],
        )
        ,
        SizedBox(width: 5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.fieldTitle(),
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Text(
                    date,
                    style: AppStyles.fieldContent(color: Colors.grey.shade600),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    time,
                    style: AppStyles.fieldContent(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithCheck(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 4.h,
                ),
                SvgPicture.asset(
                  AppIcons.dotIconForFamily,
                  height: 12.h,
                  width: 12.h,
                )
              ],
            )
            ,
            SizedBox(width: 5.w),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: AppStyles.fieldTitle(),
                  ),
                  Container(
                    height: 20.h,
                    width: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.only(left: 17.w), // 12.w (icon) + 5.w (spacing)
          child: Text(
            value,
            style: AppStyles.fieldContent(color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }
}
