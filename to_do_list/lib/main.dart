import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/repo/repository.dart';
import 'package:to_do_list/data/source/hive_task_source.dart';
import 'package:to_do_list/screen/splash/splash.dart';

const taskBoxName = 'tasks';
const secondaryTextColor = Color.fromARGB(255, 74, 76, 79);
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryColor , statusBarIconBrightness: Brightness.dark));
  runApp(ChangeNotifierProvider<Repository<TaskEntity>>(
      create: (context) =>
          Repository<TaskEntity>(hiveTaskDataSource(Hive.box(taskBoxName))),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1D2830);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
              labelStyle: TextStyle(color: secondaryTextColor),
              iconColor: secondaryTextColor,
              prefixIconColor: secondaryTextColor),
          colorScheme: const ColorScheme.light(
            primary: Colors.amber,
            primaryContainer: Color.fromRGBO(238, 245, 36, 0.498),
            background: Color(0xffF3F5F8),
            onSurface: primaryTextColor,
            onPrimary: Colors.black,
            onBackground: primaryTextColor,
            secondary: Colors.amber,
            onSecondary: Color.fromARGB(255, 0, 0, 0),
          )),
      home: const SplashScreen(),
    );
  }
}

const Color primaryColor = Colors.amber;
