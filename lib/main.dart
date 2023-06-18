import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:expense_tracker_app/widgets/expenses_dashboard.dart';

// Color Scheme for Light Theme
var kLightColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light, //Default
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

// Color Scheme for Dar Theme
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Dark Theme
      darkTheme: ThemeData.dark().copyWith(
        // useMaterial3: true,
        colorScheme: kDarkColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kDarkColorScheme.primaryContainer,
          foregroundColor: kDarkColorScheme.primary,
        ),
        cardTheme: const CardTheme().copyWith(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: kDarkColorScheme.secondaryContainer,
          shadowColor: kDarkColorScheme.secondary,
          elevation: 10.0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      // Light Theme
      theme: ThemeData().copyWith(
        // useMaterial3: true,
        colorScheme: kLightColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kLightColorScheme.primaryContainer,
          foregroundColor: kLightColorScheme.primary,
        ),
        cardTheme: const CardTheme().copyWith(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: kLightColorScheme.secondaryContainer,
          shadowColor: kLightColorScheme.secondary,
          elevation: 10.0,
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kLightColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kLightColorScheme.primary,
            foregroundColor: kLightColorScheme.primaryContainer,
          ),
        ),
      ),
      themeMode: ThemeMode.system, //Default
      home: const Expenses(),
    );
  }
}
