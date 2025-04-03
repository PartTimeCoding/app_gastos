// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:app_gastos/screens/login.dart';
import 'package:app_gastos/screens/menu.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
    runApp(const MyApp());

  } catch (e) {
    print('🔥 Fatal Firebase error: $e');
    runApp(ErrorApp(errorMessage: e.toString())); // Pass error message
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(), // Use a wrapper widget to handle auth state
    );
  }
}

// In lib/main.dart, inside AuthWrapper build method:
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print("AuthWrapper rebuild: ConnectionState=${snapshot.connectionState}, HasData=${snapshot.hasData}, HasError=${snapshot.hasError}"); // <-- ADD THIS

        if (snapshot.connectionState == ConnectionState.waiting) {
          print("AuthWrapper: Waiting for auth state...");
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) { // <-- ADD ERROR HANDLING
           print("AuthWrapper: Error in auth stream: ${snapshot.error}");
           return const Scaffold(body: Center(child: Text('Error en la autenticación')));
        }


        if (snapshot.hasData) {
          print('AuthWrapper: User is logged in: ${snapshot.data?.uid}. Showing menu.'); 
          return const menu();
        }

        print('AuthWrapper: User is logged out. Showing LoginScreen.');
        return const LoginScreen();
      },
    );
  }
}


class ErrorApp extends StatelessWidget {
  final String errorMessage;
  const ErrorApp({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                const SizedBox(height: 20),
                const Text('Firebase Initialization Error', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(errorMessage, textAlign: TextAlign.center), 
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => main(), 
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
