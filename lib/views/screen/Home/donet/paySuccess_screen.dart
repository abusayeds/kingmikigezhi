import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:get/get.dart';

class PaymentSuccessScreen extends StatefulWidget {
  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  int _countdown = 5;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    // _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   setState(() {
    //     if (_countdown > 0) {
    //       _countdown--;
    //     } else {
    //       _timer.cancel();
    //       Get.toNamed(AppRoutes.suggestionDonationPage);
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryColor,
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            // Payment Success Text
            const Text(
              'Payment Successful',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            // Thank you message
            const Text(
              'Thank you for your support !',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            // Countdown
            Text(
              '$_countdown' + 's',
              style:  TextStyle(fontSize: 18, color: Colors.black87,fontWeight:FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
