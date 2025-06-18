import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF2F42A8);
  static const Color primaryDark = Color(0xFF1E2A85);
  static const Color primaryLight = Color(0xFF5062C1);

  // Accent
  static const Color accent = Color(0xFFA82F6D);

  // Neutrals
  static const Color background = Color(0xFFF4F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF4A4A4A);
  static const Color border = Color(0xFFD0D4E2);

  // Gradients
  static const List<Color> primaryGradient = [primary, primaryLight];

  // Status Colors
  static const Color pending = Color(0xFFFFA726); // Orange
  static const Color cancelled = Color(0xFF9E9E9E); // Grey
  static const Color declined = Color(0xFFEF5350); // Red-ish
  static const Color completed = Color(0xFF42A5F5); // Blue
  static const Color confirmed = Color(0xFF66BB6A); // Green

  // Feedback Colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color error = Color(0xFFE53935); // Red
}
