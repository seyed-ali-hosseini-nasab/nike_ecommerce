import 'package:flutter/material.dart';
import 'package:nike_ecommerce/data/repository/auth_repository.dart';
import 'package:nike_ecommerce/theme.dart';
import 'package:nike_ecommerce/ui/root.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(fontFamily: 'Vazir');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: LightThemeColors.secondaryTextColor,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: LightThemeColors.primaryTextColor.withOpacity(0.1),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: LightThemeColors.primaryTextColor,
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
            contentTextStyle: defaultTextStyle.apply(color: Colors.white)),
        textTheme: TextTheme(
          titleMedium: defaultTextStyle.apply(
              color: LightThemeColors.secondaryTextColor),
          bodyMedium: defaultTextStyle,
          labelLarge: defaultTextStyle,
          bodySmall: defaultTextStyle.apply(
              color: LightThemeColors.secondaryTextColor),
          titleLarge: defaultTextStyle.copyWith(
              fontWeight: FontWeight.bold, fontSize: 18),
        ),
        colorScheme: const ColorScheme.light(
          primary: LightThemeColors.primaryColor,
          secondary: LightThemeColors.secondaryColor,
          onSecondary: Colors.white,
          surfaceVariant: Color(0xfff5f5f5),
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: RootScreen(),
      ),
    );
  }
}
