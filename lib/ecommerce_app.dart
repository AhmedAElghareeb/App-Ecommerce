import 'package:e_commerce/core/themes/colors.dart';
import 'package:e_commerce/features/home/ui/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Ecommerce',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.mainColor,
          platform: TargetPlatform.iOS,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
          )
        ),
        home: const HomeView(),
      ),
    );
  }
}