import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AddedConneectionScreen extends StatefulWidget {
  const AddedConneectionScreen({super.key});

  @override
  State<AddedConneectionScreen> createState() => _AddedConneectionScreenState();
}

class _AddedConneectionScreenState extends State<AddedConneectionScreen> {
  TextEditingController _searchController = TextEditingController();
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: _searchController,
              contenpaddingHorizontal: 12.w,
              contenpaddingVertical: 12.h,
              hintText: "Search",
              sufixicons: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: SvgPicture.asset(
                  AppIcons.search,
                  width: 24.w,
                  height: 24.h,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: invitations.length,
              itemBuilder: (context, index) {
                final invitation = invitations[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.grey.shade300,
                              child: Icon(Icons.person, size: 40, color: Colors.white),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  invitation['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppIcons.dotIconForFamily),
                                        SizedBox(width: 4),
                                        Text(
                                          "Account ID: ${invitation['accountID']}",
                                          style: TextStyle(fontSize: 8),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 40),
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppIcons.dotIconForFamily),
                                        SizedBox(width: 4),
                                        Text(
                                          "Contribution: ${invitation['contribution']}",
                                          style: TextStyle(fontSize: 8),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.dotIconForFamily),
                                    SizedBox(width: 4),
                                    Text("Phone: 123456789",style: TextStyle(fontSize: 8),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.dotIconForFamily),
                                    SizedBox(width: 4),
                                    Text("Email: mahafujer@gmail.com",style: TextStyle(fontSize: 8),),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        CustomButton(
                          onTap: (){
                            _showCustomDeleteBottomSheet(context);
                          },
                          text: 'Remove',textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                          color: AppColors.colorD9A951,
                          borderColor: AppColors.colorD9A951,
                          textColor: AppColors.textColor,
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  Divider(thickness: .5,color: AppColors.greyColor,),
                        )
                      ],

                    ),

                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //=========================>>>>>  Log out Custom BottomSheet    <<<================================
  void _showCustomDeleteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            color: AppColors.backgroundColor,
          ),
          height: 265,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Divider(thickness: 1, color: AppColors.greyColor),
              SizedBox(height: 20.h),
              Text("Remove", style: AppStyles.h2(color: AppColors.primaryColor,fontWeight: FontWeight.w600),),
              Text("Are you sure to remove Alax Tom ??",
                style: AppStyles.h3(color: AppColors.borderColor),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor:  AppColors.colorEDF2F4,
                        side: BorderSide(
                            width: 1,
                            color: AppColors.greyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child:Text('Cancel',
                        style: AppStyles.h4(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      child: Text('Yes',
                        style:  AppStyles.h4(color: AppColors.backgroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
