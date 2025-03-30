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
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Encabezado azul con solo el título y botón de retroceso
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            width: double.infinity,
            color: const Color(0xFF4C6EF5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'OptiFinanzas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const login()),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 2, // Ajuste para que no sean tan grandes
            children: [
              _menuCard(
                context,
                icon: Icons.trending_up,
                label: 'Ingresos',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ingresos()),
                    ),
              ),
              _menuCard(
                context,
                icon: Icons.attach_money,
                label: 'Gastos',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const gastos()),
                    ),
              ),
              _menuCard(
                context,
                icon: Icons.bar_chart,
                label: 'Resumen Financiero',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const finanzas()),
                    ),
              ),
              _menuCard(
                context,
                icon: Icons.print,
                label: 'Imprimir Reporte',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const reporte()),
                    ),
              ),
              _menuCard(
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
        ],
      ),
    );
  }

  // Widget reutilizable para las tarjetas del menú
  Widget _menuCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF4C6EF5), size: 40),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
