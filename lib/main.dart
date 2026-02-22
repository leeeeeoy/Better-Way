import 'package:better_way/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: App()));
}
