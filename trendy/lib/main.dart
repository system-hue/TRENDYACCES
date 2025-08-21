import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendy/screens/auth/login_screen.dart';
import 'package:trendy/screens/main_navigation_screen.dart';
import 'package:trendy/services/auth_state_service.dart';
import 'package:trendy/utils/memory_manager_simple.dart';
import 'package:trendy/services/ads_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      // App already initialized, continue
      debugPrint("Firebase already initialized, continuing...");
    } else {
      debugPrint("🔥 Firebase initialization failed: $e");
      rethrow;
    }
  }

  try {
    // Set Firebase language to prevent locale warnings
    FirebaseAuth.instance.setLanguageCode('en');

    // Initialize memory manager
    MemoryManager().init();

    // Initialize auth state service
    await AuthStateService().initialize();

    // Initialize Ads SDK (non-blocking)
    unawaited(AdsService.initialize());

    runApp(const MyApp());
  } catch (e) {
    debugPrint("🔥 App initialization failed: $e");
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthStateService())],
      child: MaterialApp(
        title: 'Trendy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStateService>(
      builder: (context, authService, child) {
        if (!authService.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final user = snapshot.data;
            if (user != null) {
              return const MainNavigationScreen();
            } else {
              return const LoginScreen();
            }
          },
        );
      },
    );
  }
}
