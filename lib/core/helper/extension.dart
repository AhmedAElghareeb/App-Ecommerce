import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension Navigation on BuildContext {
  Future<dynamic> push(Widget page) {
    return Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}

SizedBox verticalSpace(double height) => SizedBox(height: height.h,);
SizedBox horizontalSpace(double width) => SizedBox(width: width.w,);
