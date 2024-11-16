import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_text.dart';

class AboutusScreen extends StatelessWidget {
  AboutusScreen({super.key});
  // final AboutUsController _aboutUsController = Get.put(AboutUsController());

  @override
  Widget build(BuildContext context) {
    //_aboutUsController.getAboutUs();
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
        title: CustomText(
          text: 'About Us',
          fontWeight: FontWeight.bold,
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: /*Obx(
            () => _aboutUsController.isLoading.value
            ? const CustomCircleLoader()
            : */
          SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
          child: Column(
            children: [
              //===========================================> Text Section <=============================================
              Text('Lorem ipsum dolor sit amet consectetur. Ultrices id feugiat venenatis habitant mattis viverra elementum purus volutpat. Lacus eu molestie pulvinar rhoncus integer proin elementum. Pretium sit fringilla massa tristique aenean commodo leo. Aliquet viverra amet sit porta elementum et pellentesque posuere. Ullamcorper viverra tortor lobortis viverra auctor egestas. Nulla condimentum ac metus quam turpis gravida ut velit. Porta justo lacus consequat sed platea. Ut dui massa quam elit faucibus consectetur sapien aenean auctor. Felis ipsum amet justo in. Netus amet in egestas sed auctor lorem. Justo ullamcorper velit habitasse lorem eu arcu. Non enim a elit urna eget nibh quisque donec condimentum. Elit ut pellentesque neque in quis at viverra. Nisl etiam tristique odio eget convallis.',
                maxLines: 20,
                textAlign: TextAlign.justify,
                style: AppStyles.fontSize14(color: AppColors.color20353F),
              )
              /* Obx(
                      () => Html(
                    shrinkWrap: true,
                    data: _aboutUsController.content.value,
                  ),
                ),*/
            ],
          ),
        ),
      ),
    );
    // );
  }
}
