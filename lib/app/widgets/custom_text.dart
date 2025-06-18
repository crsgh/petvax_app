import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final String text;
  final TextOverflow? overflow;
  final TextAlign? align;
  final int? maxLines;

  const CustomText({
    required this.text,
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.overflow,
    this.align,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: align ?? TextAlign.left,
      maxLines: maxLines ?? 1,
      style: GoogleFonts.poppins(
        fontWeight: fontWeight ?? FontWeight.w300,
        fontSize: (fontSize ?? 15).sp,
        color: color ?? Colors.black,
      ),
    );
  }
}
