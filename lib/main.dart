import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stemvn_bluecontrol/app/app_theme.dart';
import 'package:stemvn_bluecontrol/app/app_routes.dart';
import 'package:stemvn_bluecontrol/ui/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(const MyApp());
  });
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Controller',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
      },
    );
  }
}
