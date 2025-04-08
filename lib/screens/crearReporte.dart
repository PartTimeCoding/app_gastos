import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class CrearReporte extends StatefulWidget {
  const CrearReporte({super.key});

  @override
  State<CrearReporte> createState() => _CrearReporteState();
}

class _CrearReporteState extends State<CrearReporte> {
  String periodoSeleccionado = 'Mensual';
  final controladorCorreo = TextEditingController(text: 'ejemplo@correo.com');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, String>> _historialReportes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Imprimir Reporte'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _tarjetaGenerarReporte(),
                const SizedBox(height: 20),
                const Text(
                  'Historial de Reportes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                _historialReportes.isEmpty
                    ? const Text('No se han creado reportes aún.')
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _historialReportes.length,
                      itemBuilder: (context, index) {
                        final reporte = _historialReportes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text('Reporte ${reporte['tipo']}'),
                            subtitle: Text('Fecha: ${reporte['fecha']}'),
                          ),
                        );
                      },
                    ),
              ],
            ),
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
                child: const Text('Imprimir'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _agregarReporteAlHistorial(String tipoReporte) {
    final String fecha = DateFormat('dd/MM/yyyy').format(DateTime.now());
    setState(() {
      _historialReportes.add({'fecha': fecha, 'tipo': tipoReporte});
    });
  }

  void _generarReportePDF() async {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuario no autenticado')));
      return;
    }

    DocumentSnapshot snapshot =
        await _firestore.collection('SaldoUsuario').doc(user.uid).get();
    if (!snapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron datos de saldo')),
      );
      return;
    }

    List<Map<String, dynamic>> todosIngresos = List.from(
      snapshot['ingresos'] ?? [],
    );
    List<Map<String, dynamic>> todosGastos = List.from(
      snapshot['gastos'] ?? [],
    );

    DateTime fechaActual = DateTime.now();
    DateTime fechaInicio;

    switch (periodoSeleccionado) {
      case 'Mensual':
        fechaInicio = DateTime(fechaActual.year, fechaActual.month, 1);
        break;
      case 'Trimestral':
        int mes = ((fechaActual.month - 1) ~/ 3) * 3 + 1;
        fechaInicio = DateTime(fechaActual.year, mes, 1);
        break;
      case 'Anual':
        fechaInicio = DateTime(fechaActual.year, 1, 1);
        break;
      default:
        fechaInicio = DateTime(fechaActual.year, fechaActual.month, 1);
    }

    List<Map<String, dynamic>> ingresosFiltrados =
        todosIngresos.where((ingreso) {
          DateTime fechaIngreso = (ingreso['fecha'] as Timestamp).toDate();
          return fechaIngreso.isAfter(fechaInicio) ||
              fechaIngreso.isAtSameMomentAs(fechaInicio);
        }).toList();

    List<Map<String, dynamic>> gastosFiltrados =
        todosGastos.where((gasto) {
          DateTime fechaGasto = (gasto['fecha'] as Timestamp).toDate();
          return fechaGasto.isAfter(fechaInicio) ||
              fechaGasto.isAtSameMomentAs(fechaInicio);
        }).toList();

    double totalIngresos = ingresosFiltrados.fold(
      0,
      (sum, ingreso) => sum + (ingreso['monto'] as num),
    );
    double totalGastos = gastosFiltrados.fold(
      0,
      (sum, gasto) => sum + (gasto['monto'] as num),
    );
    double saldo = totalIngresos - totalGastos;

    String periodoTexto;
    switch (periodoSeleccionado) {
      case 'Mensual':
        periodoTexto = '${_nombreMes(fechaInicio.month)} ${fechaInicio.year}';
        break;
      case 'Trimestral':
        int trimestre = ((fechaInicio.month - 1) ~/ 3) + 1;
        periodoTexto = 'Trimestre $trimestre del ${fechaInicio.year}';
        break;
      case 'Anual':
        periodoTexto = 'Año ${fechaInicio.year}';
        break;
      default:
        periodoTexto = periodoSeleccionado;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Reporte Financiero - $periodoTexto',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Resumen:',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text('Total Ingresos: \$${totalIngresos.toStringAsFixed(2)}'),
              pw.Text('Total Gastos: \$${totalGastos.toStringAsFixed(2)}'),
              pw.Text(
                'Saldo: \$${saldo.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontWeight:
                      saldo >= 0 ? pw.FontWeight.bold : pw.FontWeight.normal,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Detalle de Ingresos:',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              ...ingresosFiltrados.map((ingreso) {
                DateTime fecha = (ingreso['fecha'] as Timestamp).toDate();
                return pw.Text(
                  'Monto: \$${ingreso['monto']} - Fecha: ${_formatearFecha(fecha)} - Categoría: ${ingreso['categoria']}',
                );
              }),
              pw.SizedBox(height: 20),
              pw.Text(
                'Detalle de Gastos:',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              ...gastosFiltrados.map((gasto) {
                DateTime fecha = (gasto['fecha'] as Timestamp).toDate();
                return pw.Text(
                  'Monto: \$${gasto['monto']} - Fecha: ${_formatearFecha(fecha)} - Categoría: ${gasto['categoria']}',
                );
              }),
            ],
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    await _compartirPDF(pdfBytes);
    _agregarReporteAlHistorial(periodoSeleccionado);
  }

  String _nombreMes(int mes) {
    switch (mes) {
      case 1:
        return 'Enero';
      case 2:
        return 'Febrero';
      case 3:
        return 'Marzo';
      case 4:
        return 'Abril';
      case 5:
        return 'Mayo';
      case 6:
        return 'Junio';
      case 7:
        return 'Julio';
      case 8:
        return 'Agosto';
      case 9:
        return 'Septiembre';
      case 10:
        return 'Octubre';
      case 11:
        return 'Noviembre';
      case 12:
        return 'Diciembre';
      default:
        return '';
    }
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  Future<void> _compartirPDF(Uint8List pdfBytes) async {
    try {
      final directory = await getTemporaryDirectory();

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '${directory.path}/reporte_financiero_$timestamp.pdf';

      final file = File(path);
      await file.writeAsBytes(pdfBytes);

      final result = await Share.shareXFiles(
        [XFile(path)],
        text: 'Reporte financiero $periodoSeleccionado',
        subject: 'Reporte financiero',
      );

      if (result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reporte compartido exitosamente')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al compartir el PDF: $e')));
    }
  }
}
