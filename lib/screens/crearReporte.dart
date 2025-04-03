import 'package:flutter/material.dart';

class CrearReporte extends StatefulWidget {
  const CrearReporte({super.key});

  @override
  State<CrearReporte> createState() => _CrearReporteState();
}

class _CrearReporteState extends State<CrearReporte> {
  String periodoSeleccionado = 'Mensual';
  final controladorCorreo = TextEditingController(text: 'ejemplo@correo.com');

  final List<Map<String, String>> historialReportes = [
    {'titulo': 'Reporte Mensual - Marzo 2024', 'fecha': '2024-03-31'},
    {'titulo': 'Reporte Trimestral - Q1 2024', 'fecha': '2024-03-31'},
    {'titulo': 'Reporte Anual - 2023', 'fecha': '2023-12-31'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Crear Reporte Financiero'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tarjetaGenerarReporte(),
            const SizedBox(height: 20),
            _tarjetaEnviarCorreo(),
            const SizedBox(height: 20),
            _tarjetaHistorialReportes(),
          ],
        ),
      ),
    );
  }

  Card _tarjetaGenerarReporte() {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crear Reporte',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Seleccionar Periodo'),
            DropdownButton<String>(
              isExpanded: true,
              value: periodoSeleccionado,
              onChanged: (String? nuevoValor) {
                setState(() {
                  periodoSeleccionado = nuevoValor!;
                });
              },
              items:
                  <String>[
                    'Mensual',
                    'Trimestral',
                    'Anual',
                  ].map<DropdownMenuItem<String>>((String valor) {
                    return DropdownMenuItem<String>(
                      value: valor,
                      child: Text(valor),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generarReportePDF,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Crear Reporte PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _tarjetaEnviarCorreo() {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enviar Reporte por Correo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Correo Electrónico'),
            TextField(
              controller: controladorCorreo,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _enviarReporteCorreo,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Enviar Reporte'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _tarjetaHistorialReportes() {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial de Reportes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...historialReportes
                .map(
                  (reporte) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(reporte['titulo']!)),
                        IconButton(
                          icon: const Icon(Icons.download),
                          color: Colors.blue,
                          onPressed:
                              () => _descargarReporte(reporte['titulo']!),
                          tooltip: 'Descargar reporte',
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  void _generarReportePDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generando reporte $periodoSeleccionado...')),
    );
  }

  void _enviarReporteCorreo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Enviando reporte a ${controladorCorreo.text}...'),
      ),
    );
  }

  void _descargarReporte(String nombreReporte) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Descargando $nombreReporte...')));
  }

  @override
  void dispose() {
    controladorCorreo.dispose();
    super.dispose();
  }
}
