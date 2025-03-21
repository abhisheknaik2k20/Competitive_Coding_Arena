import 'dart:async';
import 'dart:html' as html;
import 'package:competitivecodingarena/Error/error_widgets.dart';
import 'package:competitivecodingarena/Messaging/messages_logic.dart';
import 'package:competitivecodingarena/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/containers/homescreen.dart';
import 'package:competitivecodingarena/Welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_darkTheme) {
    _loadTheme();
  }

  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey[300],
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  Future<void> _loadTheme() async {
    if (kIsWeb) {
      final isLight = html.window.localStorage['isLight'] == 'true';
      state = isLight ? _lightTheme : _darkTheme;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final isLight = prefs.getBool('isLight') ?? true;
      state = isLight ? _lightTheme : _darkTheme;
    }
  }

  Future<void> toggleTheme() async {
    final isLight = state.brightness == Brightness.light;

    if (kIsWeb) {
      html.window.localStorage['isLight'] = (!isLight).toString();
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLight', !isLight);
    }
    state = isLight ? _darkTheme : _lightTheme;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  await requestNotificationPermissions();
  runApp(
    ErrorHandler(
      child: const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Competitive Coding Arena',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: _buildInitialScreen(context),
    );
  }

  Widget _buildInitialScreen(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return user == null
        ? const WelcomeScreen()
        : LeetCodeProblemsetHomescreen(size: MediaQuery.sizeOf(context));
  }
}
