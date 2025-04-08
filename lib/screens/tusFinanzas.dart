import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class TusFinanzasScreen extends StatefulWidget {
  const TusFinanzasScreen({super.key});

  @override
  State<TusFinanzasScreen> createState() => _TusFinanzasScreenState();
}

class _TusFinanzasScreenState extends State<TusFinanzasScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  double _totalIngresos = 0;
  double _totalGastos = 0;
  Map<String, double> _gastosPorCategoria = {};
  Map<String, double> _ingresosPorCategoria = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final snapshot =
          await _firestore.collection('SaldoUsuario').doc(_userId).get();

      if (snapshot.exists) {
        var ingresosData = snapshot['ingresos'] ?? [];
        var gastosData = snapshot['gastos'] ?? [];

        double ingresos = ingresosData.fold(0, (sum, ingreso) {
          return sum + (ingreso['monto'] ?? 0);
        });

        double gastos = gastosData.fold(0, (sum, gasto) {
          return sum + (gasto['monto'] ?? 0);
        });

        setState(() {
          _totalIngresos = ingresos;
          _totalGastos = gastos;
          _gastosPorCategoria = _agruparPorCategoria(gastosData);
          _ingresosPorCategoria = _agruparPorCategoria(ingresosData);
        });
      } else {
        print("El documento no existe.");
      }
    } catch (e) {
      print('Error al cargar datos: $e');
    }
  }

  Map<String, double> _agruparPorCategoria(List<dynamic> data) {
    Map<String, double> resultado = {};
    for (var item in data) {
      String categoria = item['categoria'] ?? 'Sin categoría';
      double monto = item['monto'] ?? 0;

      if (resultado.containsKey(categoria)) {
        resultado[categoria] = resultado[categoria]! + monto;
      } else {
        resultado[categoria] = monto;
      }
    }
    return resultado;
  }

  Widget _buildGraficoGastosPorCategoria() {
    if (_gastosPorCategoria.isEmpty) {
      return const Text('No hay datos para mostrar.');
    }

    final List<PieChartSectionData> sections = [];
    final total = _gastosPorCategoria.values.fold(0.0, (a, b) => a + b);
    final random = Random();

    _gastosPorCategoria.forEach((categoria, monto) {
      final porcentaje = monto / total * 100;
      final color = _generarColorAleatorio();
      sections.add(
        PieChartSectionData(
          value: monto,
          title: '${porcentaje.toStringAsFixed(1)}%',
          color: color,
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ..._gastosPorCategoria.entries.map(
          (e) => Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color:
                    sections[_gastosPorCategoria.keys.toList().indexOf(e.key)]
                        .color,
              ),
              const SizedBox(width: 8),
              Text('${e.key}: \$${e.value.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGraficoIngresosPorCategoria() {
    if (_ingresosPorCategoria.isEmpty) {
      return const Text('No hay datos para mostrar.');
    }

    final List<PieChartSectionData> sections = [];
    final total = _ingresosPorCategoria.values.fold(0.0, (a, b) => a + b);
    final random = Random();

    _ingresosPorCategoria.forEach((categoria, monto) {
      final porcentaje = monto / total * 100;
      final color = _generarColorAleatorio();
      sections.add(
        PieChartSectionData(
          value: monto,
          title: '${porcentaje.toStringAsFixed(1)}%',
          color: color,
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ..._ingresosPorCategoria.entries.map(
          (e) => Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color:
                    sections[_ingresosPorCategoria.keys.toList().indexOf(e.key)]
                        .color,
              ),
              const SizedBox(width: 8),
              Text('${e.key}: \$${e.value.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double saldoDisponible = _totalIngresos - _totalGastos;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Resumen Financiero'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSummaryItem(
                          'Total Ingresos',
                          '\$${_totalIngresos.toStringAsFixed(2)}',
                          Colors.green,
                        ),
                        _buildSummaryItem(
                          'Total Gastos',
                          '\$${_totalGastos.toStringAsFixed(2)}',
                          Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Saldo Disponible',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${saldoDisponible.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Distribución de Gastos por Categoría',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildGraficoGastosPorCategoria(),
            const SizedBox(height: 24),
            const Text(
              'Distribución de Ingresos por Categoría',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildGraficoIngresosPorCategoria(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 8),
        Text(
          amount,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _generarColorAleatorio() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(200) + 55,
      random.nextInt(200) + 55,
      random.nextInt(200) + 55,
    );
  }
}
