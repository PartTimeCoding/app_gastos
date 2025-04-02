import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class GastosScreen extends StatefulWidget {
  @override
  _GastosScreenState createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  final Color primaryColor = Color(0xFF2A5EE8);
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
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30),
              color: primaryColor,
              child: Center(
                child: Text(
                  'Gastos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildGastoForm(),
            SizedBox(height: 20),
            _buildGastosRecientes(),
            SizedBox(height: 20),
            _buildDistribucionGastos(),
          ],
        ),
      ),
    );
  }

  Widget _buildGastoForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agregar Gasto',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                label: Text('Agregar Gasto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
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
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gastos Recientes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                              icon: Icon(Icons.edit, color: Colors.blue),
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

  Widget _buildDistribucionGastos() {
    // Calcular totales por categoría
    Map<String, double> totalesPorCategoria = {};
    for (var gasto in gastos) {
      final categoria = gasto['categoria'] as String;
      final monto =
          gasto['monto'] is int
              ? (gasto['monto'] as int).toDouble()
              : gasto['monto'] as double;
      totalesPorCategoria[categoria] =
          (totalesPorCategoria[categoria] ?? 0) + monto;
    }

    // Calcular total general
    double totalGeneral = totalesPorCategoria.values.fold(
      0,
      (sum, amount) => sum + amount,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Distribución de Gastos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 200,
                child:
                    totalGeneral > 0
                        ? PieChart(
                          PieChartData(
                            sections:
                                totalesPorCategoria.entries.map((entry) {
                                  final categoria = entry.key;
                                  final monto = entry.value;

                                  Color color;
                                  if (categoria == 'Alquiler') {
                                    color = Colors.blue;
                                  } else if (categoria == 'Comida') {
                                    color = Colors.green;
                                  } else {
                                    // Generar colores para otras categorías
                                    color =
                                        Colors.primaries[categorias.indexOf(
                                              categoria,
                                            ) %
                                            Colors.primaries.length];
                                  }

                                  return PieChartSectionData(
                                    value: monto,
                                    title:
                                        '${(monto / totalGeneral * 100).toStringAsFixed(0)}%',
                                    color: color,
                                    radius: 100.0,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList(),
                            sectionsSpace: 2.0,
                            centerSpaceRadius: 0.0,
                          ),
                        )
                        : Center(
                          child: Text(
                            "Sin datos suficientes para mostrar el gráfico",
                          ),
                        ),
              ),
              SizedBox(height: 10),
              // Leyenda
              Column(
                children:
                    totalesPorCategoria.entries.map((entry) {
                      final categoria = entry.key;
                      final monto = entry.value;

                      Color color;
                      if (categoria == 'Alquiler') {
                        color = Colors.blue;
                      } else if (categoria == 'Comida') {
                        color = Colors.green;
                      } else {
                        color =
                            Colors.primaries[categorias.indexOf(categoria) %
                                Colors.primaries.length];
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(width: 16, height: 16, color: color),
                            SizedBox(width: 8),
                            Expanded(child: Text(categoria)),
                            Text(
                              '\$${monto.toStringAsFixed(0)} (${(monto / totalGeneral * 100).toStringAsFixed(0)}%)',
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
