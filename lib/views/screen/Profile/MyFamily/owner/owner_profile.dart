import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OwnerMemberAddScreen extends StatefulWidget {
  const OwnerMemberAddScreen({super.key});

  @override
  State<OwnerMemberAddScreen> createState() =>
      _OwnerMemberAddScreenState();
}

class _OwnerMemberAddScreenState extends State<OwnerMemberAddScreen> {

  final List<Map<String, String>> familyMembers = [
    {'name': 'Kiefer', 'relation': 'Spouse', 'image': 'assets/images/show.png'},
    {'name': 'John', 'relation': 'Father', 'image': 'assets/images/shoot.png'},
    {'name': 'Emily', 'relation': 'Daughter', 'image': 'assets/images/song.png'},
  ];
  bool shouldRemove = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top action button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 30.h,
                    width: 30.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: AppColors.buttonColor,
                    ),
                    child: InkWell(
                        onTap: (){
                          Get.toNamed(AppRoutes.createMemberProfileScreen);
                        },
                        child: Icon(Icons.add, color: Colors.white)),
                  ),
                ),
              ],
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.colorEDF2F4,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color:AppColors.primaryColor, width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: AppColors.greyColor),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search,color: AppColors.primaryColor),
                    ),
                  ),
                ),
              ),
            ),
            // Family members list
            ListView.builder(
              shrinkWrap: true, // Important to fit inside SingleChildScrollView
              physics: NeverScrollableScrollPhysics(), // Disable inner scroll
              itemCount: familyMembers.length,
              itemBuilder: (context, index) {
                final member = familyMembers[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Dismissible(
                    key: Key(member['name']!),
                    background: Container(
                      decoration: BoxDecoration(
                        color: AppColors.colorD9A951,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {

                      final bool? result = await _showCustomBottomSheet(context, member['name']!);
                      shouldRemove = result ?? false;
                      return shouldRemove;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.colorEDF2F4,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.black12, width: 1.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(member['image']!),
                          radius: 25,
                        ),
                        title: Text(member['name']!,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 4),
                                Text(member['relation']!,style: TextStyle(fontSize: 10),),
                              ],
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 4),
                                Text('Email: Abc@gmail.com',style: TextStyle(fontSize: 10),),
                              ],
                            ),
                          ],
                        ),
                        trailing: InkWell(
                          onTap: () {
                            _showViewModeBottomSheet(context);
                          },
                          child: Icon(Icons.more_horiz, color: AppColors.greyColor),
                        ),
                      ),
                    ),


                  )

                );
              },
            ),
          ],
        ),
      ),
    );
  }
  //=========================>>>>> Delete Custom BottomSheet    <<<================================
  Future<bool?> _showCustomBottomSheet(BuildContext context, String memberName) {
    return showModalBottomSheet<bool>(
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
              Text("Delete", style: AppStyles.h2(color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
              Text("Are you sure to delete this?",
                style: AppStyles.h3(color: AppColors.borderColor),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Close the bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor: AppColors.colorEDF2F4,
                        side: BorderSide(
                            width: 1,
                            color: AppColors.greyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text('Cancel',
                        style: AppStyles.h4(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      child: Text('Yes',
                        style: AppStyles.h4(color: AppColors.backgroundColor),
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

  //profile view
  void _showViewModeBottomSheet(BuildContext context) {
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
              Text(
                "What you want?",
                style: AppStyles.h3(color: AppColors.borderColor),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.ownerProfileDetailsScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor: AppColors.primaryColor,
                        side: BorderSide(width: 1, color: AppColors.greyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcons.eyeIcon, width: 24.w,height:24.h,color: AppColors.backgroundColor),
                          SizedBox(width: 4.w),
                          Text(
                            'View Profile',
                            style: AppStyles.h4(color: AppColors.backgroundColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcons.delete, width: 24.w,height:24.h),
                          Text(
                            'Delete Profile',
                            style: AppStyles.h4(color: AppColors.backgroundColor),
                          ),
                        ],
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
