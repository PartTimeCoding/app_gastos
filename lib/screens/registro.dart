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

  Future<void> _registrarUsuarioFirebase() async {
    if (!_claveFormulario.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final email = controladorCorreo.text.trim();
      final password = controladorContrasena.text.trim();

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
            .set({'saldo': 0.0, 'ingresos': [], 'gasto': []});
        print('Documento creado en SaldoUsuario');
      } on FirebaseException catch (e) {
        print('Error de Firebase: ${e.code} - ${e.message}');
      } catch (e) {
        print('Error desconocido: $e');
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      print('Error de registro: ${e.code} - ${e.message}');
      String message;
      if (e.code == 'weak-password') {
        message = 'La contraseña proporcionada es muy débil.';
      } else if (e.code == 'email-already-in-use') {
        message = 'El correo electrónico ya está registrado.';
      } else if (e.code == 'invalid-email') {
        message = 'El formato del correo electrónico no es válido.';
      } else {
        message = 'Ocurrió un error durante el registro. Intenta de nuevo.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error inesperado: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocurrió un error inesperado.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controladorNombre.dispose();
    controladorApellido.dispose();
    controladorFechaNacimiento.dispose();
    controladorCorreo.dispose();
    controladorUsuario.dispose();
    controladorContrasena.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      helpText: 'Selecciona tu fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (picked != null) {
      setState(() {
        controladorFechaNacimiento.text = DateFormat(
          'dd/MM/yyyy',
        ).format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blue;
    final Color backgroundColor = Color(0xFFF5F5F5);
    final Color cardColor = Colors.white;
    final Color secondaryTextColor = Color(0xFFA0A0A0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            color: cardColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _claveFormulario,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Registro de Usuario',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _campoTexto(controladorNombre, 'Nombre'),
                    const SizedBox(height: 16),
                    _campoTexto(controladorApellido, 'Apellido'),
                    const SizedBox(height: 16),
                    _campoTexto(
                      controladorFechaNacimiento,
                      'Fecha de Nacimiento',
                      esFecha: true,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controladorCorreo,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelStyle: TextStyle(color: secondaryTextColor),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Por favor, ingresa tu Correo Electrónico';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(valor)) {
                          return 'Ingresa un correo electrónico válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _campoTexto(
                      controladorUsuario,
                      'Usuario (Opcional)',
                      esOpcional: true,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controladorContrasena,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelStyle: TextStyle(color: secondaryTextColor),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Por favor, ingresa tu Contraseña';
                        }
                        if (valor.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: _registrarUsuarioFirebase,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Registrar'),
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

  Widget _campoTexto(
    TextEditingController controlador,
    String etiqueta, {
    bool esContrasena = false,
    bool esFecha = false,
    bool esOpcional = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controlador,
      obscureText: esContrasena,
      readOnly: esFecha,
      keyboardType: esFecha ? TextInputType.none : keyboardType,
      decoration: InputDecoration(
        labelText: etiqueta,
        border: const OutlineInputBorder(),
        suffixIcon: esFecha ? const Icon(Icons.calendar_today) : null,
      ),
      validator: (valor) {
        if (esOpcional && (valor == null || valor.isEmpty)) {
          return null;
        }
        if (valor == null || valor.isEmpty) {
          return 'Por favor, ingresa $etiqueta';
        }
        return null;
      },
      onTap: esFecha ? () => _selectDate(context) : null,
    );
  }
}
