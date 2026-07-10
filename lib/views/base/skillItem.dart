import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SkillRowWidget extends StatelessWidget {
  final String leadingText;
  final Color leadingTextColor;
  final Color bulletColor;
  final String editIconPath;
  final String deleteIconPath;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const SkillRowWidget({
    super.key,
    required this.leadingText,
    this.leadingTextColor = Colors.black,
    this.bulletColor = Colors.blue, // Default bullet color
    required this.editIconPath,
    required this.deleteIconPath,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '\u2022 ',
                  style: TextStyle(color: bulletColor),
                ),
                TextSpan(
                  text: leadingText,
                  style: TextStyle(color: leadingTextColor),
                ),
              ],
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: onEditTap,
                child: SvgPicture.asset(editIconPath),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: onDeleteTap,
                child: SvgPicture.asset(deleteIconPath),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
