import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final clientIdProvider = FutureProvider<String>((ref) async {
  const String clientIdKey = 'client_id';
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? clientId = prefs.getString(clientIdKey);

  if (clientId == null) {
    clientId = const Uuid().v4();
    await prefs.setString(clientIdKey, clientId);
  }

  return clientId;
});
