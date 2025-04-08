import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IngresosScreen extends StatefulWidget {
  @override
  _IngresosScreenState createState() => _IngresosScreenState();
}

class _IngresosScreenState extends State<IngresosScreen> {
  final Color colorPrimario = Colors.blue;
  final Color colorFondo = Color(0xFFF5F5F5);
  final Color colorTarjeta = Colors.white;
  final Color colorTextoSecundario = Color(0xFFA0A0A0);

  final TextEditingController montoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController notaController = TextEditingController();
  String? categoriaSeleccionada;
  final List<String> categorias = ['Salario', 'Freelance', 'Otros'];
  DateTime? fechaSeleccionada;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variable para el saldo total
  double saldoTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarSaldo();
  }

  // Cargar el saldo del usuario desde Firebase
  Future<void> _cargarSaldo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('SaldoUsuario').doc(user.uid).get();

      if (snapshot.exists) {
        setState(() {
          saldoTotal = snapshot['saldo']?.toDouble() ?? 0.0;
        });
      }
    }
  }

  // Actualizar el saldo en Firebase
  Future<void> _actualizarSaldo(double monto, bool esIngreso) async {
    User? user = _auth.currentUser;
    if (user != null) {
      double nuevoSaldo = esIngreso ? saldoTotal + monto : saldoTotal - monto;

      await _firestore.collection('SaldoUsuario').doc(user.uid).set({
        'saldo': nuevoSaldo,
      });

      setState(() {
        saldoTotal = nuevoSaldo;
      });
    }
  }

  // Agregar un ingreso a Firebase
  Future<void> _agregarIngreso() async {
    if (montoController.text.isEmpty ||
        fechaSeleccionada == null ||
        categoriaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor complete todos los campos requeridos'),
        ),
      );
      return;
    }

    User? user = _auth.currentUser;
    if (user != null) {
      try {
        double monto = double.parse(montoController.text);

        // Obtener el documento de SaldoUsuario
        DocumentSnapshot snapshot =
            await _firestore.collection('SaldoUsuario').doc(user.uid).get();

        // Agregar el ingreso al arreglo de ingresos
        if (snapshot.exists) {
          List<Map<String, dynamic>> ingresos = List.from(
            snapshot['ingresos'] ?? [],
          );
          ingresos.add({
            'monto': monto,
            'categoria': categoriaSeleccionada,
            'fecha': fechaSeleccionada,
            'nota': notaController.text,
          });

          // Actualizar el documento de SaldoUsuario
          await _firestore.collection('SaldoUsuario').doc(user.uid).set({
            'saldo': snapshot['saldo'] + monto,
            'ingresos': ingresos,
          }, SetOptions(merge: true));
        } else {
          // Crear un nuevo documento de SaldoUsuario
          await _firestore.collection('SaldoUsuario').doc(user.uid).set({
            'saldo': monto,
            'ingresos': [
              {
                'monto': monto,
                'categoria': categoriaSeleccionada,
                'fecha': fechaSeleccionada,
                'nota': notaController.text,
              },
            ],
          });
        }

        await _cargarSaldo();

        // Limpiar los campos
        montoController.clear();
        fechaController.clear();
        notaController.clear();
        setState(() {
          categoriaSeleccionada = null;
          fechaSeleccionada = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ingreso agregado correctamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al agregar ingreso: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        backgroundColor: colorPrimario,
        foregroundColor: Colors.white,
        title: const Text('Ingresos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: colorPrimario,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Saldo Actual', style: TextStyle(color: colorTarjeta)),
                    Text(
                      '\$${saldoTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _tarjetaFormulario(),
            const SizedBox(height: 20),
            _tarjetaIngresosRecientes(),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaFormulario() {
    return Card(
      color: colorTarjeta,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tituloSeccion(Icons.add, 'Agregar Ingreso'),
            const SizedBox(height: 16),
            _campoTexto('Monto', montoController, TextInputType.number),
            const SizedBox(height: 16),
            _campoFecha(),
            const SizedBox(height: 16),
            _campoDropdown(),
            const SizedBox(height: 16),
            _campoTexto('Nota (Opcional)', notaController),
            const SizedBox(height: 16),
            _botonAgregarIngreso(),
          ],
        ),
      ),
    );
  }

  Widget _tituloSeccion(IconData icon, String titulo) {
    return Row(
      children: [
        Icon(icon, color: colorPrimario),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _campoTexto(
    String label,
    TextEditingController controller, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: TextStyle(color: colorTextoSecundario),
      ),
    );
  }

  Widget _campoFecha() {
    return TextField(
      controller: fechaController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Fecha',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: Icon(Icons.calendar_today, color: colorPrimario),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            fechaSeleccionada = pickedDate;
            fechaController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
    );
  }

  Widget _campoDropdown() {
    return DropdownButtonFormField<String>(
      value: categoriaSeleccionada,
      items:
          categorias.map((categoria) {
            return DropdownMenuItem(value: categoria, child: Text(categoria));
          }).toList(),
      decoration: InputDecoration(
        labelText: 'Seleccionar Categoría',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: (value) => setState(() => categoriaSeleccionada = value),
    );
  }

  Widget _botonAgregarIngreso() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text('Agregar Ingreso'),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorPrimario,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: _agregarIngreso,
    );
  }

  Widget _tarjetaIngresosRecientes() {
    User? user = _auth.currentUser;

    if (user == null) {
      return Center(child: Text('Usuario no autenticado'));
    }

    return Card(
      color: colorTarjeta,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tituloSeccion(Icons.history, 'Transacciones Recientes'),
            const SizedBox(height: 16),
            StreamBuilder<DocumentSnapshot>(
              stream:
                  _firestore
                      .collection('SaldoUsuario')
                      .doc(user.uid)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data?.data() == null) {
                  return Center(child: Text('No hay ingresos registrados'));
                }

                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                List<Map<String, dynamic>> ingresos = List.from(
                  data['ingresos'] ?? [],
                );

                if (ingresos.isEmpty) {
                  return Center(child: Text('No hay ingresos registrados'));
                }

                return Column(
                  children:
                      ingresos.map((ingreso) {
                        DateTime fecha =
                            (ingreso['fecha'] as Timestamp).toDate();

                        return ListTile(
                          title: Text(
                            '\$${ingreso['monto'].toStringAsFixed(2)} - ${ingreso['categoria']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            DateFormat('yyyy-MM-dd').format(fecha),
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
