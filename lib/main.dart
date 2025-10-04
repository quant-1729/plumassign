import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widgets/Wrapper.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812), // iPhone X dimensions
      builder: (context, child) {
        return MaterialApp(
          title: 'PlumAssign',
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
        );
      },
    );
  }
}



