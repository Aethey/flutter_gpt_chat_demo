import 'package:firebase_core/firebase_core.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ry_chat/routes/main_routes.dart';
import 'package:ry_chat/data/api/dio_manager.dart';
import 'package:ry_chat/data/database/hive_db.dart';
import 'package:ry_chat/view/chat/chat_page.dart';
import 'package:ry_chat/view/hugging_face_test/test_page.dart';
import 'application.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init dotenv
  await dotenv.load(fileName: ".env");
  // init DB
  await HiveDB.initHive();

  // init route
  final router = FluroRouter();
  MainRoutes.defineRoutes(router);
  Application.router = router;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DioManager().init();
  runApp(
    ProviderScope(
      child: MyApp(
        router: router,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FluroRouter router;
  const MyApp({super.key, required this.router});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AIChat Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.black,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child: const ApiRequestWidget(),
    );
  }
}
