import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:app_gastos/screens/contactenos.dart';
import 'package:app_gastos/screens/crearReporte.dart';
import 'package:app_gastos/screens/gastos.dart';
import 'package:app_gastos/screens/ingresos.dart';
import 'package:app_gastos/screens/tusFinanzas.dart';

class menu extends StatelessWidget {
  const menu({Key? key}) : super(key: key);

  // --- Sign Out Logic ---
  Future<void> _signOut(BuildContext context) async {
    // Show confirmation dialog before signing out (Optional but recommended)
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
                Navigator.of(context).pop(false); // Return false
              },
            ),
            TextButton(
              child: const Text('Cerrar Sesión'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true
              },
            ),
          ],
        );
      },
    );

    // Proceed only if the user confirmed
    if (shouldSignOut == true) {
      try {
        await FirebaseAuth.instance.signOut();
        print('✅ Usuario cerró sesión');
        // Navigation back to LoginScreen is handled by the StreamBuilder in main.dart
        // No explicit navigation needed here
      } catch (e) {
        print('🔥 Error al cerrar sesión: $e');
        // Show error if needed, check if widget is still mounted
        if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Error al cerrar sesión.'), backgroundColor: Colors.red),
           );
        }
      }
    }
  }
  // --- End Sign Out Logic ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Consider using Theme.of(context).primaryColor
        foregroundColor: Colors.white,
        title: const Text('OptiFinanzas'),
        centerTitle: true,
        actions: [ // Logout button in AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () => _signOut(context), // Call sign out function
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Menu Item: Ingresos ---
            _tarjetaMenu(
              context,
              icon: Icons.trending_up, // Icon for income
              label: 'Ingresos',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IngresosScreen()), // Navigate to IngresosScreen
              ),
            ),
            const SizedBox(height: 16), // Spacing

            // --- Menu Item: Gastos ---
            _tarjetaMenu(
              context,
              icon: Icons.attach_money, // Icon for expenses
              label: 'Gastos',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GastosScreen()), // Navigate to GastosScreen
              ),
            ),
            const SizedBox(height: 16), // Spacing

            // --- Menu Item: Resumen Financiero ---
            _tarjetaMenu(
              context,
              icon: Icons.bar_chart, // Icon for financial summary/charts
              label: 'Resumen Financiero',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TusFinanzasScreen()), // Navigate to TusFinanzasScreen
              ),
            ),
            const SizedBox(height: 16), // Spacing

            // --- Menu Item: Imprimir Reporte ---
            _tarjetaMenu(
              context,
              icon: Icons.print, // Icon for printing/reports
              label: 'Imprimir Reporte',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CrearReporte()), // Navigate to CrearReporte
              ),
            ),
            const SizedBox(height: 16), // Spacing

            // --- Menu Item: Contacto Soporte ---
            _tarjetaMenu(
              context,
              icon: Icons.help_outline, // Icon for help/support
              label: 'Contacto Soporte',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Contactenos()), // Navigate to Contactenos
              ),
            ),
            // The optional dedicated sign out card is removed as the AppBar action is present.
          ],
        ),
      ),
    );
  }

  // --- Helper Widget for Menu Cards --- (Keep as is)
  Widget _tarjetaMenu(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
     return Card(
      elevation: 4,
      color: Colors.white, // Consider using Theme.of(context).cardColor
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Add shape for consistency
      child: InkWell(
        borderRadius: BorderRadius.circular(12), // Match shape for ripple effect
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue, size: 40), // Use Theme.of(context).primaryColor
              const SizedBox(width: 16),
              Expanded( // Use Expanded to prevent text overflow issues
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // Add chevron for visual cue
            ],
          ),
        ),
      ),
    );
  }
}