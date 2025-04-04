import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contactenos extends StatefulWidget {
  const Contactenos({Key? key}) : super(key: key);

  @override
  _ContactenosState createState() => _ContactenosState();
}

class _ContactenosState extends State<Contactenos> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();

  final Color colorPrimario = Colors.blue;
  final Color colorFondo = Color(0xFFF5F5F5);
  final Color colorTarjeta = Colors.white;
  final Color colorTextoSecundario = Color(0xFFA0A0A0);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        backgroundColor: colorPrimario,
        foregroundColor: Colors.white,
        title: const Text('Contacto de Soporte'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tarjetaInformacion(colorPrimario, colorTarjeta),
            const SizedBox(height: 20),
            _tarjetaConsulta(colorPrimario, colorTarjeta, colorTextoSecundario),
            const SizedBox(height: 20),
            _tarjetaContacto(colorTarjeta),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaInformacion(Color colorPrimario, Color colorTarjeta) {
    return Card(
      color: colorTarjeta,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: colorPrimario),
                const SizedBox(width: 8),
                const Text(
                  'Preguntas Frecuentes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _preguntaRespuesta(
              '¿Cómo registro mis ingresos?',
              'Ve a la sección de Ingresos y completa el formulario con los detalles de tu ingreso.',
            ),
            _preguntaRespuesta(
              '¿Puedo editar un gasto después de registrarlo?',
              'Sí, en la pantalla de Gastos puedes editar o eliminar gastos recientes.',
            ),
            _preguntaRespuesta(
              '¿Cómo genero un reporte financiero?',
              'Navega a la sección de Imprimir Reporte y selecciona el período deseado.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _preguntaRespuesta(String pregunta, String respuesta) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pregunta,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          respuesta,
          style: const TextStyle(fontSize: 13, color: Color(0xFF5C5C5C)),
        ),
        const Divider(),
      ],
    );
  }

  Widget _tarjetaConsulta(
    Color colorPrimario,
    Color colorTarjeta,
    Color colorTextoSecundario,
  ) {
    return Card(
      color: colorTarjeta,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.chat_bubble_outline, color: colorPrimario),
                  const SizedBox(width: 8),
                  const Text(
                    'Enviar Consulta',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _campoTexto(
                'Nombre Completo',
                colorTextoSecundario,
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              _campoTexto(
                'Correo Electrónico',
                colorTextoSecundario,
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              _campoTexto(
                'Describe tu consulta o problema',
                colorTextoSecundario,
                maxLines: 4,
                controller: _issueController,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text('Enviar Consulta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimario,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(
    String label,
    Color colorTextoSecundario, {
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: TextStyle(color: colorTextoSecundario),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor complete este campo';
        }
        if (label.contains('Correo') && !value.contains('@')) {
          return 'Por favor ingrese un correo válido';
        }
        return null;
      },
    );
  }

  Widget _tarjetaContacto(Color colorTarjeta) {
    return Card(
      color: colorTarjeta,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Información de Contacto',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text('Correo: soporte@mail.com', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('Teléfono: +123456789', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('Horario: 9 AM - 6 PM', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final collection = FirebaseFirestore.instance.collection(
          'contact_queries',
        );

        await collection.add({
          'name': _nameController.text,
          'email': _emailController.text,
          'issue': _issueController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Consulta enviada con éxito'),
            backgroundColor: Colors.green,
          ),
        );

        _nameController.clear();
        _emailController.clear();
        _issueController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar la consulta: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
