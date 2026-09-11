import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mach_mit/constants.dart';
import 'package:mach_mit/firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/verify_email_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mach mit',
      theme: ThemeData(
        scaffoldBackgroundColor: background_color,
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

/// Decides which screen to show first based on whether someone's signed in.
/// Also reacts live to sign-in/sign-out events anywhere else in the app
/// (e.g. the "Sign out" button in Settings), since it listens to a stream
/// rather than checking auth state just once.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Firebase is still figuring out if a user is already signed in
        // (e.g. from a previous session). Show a simple loading state
        // instead of flashing the login screen for a split second.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: background_color,
            body: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return const LoginScreen();
        }

        if (!user.emailVerified) {
          return const VerifyEmailScreen();
        }

        return const MyHomePage(title: '');
      },
    );
  }
}
