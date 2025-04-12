import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class DonationScreen extends StatefulWidget {
  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final List<int> amounts = [1, 5, 10, 20, 25, 50, 100];
  int selectedAmount = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Donate",style: AppStyles.fontSize18()),
        leading:  IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18.w,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1,
                ),
                itemCount: amounts.length,
                itemBuilder: (context, index) {
                  final amount = amounts[index];
                  final isSelected = selectedAmount == amount;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmount = amount;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryColor : AppColors.colorEDF2F4,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '\$$amount',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            CustomButton(
                onTap: (){
              print('Donated: \$${selectedAmount}');
              Get.toNamed(AppRoutes.makePaymentScreen);
              },
                color: AppColors.buttonColor,
                borderColor: AppColors.buttonColor,
                textColor: Colors.white,
                text: 'Donate Now'),
            SizedBox(height: 87.h)
          ],
        ),
      ),
    );
  }
}
