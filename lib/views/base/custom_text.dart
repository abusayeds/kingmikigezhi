import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
        this.maxline,
        this.textOverflow,
        this.fontName,
        this.textAlign = TextAlign.center,
        this.left = 0,
        this.right = 0,
        this.top = 0,
        this.bottom = 0,
        this.fontsize = 14,
        this.textHeight,
        this.lineHeight, // Added line height property
        this.decoration,
        this.fontWeight = FontWeight.w400,
        this.color = Colors.black,
        this.text = ""});

  final double left;
  final TextOverflow? textOverflow;
  final double right;
  final double top;
  final double bottom;
  final double fontsize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final int? maxline;
  final String? fontName;
  final double? textHeight;
  final double? lineHeight; // Added line height property
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Text(
          textAlign: textAlign,
          text,
          maxLines: maxline,
          overflow: textOverflow ?? TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            letterSpacing: 0,
            decoration: decoration,
            fontSize: fontsize,
            decorationColor: AppColors.primaryColor,
            fontWeight: fontWeight,
            color: color ?? Colors.white,
            height: lineHeight, // Added line height to TextStyle
          ).copyWith(
            // If a custom fontName is provided, override the default Poppins
            fontFamily: fontName,
          )
      ),
    );
  }
}