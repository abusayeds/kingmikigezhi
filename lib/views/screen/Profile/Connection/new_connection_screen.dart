import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewInvitationScreen extends StatefulWidget {
  const NewInvitationScreen({super.key});

  @override
  State<NewInvitationScreen> createState() => _NewInvitationScreenState();
}

class _NewInvitationScreenState extends State<NewInvitationScreen> {
  final List<Map<String, dynamic>> invitations = [
    {
      "name": "Alax Tom",
      "accountID": 2010,
      "contribution": 100,
    },
    {
      "name": "Mahafujer",
      "accountID": 2011,
      "contribution": 150,
    },
    {
      "name": "Rahman MunnA",
      "accountID": 2012,
      "contribution": 200,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.all(12.r),
          itemCount: invitations.length,
          itemBuilder: (context, index) {
            final invitation = invitations[index];
            return Container(
              padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 45.r,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alax Tom', style: AppStyles.fontSize16(fontWeight: FontWeight.w600,color: AppColors.color414141),),
                          SizedBox(height: 8.h,),
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 4),
                              Text("Account ID: ${invitation['accountID']}",
                                style: AppStyles.fontSize10(color: AppColors.color414141),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h,),
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 4),
                              Text("Contribution: ${invitation['contribution']}",
                                style: AppStyles.fontSize10(color: AppColors.color414141),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                          child:CustomButton(
                            onTap: (){},
                            text: 'Ignore',textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                            color: AppColors.fillColor,
                            borderColor: AppColors.buttonA47059,
                            textColor: AppColors.blackColor,
                          )
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                          child:CustomButton(
                            onTap: (){},
                            text: 'Accept',textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                            color: AppColors.buttonA47059,
                            borderColor: AppColors.buttonA47059,
                            textColor: AppColors.textColor,
                          )
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child:  Divider(thickness: .5,color: AppColors.greyColor,),
                  )


                ],

              ),


            );
          },
        ),
        if (invitations.isNotEmpty)
        Positioned(
          bottom: 15,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                Expanded(
                    child:CustomButton(
                      onTap: (){},
                      text: 'Ignore All',textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                      color: AppColors.fillColor,
                      borderColor: AppColors.buttonColor,
                      textColor: AppColors.blackColor,
                    )
                ),
                SizedBox(width: 10.w),
                Expanded(
                    child:CustomButton(
                      onTap: (){},
                      text: 'Accept All',textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                      color: AppColors.buttonColor,
                      borderColor: AppColors.buttonA47059,
                      textColor: AppColors.textColor,
                    )
                ),
              ],
            ),
          ),
        ),
      ],
      ),

    );
  }
}
