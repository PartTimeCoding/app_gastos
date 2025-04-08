import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final List<String> categorias = ['Alquiler', 'Comida', 'Transporte', 'Otros'];
  DateTime? fechaSeleccionada;
  String? metodoPagoSeleccionado;
  final List<String> metodosPago = [
    'Efectivo',
    'Tarjeta de crédito',
    'Tarjeta de débito',
  ];

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
  Future<void> _actualizarSaldo(double monto, bool esGasto) async {
    User? user = _auth.currentUser;
    if (user != null) {
      double nuevoSaldo = esGasto ? saldoTotal - monto : saldoTotal + monto;

      await _firestore.collection('SaldoUsuario').doc(user.uid).set({
        'saldo': nuevoSaldo,
      });

      setState(() {
        saldoTotal = nuevoSaldo;
      });
    }
  }

  // Agregar un gasto a Firebase
  Future<void> _agregarGasto() async {
    if (montoController.text.isEmpty ||
        fechaSeleccionada == null ||
        categoriaSeleccionada == null ||
        metodoPagoSeleccionado == null) {
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

        // Agregar el gasto al arreglo de gastos
        if (snapshot.exists) {
          List<Map<String, dynamic>> gastos = List.from(
            snapshot['gastos'] ?? [],
          );
          gastos.add({
            'monto': monto,
            'categoria': categoriaSeleccionada,
            'fecha': fechaSeleccionada,
            'metodoPago': metodoPagoSeleccionado,
            'nota': notaController.text,
          });

          // Actualizar el documento de SaldoUsuario
          await _firestore.collection('SaldoUsuario').doc(user.uid).set({
            'saldo': snapshot['saldo'] - monto,
            'gastos': gastos,
          }, SetOptions(merge: true));
        } else {
          // Crear un nuevo documento de SaldoUsuario
          await _firestore.collection('SaldoUsuario').doc(user.uid).set({
            'saldo': -monto,
            'gastos': [
              {
                'monto': monto,
                'categoria': categoriaSeleccionada,
                'fecha': fechaSeleccionada,
                'metodoPago': metodoPagoSeleccionado,
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
          metodoPagoSeleccionado = null;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gasto agregado correctamente')));
      } catch (e) {
        {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error al agregar gasto: $e')));
        }
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
        title: const Text('Gastos'),
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
                onPressed: _agregarGasto,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGastosRecientes() {
    User? user = _auth.currentUser;

    if (user == null) {
      return Center(child: Text('Usuario no autenticado'));
    }

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
                  Icon(Icons.edit, color: colorPrimario),
                  SizedBox(width: 8),
                  Text(
                    'Transacciones recientes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),
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
                    return Center(child: Text('No hay gastos registrados'));
                  }

                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  List<Map<String, dynamic>> gastos = List.from(
                    data['gastos'] ?? [],
                  );

                  if (gastos.isEmpty) {
                    return Center(child: Text('No hay gastos registrados'));
                  }

                  return Column(
                    children:
                        gastos.map((gasto) {
                          DateTime fecha =
                              (gasto['fecha'] as Timestamp).toDate();

                          return ListTile(
                            title: Text(
                              '\$${gasto['monto'].toStringAsFixed(2)} - ${gasto['categoria']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${DateFormat('yyyy-MM-dd').format(fecha)} - ${gasto['metodoPago']}',
                            ),
                          );
                        }).toList(),
                  );
                },
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
