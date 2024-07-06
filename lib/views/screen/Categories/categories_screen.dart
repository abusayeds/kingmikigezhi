import 'package:flutter/material.dart';

import '../../base/bottom_menu..dart';
import '../../base/custom_text.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(1),
      body: Center(
        child: CustomText(
          text: 'This is Categories Screen',
        ),
      ),
    );
  }
}
