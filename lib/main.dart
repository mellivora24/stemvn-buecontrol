import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stemvn_bluecontrol/app/app_theme.dart';
import 'package:stemvn_bluecontrol/app/app_routes.dart';
import 'package:stemvn_bluecontrol/ui/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
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
      theme: AppTheme.lightTheme,
      title: 'STEMVN BlueControl',
      initialRoute: AppRoutes.home,
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
      },
    );
  }
}
