import 'package:flutter/material.dart';

class Contactenos extends StatelessWidget {
  const Contactenos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color colorPrimario = Colors.blue;
    final Color colorFondo = Color(0xFFF5F5F5);
    final Color colorTarjeta = Colors.white;
    final Color colorTextoSecundario = Color(0xFFA0A0A0);

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
            _campoTexto('Nombre Completo', colorTextoSecundario),
            const SizedBox(height: 20),
            _campoTexto('Correo Electrónico', colorTextoSecundario),
            const SizedBox(height: 20),
            _campoTexto(
              'Describe tu consulta o problema',
              colorTextoSecundario,
              maxLines: 4,
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoTexto(
    String label,
    Color colorTextoSecundario, {
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: TextStyle(color: colorTextoSecundario),
      ),
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
}
