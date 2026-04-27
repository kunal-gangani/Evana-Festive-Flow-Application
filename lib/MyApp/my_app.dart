import 'package:evana_event_management_app/Helpers/app_theme.dart';
import 'package:evana_event_management_app/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return ScreenUtilInit(
      designSize: Size(width, height),
      minTextAdapt: true,
      builder: (context, _) {
        return GetMaterialApp(
          getPages: Routes.routes,
          initialRoute: Routes.splash,
          theme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
