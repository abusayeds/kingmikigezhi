import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/style.dart';
import '../../../../services/api_service.dart';
import '../../../../utils/api_constants.dart';

class SuggestionScreen extends StatelessWidget {
  final TextEditingController _describtionCTRL = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18.w,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w,vertical: 16.h),
        child: Column(
          children: [
           Expanded(
             child: CustomTextField(
               controller: _describtionCTRL,
               hintText: 'Share your suggestion',
               maxLines: 30,
             ),
           ),
            SizedBox(height: 59.h),
           // Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.fillColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: const BorderSide(color: Color(0xFFB58974)), // Outline color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppStyles.fontSize16(color: AppColors.blackColor,fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final desc = _describtionCTRL.text.trim();
                      if (desc.isEmpty) {
                        Get.snackbar('Error', 'Please enter suggestion',
                            snackPosition: SnackPosition.BOTTOM);
                        return;
                      }

                      // show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        final api = Get.find<ApiService>();
                        final res = await api.post(ApiConstants.createFeedback,
                            body: {'message': desc});

                        // close loading
                        Navigator.of(context).pop();

                        final message = (res != null && res['message'] != null)
                            ? res['message'].toString()
                            : 'Feedback sent successfully';

                        Get.snackbar('Success', message,
                            snackPosition: SnackPosition.BOTTOM);

                        _describtionCTRL.clear();

                        // Give user time to see the snackbar before closing the screen
                        await Future.delayed(const Duration(seconds: 2));
                        Get.back();
                      } catch (e) {
                        // close loading
                        Navigator.of(context).pop();
                        Get.snackbar('Error', e.toString(),
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF815B48),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child:  Text(
                      'Commit',
                      style: AppStyles.fontSize16(color: AppColors.white,fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
