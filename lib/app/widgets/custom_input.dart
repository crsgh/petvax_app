import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatelessWidget {
  final IconData? icon;
  final String placeholder;
  final String value;
  final Function(String) onChanged;
  final bool isPassword;
  final bool showPassword;
  final VoidCallback? onTogglePassword;
  final TextInputType keyboardType;
  final double? marginBottom;

  const CustomInputField({
    super.key,
    this.icon,
    required this.placeholder,
    required this.value,
    required this.onChanged,
    this.isPassword = false,
    this.showPassword = false,
    this.onTogglePassword,
    this.keyboardType = TextInputType.text,
    this.marginBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom ?? 24.h),
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        obscureText: isPassword ? !showPassword : false,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.grey[800]),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey[400],
            fontSize: 16.sp,
          ),
          prefixIcon:
              icon != null
                  ? Container(
                    width: 48.w,
                    height: 48.h,
                    alignment: Alignment.center,
                    child: Icon(icon, color: Colors.grey[400], size: 20.sp),
                  )
                  : null,
          suffixIcon:
              isPassword
                  ? IconButton(
                    onPressed: onTogglePassword,
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[400],
                      size: 20.sp,
                    ),
                  )
                  : null,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: icon == null ? 16.w : 48.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }
}
