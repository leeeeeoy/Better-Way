import 'package:better_way/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv

Future<void> main() async { // Make main() async
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load .env file

  runApp(ProviderScope(child: App()));
}
