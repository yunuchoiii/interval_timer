import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'page/timer_page.dart';
import 'service/timer_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimerService(),
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        child: MaterialApp(
          title: 'Interval Timer Pro',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
            ).copyWith(
              background: const Color.fromARGB(255, 51, 51, 50),
            ),
          ),
          home: const TimerPage(),
        ),
      ),
    );
  }
}
