import 'package:e_commerce/core/logic/dependency_injection.dart';
import 'package:e_commerce/ecommerce_app.dart';
import 'package:e_commerce/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencyInjection();
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  runApp(const EcommerceApp());
}
