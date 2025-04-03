import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:app_gastos/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
    
    // Start rendering immediately
    runApp(const MyApp());
    
    // Perform async tests after initial render
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _performFirebaseTests();
    });
  } catch (e) {
    print('🔥 Fatal Firebase error: $e');
    runApp(const ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          return const LoginScreen();
        },
      ),
    );
  }
}

Future<void> _performFirebaseTests() async {
  try {
    // Test Anonymous Auth
    final user = await FirebaseAuth.instance.signInAnonymously();
    print('👤 Anonymous UID: ${user.user?.uid}');

    // Test Firestore Write
    final docRef = await FirebaseFirestore.instance.collection('test').add({
      'test': DateTime.now().toIso8601String(),
    });
    print('📝 Document written: ${docRef.id}');

    // Test Firestore Read
    final snapshot = await FirebaseFirestore.instance
        .collection('test')
        .limit(1)
        .get();
    print('📖 Documents found: ${snapshot.docs.length}');
  } catch (e) {
    print('⚠️ Firebase test error: $e');
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Critical Error', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => main(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}