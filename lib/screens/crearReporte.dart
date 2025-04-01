import 'package:flutter/material.dart';

class CrearReporte extends StatefulWidget {
  const CrearReporte({super.key});

  @override
  State<CrearReporte> createState() => _CrearReporteState();
}

class _CrearReporteState extends State<CrearReporte> {
  String selectedPeriod = 'Mensual';
  final emailController = TextEditingController(text: 'ejemplo@correo.com');

  final List<Map<String, String>> reportHistory = [
    {'title': 'Reporte Mensual - Marzo 2024', 'date': '2024-03-31'},
    {'title': 'Reporte Trimestral - Q1 2024', 'date': '2024-03-31'},
    {'title': 'Reporte Anual - 2023', 'date': '2023-12-31'},
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
            _buildGenerateReportCard(),
            const SizedBox(height: 20),
            _buildEmailReportCard(),
            const SizedBox(height: 20),
            _buildReportHistoryCard(),
          ],
        ),
      ),
    );
  }

  Card _buildGenerateReportCard() {
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
              value: selectedPeriod,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPeriod = newValue!;
                });
              },
              items:
                  <String>[
                    'Mensual',
                    'Trimestral',
                    'Anual',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generatePdfReport,
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

  Card _buildEmailReportCard() {
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
              controller: emailController,
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
                onPressed: () => _sendEmailReport(),
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

  Card _buildReportHistoryCard() {
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
            ...reportHistory
                .map(
                  (report) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(report['title']!)),
                        IconButton(
                          icon: const Icon(Icons.download),
                          color: Colors.blue,
                          onPressed: () => _downloadReport(report['title']!),
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

  void _generatePdfReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generando reporte $selectedPeriod...')),
    );
  }

  void _sendEmailReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Enviando reporte a ${emailController.text}...')),
    );
  }

  void _downloadReport(String reportName) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Descargando $reportName...')));
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
