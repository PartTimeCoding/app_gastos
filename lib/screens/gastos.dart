import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class GastosScreen extends StatefulWidget {
  @override
  _GastosScreenState createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  final Color colorPrimario = Colors.blue;
  final Color colorFondo = Color(0xFFF5F5F5);
  final Color colorTarjeta = Colors.white;
  final Color colorTextoSecundario = Color(0xFFA0A0A0);

  final TextEditingController montoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController notaController = TextEditingController();
  String? categoriaSeleccionada;
  String? metodoPagoSeleccionado;
  final List<String> categorias = [
    'Alquiler',
    'Comida',
    'Transporte',
    'Entretenimiento',
    'Servicios',
    'Otros',
  ];
  final List<String> metodosPago = [
    'Tarjeta',
    'Efectivo',
    'Transferencia',
    'Aplicación',
  ];
  DateTime? fechaSeleccionada;

  List<Map<String, dynamic>> gastos = [
    {
      'monto': 500,
      'categoria': 'Alquiler',
      'fecha': '2024-03-15',
      'metodoPago': 'Transferencia',
    },
    {
      'monto': 200,
      'categoria': 'Comida',
      'fecha': '2024-03-20',
      'metodoPago': 'Tarjeta',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        backgroundColor: colorPrimario,
        foregroundColor: Colors.white,
        title: const Text('Gastos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGastoForm(),
            const SizedBox(height: 20),
            _buildGastosRecientes(),
          ],
        ),
      ),
    );
  }

  Widget _buildGastoForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: colorTarjeta,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.add, color: colorPrimario),
                  SizedBox(width: 8),
                  Text(
                    'Agregar Gasto',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: montoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Monto',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: fechaController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Fecha',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          helpText: 'Seleccionar fecha',
                          cancelText: 'Cancelar',
                          confirmText: 'Confirmar',
                        );
                        if (pickedDate != null) {
                          setState(() {
                            fechaSeleccionada = pickedDate;
                            fechaController.text = DateFormat(
                              'yyyy-MM-dd',
                            ).format(pickedDate);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: categoriaSeleccionada,
                items:
                    categorias.map((categoria) {
                      return DropdownMenuItem(
                        value: categoria,
                        child: Text(categoria),
                      );
                    }).toList(),
                decoration: InputDecoration(
                  labelText: 'Seleccionar Categoría',
                  border: OutlineInputBorder(),
                ),
                onChanged:
                    (value) => setState(() => categoriaSeleccionada = value),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: metodoPagoSeleccionado,
                items:
                    metodosPago.map((metodo) {
                      return DropdownMenuItem(
                        value: metodo,
                        child: Text(metodo),
                      );
                    }).toList(),
                decoration: InputDecoration(
                  labelText: 'Método de Pago',
                  border: OutlineInputBorder(),
                ),
                onChanged:
                    (value) => setState(() => metodoPagoSeleccionado = value),
              ),
              SizedBox(height: 10),
              TextField(
                controller: notaController,
                decoration: InputDecoration(
                  labelText: 'Nota (Opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Agregar Gasto',
                  style: TextStyle(color: colorFondo),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimario,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  if (montoController.text.isNotEmpty &&
                      fechaController.text.isNotEmpty &&
                      categoriaSeleccionada != null &&
                      metodoPagoSeleccionado != null) {
                    setState(() {
                      gastos.add({
                        'monto': double.parse(montoController.text),
                        'categoria': categoriaSeleccionada!,
                        'fecha': fechaController.text,
                        'metodoPago': metodoPagoSeleccionado!,
                        'nota': notaController.text,
                      });

                      // Limpiar formulario
                      montoController.clear();
                      fechaController.clear();
                      fechaSeleccionada = null;
                      categoriaSeleccionada = null;
                      metodoPagoSeleccionado = null;
                      notaController.clear();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Por favor, complete todos los campos requeridos',
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGastosRecientes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: colorTarjeta,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.edit, color: colorPrimario), // Icono de editar
                  SizedBox(width: 8), // Espaciado entre el icono y el texto
                  Text(
                    'Gastos Recientes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children:
                    gastos.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final Map<String, dynamic> gasto = entry.value;
                      return ListTile(
                        title: Text(
                          '\$${gasto['monto']} - ${gasto['categoria']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${gasto['fecha']} - ${gasto['metodoPago']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: colorPrimario),
                              onPressed: () {
                                // Implementación para editar gasto
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  gastos.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    montoController.dispose();
    fechaController.dispose();
    notaController.dispose();
    super.dispose();
  }
}
