// lib/screens/login.dart
import 'package:app_gastos/screens/menu.dart'; 
import 'package:flutter/material.dart';
import 'package:app_gastos/screens/registro.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class LoginScreen extends StatefulWidget { 
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> { // Create State
  final _formKey = GlobalKey<FormState>(); // Add form key for validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Loading state

  // --- Firebase Sign-In Logic ---
  Future<void> _signInFirebase() async {
    if (!_formKey.currentState!.validate()) {
      return; // Don't proceed if form is invalid
    }

    setState(() { _isLoading = true; });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Usuario inició sesión: ${userCredential.user?.uid}');
      // Navigation is handled by StreamBuilder in main.dart

    } on FirebaseAuthException catch (e) {
      print('🔥 Error de inicio de sesión: ${e.code} - ${e.message}');
      String message;
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
         message = 'Correo electrónico o contraseña incorrectos.';
      } else if (e.code == 'invalid-email') {
         message = 'El formato del correo electrónico no es válido.';
      } else {
         message = 'Ocurrió un error al iniciar sesión.';
      }
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(message), backgroundColor: Colors.red),
         );
       }
    } catch (e) {
      print('🔥 Error inesperado: $e');
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Ocurrió un error inesperado.'), backgroundColor: Colors.red),
         );
       }
    } finally {
       if (mounted) {
         setState(() { _isLoading = false; });
       }
    }
  }
  // --- End Firebase Sign-In Logic ---

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blue; // Use Theme.of(context).primaryColor
    final Color backgroundColor = Color(0xFFF5F5F5); // Use Theme.of(context).scaffoldBackgroundColor
    final Color cardColor = Colors.white; // Use Theme.of(context).cardColor
    final Color secondaryTextColor = Color(0xFFA0A0A0); // Use Theme.of(context).hintColor or similar

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView( // Allow scrolling
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            color: cardColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form( // Wrap content in a Form
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email Field
                    TextFormField( // Use TextFormField for validation
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelStyle: TextStyle(color: secondaryTextColor),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa tu correo';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                           return 'Ingresa un correo válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField( // Use TextFormField for validation
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelStyle: TextStyle(color: secondaryTextColor),
                      ),
                       validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa tu contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Login Button or Loading Indicator
                    _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _signInFirebase, // Call Firebase sign-in
                          child: const Text(
                            'Ingresar',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                    const SizedBox(height: 16),

                    // Registration Button
                    TextButton(
                      onPressed: _isLoading ? null : () { // Disable when loading
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistroScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'No tienes cuenta? Dale click aquí para Registrarte!',
                        style: TextStyle(
                          color: Colors.blue, // Use Theme.of(context).primaryColor
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}