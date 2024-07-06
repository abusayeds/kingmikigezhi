import 'package:flutter/material.dart';

import '../../base/bottom_menu..dart';
import '../../base/custom_text.dart';

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(2),
      body: Center(
        child: CustomText(
          text: 'This is Calender Screen',
        ),
      ),
    );
  }
}
