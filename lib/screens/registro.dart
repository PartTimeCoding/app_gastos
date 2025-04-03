import 'package:flutter/material.dart';

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

  void _registrarUsuario() {
    if (_claveFormulario.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado correctamente')),
      );

      // Simula un registro exitoso y regresa a la pantalla de login
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Registro de Usuario',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _claveFormulario,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                  _campoTexto(controladorCorreo, 'Correo Electrónico'),
                  const SizedBox(height: 16),
                  _campoTexto(controladorUsuario, 'Usuario'),
                  const SizedBox(height: 16),
                  _campoTexto(
                    controladorContrasena,
                    'Contraseña',
                    esContrasena: true,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _registrarUsuario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Registrar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoTexto(
    TextEditingController controlador,
    String etiqueta, {
    bool esContrasena = false,
    bool esFecha = false,
  }) {
    return TextFormField(
      controller: controlador,
      obscureText: esContrasena,
      readOnly: esFecha,
      decoration: InputDecoration(
        labelText: etiqueta,
        border: const OutlineInputBorder(),
      ),
      validator:
          (valor) => valor!.isEmpty ? 'Por favor, ingresa tu $etiqueta' : null,
      onTap:
          esFecha
              ? () async {
                DateTime? fechaSeleccionada = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (fechaSeleccionada != null) {
                  setState(() {
                    controladorFechaNacimiento.text =
                        "${fechaSeleccionada.day}/${fechaSeleccionada.month}/${fechaSeleccionada.year}";
                  });
                }
              }
              : null,
    );
  }
}
