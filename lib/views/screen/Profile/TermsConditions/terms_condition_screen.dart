import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_text.dart';
import '../../../../controllers/terms_conditions_controller.dart';

class TermsConditionScreen extends StatelessWidget {
  TermsConditionScreen({super.key}){
    _termsConditionsController.getTermsCondition();
  }

  final TermsConditionsController _termsConditionsController = Get.put(
      TermsConditionsController(apiService: Get.find(), sharedPreferences: Get.find()));

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
          text: _termsConditionsController.title.value.isNotEmpty
              ? _termsConditionsController.title.value
              : 'Terms & Conditions',
          fontWeight: FontWeight.bold,
          fontsize: 18.sp,
        ),),
        centerTitle: true,
      ),
      body: Obx(() => _termsConditionsController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              //===========================================> Text Section <=============================================
              Html(
                data: _termsConditionsController.content.value.isNotEmpty
                    ? _termsConditionsController.content.value
                    : '<p>No content available.</p>',
                shrinkWrap: true,
              ),
            ],
          ),
        ),
      ),),
    );
    //);
  }
}