// ignore_for_file: unused_element

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'nextpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_KEY'),
  );
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  bool isDark = true;
  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.amber,
  );

  ThemeData lightTheme =
      ThemeData(brightness: Brightness.light, primaryColor: Colors.blue);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDark == true ? darkTheme : lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: NextPage(),
    );
  }
}
