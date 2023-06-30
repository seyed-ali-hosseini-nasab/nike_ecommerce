import 'package:flutter/material.dart';
import 'package:nike_ecommerce/theme.dart';
import 'package:nike_ecommerce/ui/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(fontFamily: 'Vazir');
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: defaultTextStyle,
          caption: defaultTextStyle.apply(
              color: LightThemeColors.secondaryTextColor),
          headline6: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        colorScheme: const ColorScheme.light(
          primary: LightThemeColors.primaryColor,
          secondary: LightThemeColors.secondaryColor,
          onSecondary: Colors.white,
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomeScreen(),
      ),
    );
  }
}
