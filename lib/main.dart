import 'dart:io';
import 'package:bmteacher/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = new CustomHttpOverrides();
  runApp(BmTeacherApp());
}

class BmTeacherApp extends StatelessWidget {
  BmTeacherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
        designSize: const Size(375, 794),
        builder: (ctx, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            ));
  }
}

class CustomHttpOverrides extends HttpOverrides {
  // ByteData data;
  // CustomHttpOverrides(this.data);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
