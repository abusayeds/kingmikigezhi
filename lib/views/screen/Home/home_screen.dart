import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import '../../base/bottom_menu..dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomMenu(0),
      body: Center(
        child: CustomText(
          text: 'This is Home Screen',
        ),
      ),
    );
  }
}
