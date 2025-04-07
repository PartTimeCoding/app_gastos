import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({Key? key}) : super(key: key);

  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _claveFormulario = GlobalKey<FormState>();
  final TextEditingController controladorNombre = TextEditingController();
  final TextEditingController controladorApellido = TextEditingController();
  final TextEditingController controladorFechaNacimiento =
      TextEditingController();
  final TextEditingController controladorCorreo = TextEditingController();
  final TextEditingController controladorUsuario = TextEditingController();
  final TextEditingController controladorContrasena = TextEditingController();

  bool _isLoading = false;

  // --- Firebase Registration Logic ---
  Future<void> _registrarUsuarioFirebase() async {
    // Validate the form first
    if (!_claveFormulario.currentState!.validate()) {
      return; // If form is not valid, do nothing
    }
    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // Get email and password from controllers
      final email = controladorCorreo.text.trim();
      final password = controladorContrasena.text.trim();

      // Attempt to create user with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('Usuario registrado: ${userCredential.user?.uid}');

      try {
        await FirebaseFirestore.instance
            .collection('Registro')
            .doc(userCredential.user?.uid)
            .set({
              'nombre': controladorNombre.text,
              'apellido': controladorApellido.text,
              'fechaNacimiento': controladorFechaNacimiento.text,
              'correo': controladorCorreo.text,
              'usuario': controladorUsuario.text,
            });
      } catch (e) {
        print('Error al crear el documento de registro: $e');
      }

      try {
        await FirebaseFirestore.instance
            .collection('SaldoUsuario')
            .doc(userCredential.user?.uid)
            .set({'saldo': 0.0, 'ingresos': []});
        print('Documento creado en SaldoUsuario');
      } on FirebaseException catch (e) {
        print('Error de Firebase: ${e.code} - ${e.message}');
      } catch (e) {
        print('Error desconocido: $e');
      }

      if (mounted) {
        // Remove the RegistroScreen from the navigation stack.
        // This reveals the underlying screen managed by AuthWrapper (which should now be MenuScreen).
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      print('Error de registro: ${e.code} - ${e.message}');
      String message;
      // Provide user-friendly error messages
      if (e.code == 'weak-password') {
        message = 'La contraseña proporcionada es muy débil.';
      } else if (e.code == 'email-already-in-use') {
        message = 'El correo electrónico ya está registrado.';
      } else if (e.code == 'invalid-email') {
        message = 'El formato del correo electrónico no es válido.';
      } else {
        // General error message for other Firebase Auth exceptions
        message = 'Ocurrió un error durante el registro. Intenta de nuevo.';
      }
      // Show error message in a SnackBar and hide loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
        setState(() {
          _isLoading = false; // Hide loading indicator on error
        });
      }
    } catch (e) {
      // Catch any other unexpected errors
      print('Error inesperado: $e');
      // Show a generic error message and hide loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocurrió un error inesperado.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false; // Hide loading indicator on error
        });
      }
    }
  }
  // --- End Firebase Registration Logic ---

  @override
  void dispose() {
    // Dispose controllers to free up resources
    controladorNombre.dispose();
    controladorApellido.dispose();
    controladorFechaNacimiento.dispose();
    controladorCorreo.dispose();
    controladorUsuario.dispose();
    controladorContrasena.dispose();
    super.dispose();
  }

  // --- Date Picker Logic ---
  Future<void> _selectDate(BuildContext context) async {
    // Hide keyboard if it's open before showing the date picker
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime? picked = await showDatePicker(
      context: context,
      // Sensible initial date (e.g., 18 years ago)
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      // Set the range of selectable dates
      firstDate: DateTime(1920),
      lastDate: DateTime.now(), // User cannot select a future date
      // Localization/Text customization
      helpText: 'Selecciona tu fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    // If the user picked a date, update the text field controller
    if (picked != null) {
      setState(() {
        // Format the date using intl package for better control (e.g., dd/MM/yyyy)
        controladorFechaNacimiento.text = DateFormat(
          'dd/MM/yyyy',
        ).format(picked);
      });
    }
  }
  // --- End Date Picker Logic ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      backgroundColor: Colors.white, // Consider using Theme background color
      body: Center(
        // Use Center and SingleChildScrollView for responsiveness
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Registro de Usuario',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Consider using Theme primary color
                ),
              ),
              const SizedBox(height: 20),
              // Form widget for validation
              Form(
                key: _claveFormulario,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Use helper widget for text fields
                    _campoTexto(controladorNombre, 'Nombre'),
                    const SizedBox(height: 16),
                    _campoTexto(controladorApellido, 'Apellido'),
                    const SizedBox(height: 16),
                    // Date field using the helper widget
                    _campoTexto(
                      controladorFechaNacimiento,
                      'Fecha de Nacimiento',
                      esFecha: true,
                    ),
                    const SizedBox(height: 16),
                    // Email field with specific validation
                    TextFormField(
                      controller: controladorCorreo,
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email), // Add icon
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Por favor, ingresa tu Correo Electrónico';
                        }
                        // Basic email format validation regex
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(valor)) {
                          return 'Ingresa un correo electrónico válido';
                        }
                        return null; // Return null if valid
                      },
                    ),
                    const SizedBox(height: 16),
                    // Username field (optional, depends if you save it)
                    _campoTexto(
                      controladorUsuario,
                      'Usuario (Opcional)',
                      esOpcional: true,
                    ), // Mark as optional
                    const SizedBox(height: 16),
                    // Password field with specific validation
                    TextFormField(
                      controller: controladorContrasena,
                      obscureText: true, // Hide password characters
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock), // Add icon
                      ),
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Por favor, ingresa tu Contraseña';
                        }
                        // Firebase requires at least 6 characters for password
                        if (valor.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null; // Return null if valid
                      },
                    ),
                    const SizedBox(height: 24),
                    // Conditional UI: Show loading indicator or button
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          onPressed:
                              _registrarUsuarioFirebase, // Call registration function
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Theme primary color
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // Consistent border radius
                            ),
                            minimumSize: const Size(
                              double.infinity,
                              50,
                            ), // Full width button
                          ),
                          child: const Text('Registrar'),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for creating TextFormField widgets consistently
  Widget _campoTexto(
    TextEditingController controlador,
    String etiqueta, {
    bool esContrasena = false,
    bool esFecha = false,
    bool esOpcional = false, // Added flag for optional fields
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controlador,
      obscureText: esContrasena,
      // Date field should be read-only, user interacts via picker
      readOnly: esFecha,
      // Use TextInputType.none for date field to prevent keyboard
      keyboardType: esFecha ? TextInputType.none : keyboardType,
      decoration: InputDecoration(
        labelText: etiqueta,
        border: const OutlineInputBorder(),
        // Show calendar icon only for date fields
        suffixIcon: esFecha ? const Icon(Icons.calendar_today) : null,
      ),
      validator: (valor) {
        // Skip validation if the field is marked as optional and is empty
        if (esOpcional && (valor == null || valor.isEmpty)) {
          return null;
        }
        // Basic required field validation
        if (valor == null || valor.isEmpty) {
          return 'Por favor, ingresa $etiqueta';
        }
        return null; // Return null if valid
      },
      // Assign the onTap callback only for date fields
      onTap: esFecha ? () => _selectDate(context) : null,
    );
  }
}
