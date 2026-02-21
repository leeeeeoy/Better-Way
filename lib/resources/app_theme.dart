part of 'resources.dart';

abstract class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.notoSansKr().fontFamily,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent, brightness: .light),
    textTheme: TextTheme(),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.notoSansKr().fontFamily,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent, brightness: .dark),
    textTheme: TextTheme(),
  );
}
