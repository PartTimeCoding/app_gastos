import 'package:flutter/material.dart';
import 'package:app_gastos/screens/contactenos.dart';
import 'package:app_gastos/screens/crearReporte.dart';
import 'package:app_gastos/screens/gastos.dart';
import 'package:app_gastos/screens/ingresos.dart';
import 'package:app_gastos/screens/tusFinanzas.dart';
import 'package:app_gastos/screens/login.dart';

class menu extends StatelessWidget {
  const menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('OptiFinanzas'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tarjetaMenu(
              context,
              icon: Icons.trending_up,
              label: 'Ingresos',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IngresosScreen()),
                  ),
            ),
            const SizedBox(height: 16),
            _tarjetaMenu(
              context,
              icon: Icons.attach_money,
              label: 'Gastos',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GastosScreen()),
                  ),
            ),
            const SizedBox(height: 16),
            _tarjetaMenu(
              context,
              icon: Icons.bar_chart,
              label: 'Resumen Financiero',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TusFinanzasApp(),
                    ),
                  ),
            ),
            const SizedBox(height: 16),
            _tarjetaMenu(
              context,
              icon: Icons.print,
              label: 'Imprimir Reporte',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CrearReporte(),
                    ),
                  ),
            ),
            const SizedBox(height: 16),
            _tarjetaMenu(
              context,
              icon: Icons.help_outline,
              label: 'Contacto Soporte',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Contactenos(),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaMenu(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue, size: 40),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
