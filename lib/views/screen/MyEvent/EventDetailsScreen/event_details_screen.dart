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

class EventDetailsScreen extends StatefulWidget {
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final List<String> _agesList = ['Age up to 10 years old', 'Age up to 15 years old'];
  String? _selectedAge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
        leading:  IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Event Details',style: AppStyles.fontSize18(fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      //=======================> Body Section <============================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //=======================> Event Image Section <============================
              Stack(
                children: [
                  Image.asset('assets/images/upcoming.png'),
                  Positioned(
                    right: -5.w,
                    top: 5.h,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        border: Border.all(width: 1.w, color: Colors.white),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        child: CustomText(
                          text: '20 Feb',
                          fontsize: 10.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    'Piano Star Event',
                    style: AppStyles.fontSize16(fontWeight: FontWeight.w600)
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.w,height: 40.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.colorEDF2F4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: (){},
                              child: SvgPicture.asset(AppIcons.editIcon)),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        width: 40.w,height: 40.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.colorEDF2F4,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.done,color: AppColors.primaryColor),
                          onPressed: () {
                            // Edit action
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40.w,height: 40.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.colorEDF2F4,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: (){},
                          child: SvgPicture.asset(AppIcons.share)),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      //left side
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: 16.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.dotIconForFamily),
                                    SizedBox(width: 5),
                                    Text('Program', style: TextStyle(fontWeight: FontWeight.bold,)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text('Piano', style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                            //type
                            SizedBox(height: 16.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.dotIconForFamily),
                                    SizedBox(width: 5.w),
                                    Text('Type', style: TextStyle(fontWeight: FontWeight.bold,)),
                                  ],
                                ),
                                SizedBox(height: 5.w),
                                Text('Onsite Event', style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.dotIconForFamily),
                                    SizedBox(width: 5),
                                    Text('Location', style: TextStyle(fontWeight: FontWeight.bold,)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text('Dhaka Bangladesh', style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.dotIconForFamily),
                                    SizedBox(width: 5.w),
                                    Text('Deadline', style: TextStyle(fontWeight: FontWeight.bold,)),

                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Text('1-5-2025', style: TextStyle(color: Colors.grey.shade600)),
                                    SizedBox(width: 5.w),
                                    Text('7:00 PM', style: TextStyle(color: Colors.grey.shade600)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.dotIconForFamily),
                                    SizedBox(width: 5),
                                    Text('Final Deadline', style: TextStyle(fontWeight: FontWeight.bold,)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text('1-5-2025', style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //right side
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: 16.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.dotIconForFamily),
                                    SizedBox(width: 5.w),
                                    Text('Competition Level',
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Text(
                                      '7.00 AM',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.dotIconForFamily),
                                    SizedBox(width: 5.w),
                                    Text('Registration Open',
                                        style: TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Text(
                                      '1-1-2025',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      '7.00 AM',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.dotIconForFamily),
                                    SizedBox(width: 5.w),
                                    Text('Repeat Function',
                                        style: TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Text('Never', style: TextStyle(
                                    color: Colors.grey.shade600,
                                  )),
                              ],
                            ),
                          //cost
                            SizedBox(height: 16.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Empty space for alignment
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppIcons.dotIconForFamily),
                                        SizedBox(width: 5.w),
                                        Text(
                                          'Cost',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(4.r),
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
                                SizedBox(height: 5.h),
                                Text(
                                  '\$100',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            //late  fee
                            SizedBox(height: 16.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Empty space for alignment
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppIcons.dotIconForFamily),
                                        SizedBox(width: 5.w),
                                        Text(
                                          'Cost',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                SizedBox(height: 5.h),
                                Text(
                                  '\$100',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),

                          ],
                            ),)
                          ],


                  )
                ],
              ),


              //=======================> description Event Section <============================
              SizedBox(height: 16.h),

               Text(AppStrings.description,style: AppStyles.fontSize16(fontWeight: FontWeight.w600)),
               SizedBox(height: 8.h),
              Text( 'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
                maxLines: 20,
                textAlign: TextAlign.start,
                style: AppStyles.fontSize14(color: AppColors.color414141),
              ),
              SizedBox(height: 16.w),
              // Note
              Text(AppStrings.note,style: AppStyles.fontSize16(fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Text( 'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
                maxLines: 20,
                textAlign: TextAlign.start,
                style: AppStyles.fontSize14(color: AppColors.color414141),
              ),
             SizedBox(height: 16.h),
              //=======================> Age up to 10 years old Section <============================
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  // labelText: 'Select',
                  border: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    //focusColor:  AppColors.primaryColor,
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    isExpanded: true,
                    value: _selectedAge,style: AppStyles.fontSize18(color: AppColors.blackColor,fontWeight: FontWeight.w600),
                    hint: CustomText(text: 'Select Ages', fontsize: 14.sp),
                    icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,),
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
                      SvgPicture.asset(AppIcons.myEventIcon,color: AppColors.primaryColor,),
                      SizedBox(width: 8.w),
                        Text('Preliminary',style: AppStyles.fontSize16()),
                    ],
                  ),
                  SizedBox(height: 15.h),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 5.w),
                              Text('Deadline: ', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Text('1-1-2024',style: TextStyle(color: AppColors.color414141)),
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 5.w),
                              Text('Cost: ', style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text('\$100',style: TextStyle(color: AppColors.color414141)),
                              SizedBox(width: 10.w),
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
                          Text('Type: ', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('Onsite Event',style: TextStyle(color: AppColors.color414141)),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(AppIcons.dotIconForFamily),
                          SizedBox(width: 5.w),
                          Text('Description: ',style: AppStyles.fontSize10(fontWeight: FontWeight.w600)),
                          Expanded(
                            child: Text(
                              'The point of using Lorem Ipsum is that it has a more or less normal',style: TextStyle(color: AppColors.color414141)),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Divider(thickness: 1,color: Colors.grey),
              // Semi Final section
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.myEventIcon,color: AppColors.primaryColor,),
                      SizedBox(width: 8.w),
                      Text('Semi Final', style: TextStyle(fontSize: 16.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 5),
                              Text('Deadline: ', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Text('1-1-2024'),
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 5),
                              Text('Cost: ', style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text('\$100'),
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
                          Text('Type: ', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('Onsite Event',style: TextStyle(color: AppColors.color414141)),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(AppIcons.dotIconForFamily),
                          SizedBox(width: 5),
                          Text('Description: ', style: TextStyle(fontWeight: FontWeight.w600)),
                          Expanded(
                            child: Text(
                              'The point of using Lorem Ipsum is that it has a more or less normal', style: TextStyle(color: AppColors.color414141)),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Divider(thickness: 1,color: Colors.grey),
              // Final section
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.myEventIcon,color: AppColors.primaryColor,),
                      SizedBox(width: 8.w),
                      Text('Final',style: AppStyles.fontSize16()
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 5.w),
                              Text('Deadline: ', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Text('1-1-2024'),
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 5.w),
                              Text('Cost: ', style: TextStyle(fontWeight: FontWeight.w600)),
                              Text('\$100'),
                              SizedBox(width: 10),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 10.sp,
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
                          Text('Type: ', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('Onsite Event',style: TextStyle(color: AppColors.color414141)),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(AppIcons.dotIconForFamily),
                          SizedBox(width: 5),
                          Text('Description: ', style: TextStyle(fontWeight: FontWeight.w600)),
                          Expanded(
                            child: Text(
                              'The point of using Lorem Ipsum is that it has a more or less normal', style: TextStyle(color: AppColors.color414141)),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Divider(thickness: 1,color: Colors.grey),
              //history
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // History Section
                    Text('Preliminary',style: AppStyles.fontSize16()),
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
                          Text('2021 - 1st place winner',style: TextStyle(color: AppColors.color414141)),
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
                          Text('2022 - 2nd place winner',style: TextStyle(color: AppColors.color414141)),
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
                          Text('2023 - 1st place winner',style: TextStyle(color: AppColors.color414141)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(thickness: 1,color: Colors.grey),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Estimation Total Cost: 400',
                          style: AppStyles.fontSize14(color: AppColors.color414141,fontWeight: FontWeight.w600)),
                          SizedBox(width: 8.w),
                          SvgPicture.asset(AppIcons.editIcon),
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
                          Text('Created By',style: AppStyles.fontSize14(color: AppColors.color414141,fontWeight: FontWeight.w600)),
                          SizedBox(width: 8.w),
                          CircleAvatar(
                            radius: 30.r,
                            backgroundImage: NetworkImage('https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'), // Placeholder image
                          ),
                        ],
                      ),
                      Text(
                        'Created at\n1-1-2022',
                        textAlign: TextAlign.right,
                        style: AppStyles.fontSize14(color: AppColors.color414141,fontWeight: FontWeight.w600),
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
                          backgroundImage: NetworkImage('https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'), // Placeholder image
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(-15, 0),
                        child: CircleAvatar(
                          radius: 25.r,
                          backgroundImage: NetworkImage('https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400'), // Placeholder image
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(-30, 0),
                        child: CircleAvatar(
                          radius: 25.r,
                          backgroundImage: NetworkImage('https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'), // Placeholder image
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(-50, 0),
                        child: CircleAvatar(
                          radius: 25.r,
                          backgroundImage: NetworkImage('https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?auto=compress&cs=tinysrgb&w=400'), // Placeholder image
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
                          width: 166.w,
                          child: CustomButton(
                            onTap: () {},
                            text: "Edit & Verify",
                            color: AppColors.fillColor,
                            textColor: Colors.black,
                          )),
                      SizedBox(
                          width: 166.w,
                          child: CustomButton(
                            onTap: () {
                              Get.toNamed(AppRoutes.appliedSearchEventListScreen);
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
                    onTap: (){},
                    text: 'Delete'
                )
                ],
              )


            ],
          ),
        ),
      ),
    );
  }
}
