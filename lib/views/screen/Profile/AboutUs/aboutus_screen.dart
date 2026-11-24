import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/custom_text.dart';
import '../../../base/skeletons.dart';
import '../../../../controllers/about_us_controller.dart';

class AboutusScreen extends StatelessWidget {
  AboutusScreen({super.key}){
    // initialize controller and fetch content
    _aboutUsController.getAboutUs();
  }
  final AboutUsController _aboutUsController = Get.put(AboutUsController(apiService: Get.find(), sharedPreferences: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      //===========================================> AppBar Section <=============================================
      appBar: AppBar(
        leading:  IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: Obx(() => CustomText(
          text: _aboutUsController.title.value.isNotEmpty
              ? _aboutUsController.title.value
              : 'About Us',
          fontWeight: FontWeight.bold,
          fontsize: 18.sp,
        ),),
        centerTitle: true,
      ),
      body: Obx(
            () => _aboutUsController.isLoading.value
            ? const SimplePageSkeleton()
            : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
          child: Column(
            children: [
              //===========================================> Text Section <=============================================
              Html(
                shrinkWrap: true,
                data: _aboutUsController.content.value.isNotEmpty
                    ? _aboutUsController.content.value
                    : '<p>No content available.</p>',
              ),
            ],
          ),
        ),
      ),
      ),
    );
    // );
  }
}
