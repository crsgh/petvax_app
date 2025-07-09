import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/widgets/custom_text.dart';

// RuleBase Data Model
class RuleBase {
  int? id;
  String target;
  String question;
  String yes;
  String no;

  RuleBase({
    this.id,
    required this.target,
    required this.question,
    required this.yes,
    required this.no,
  });

  factory RuleBase.fromJson(Map<String, dynamic> json) {
    return RuleBase(
      id: json['id'],
      target: json['target'],
      question: json['question'],
      yes: json['yes'],
      no: json['no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'target': target,
      'question': question,
      'yes': yes,
      'no': no,
    };
  }
}
