import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_gastos/screens/contactenos.dart';
import 'package:app_gastos/screens/crearReporte.dart';
import 'package:app_gastos/screens/gastos.dart';
import 'package:app_gastos/screens/ingresos.dart';
import 'package:app_gastos/screens/tusFinanzas.dart';

class menu extends StatelessWidget {
  const menu({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    final bool? shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Cierre de Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Cerrar Sesión'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    if (shouldSignOut == true) {
      try {
        await FirebaseAuth.instance.signOut();
        print('✅ Usuario cerró sesión');
      } catch (e) {
        print('🔥 Error al cerrar sesión: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al cerrar sesión.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('OptiFinanzas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () => _signOut(context),
          ),
        ],
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
                      builder: (context) => const TusFinanzasScreen(),
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
            const SizedBox(height: 30),
            Center(
              child: Image.asset(
                "lib/assets/logo_OptiFinanzas.png",
                height: 100,
                width: 100,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '© 2025 OptiFinanzas. Todos los derechos reservados',
                style: TextStyle(fontSize: 12, color: Colors.grey),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
