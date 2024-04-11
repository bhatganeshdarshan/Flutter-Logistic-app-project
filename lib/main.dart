import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logisticapp/constants/constants.dart';
import 'package:logisticapp/entrypage.dart';
import 'package:logisticapp/map/app_info.dart';

import 'package:logisticapp/map/track_order.dart';
import 'package:logisticapp/screens/available_vehicles_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:logisticapp/user_auth/login_page.dart';
import 'package:logisticapp/utils/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 825),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return ChangeNotifierProvider(
          create: (context) => AppInfo(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'First Method',
            theme: ThemeData(
                scaffoldBackgroundColor: kOffWhite,
                iconTheme: const IconThemeData(color: kDark),
                primarySwatch: Colors.grey),
            home: child,
          ),
        );
      },
      child: LoginPage(),
    );
  }
}
