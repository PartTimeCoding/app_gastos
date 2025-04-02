import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IngresosScreen extends StatefulWidget {
  @override
  _IngresosScreenState createState() => _IngresosScreenState();
}

class _IngresosScreenState extends State<IngresosScreen> {
  final Color primaryColor = Color(0xFF2A5EE8);
  final TextEditingController montoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController notaController = TextEditingController();
  String? categoriaSeleccionada;
  final List<String> categorias = ['Salario', 'Freelance', 'Otros'];
  DateTime? fechaSeleccionada;

  List<Map<String, dynamic>> ingresos = [
    {'monto': 3000, 'categoria': 'Salario', 'fecha': '2024-03-15'},
    {'monto': 500, 'categoria': 'Freelance', 'fecha': '2024-03-20'},
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
                  'Ingresos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildIngresoForm(),
            SizedBox(height: 20),
            _buildIngresosRecientes(),
          ],
        ),
      ),
    );
  }

  Widget _buildIngresoForm() {
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
                'Agregar Ingreso',
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
                label: Text('Agregar Ingreso'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngresosRecientes() {
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
                'Ingresos Recientes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Column(
                children:
                    ingresos.map((ingreso) {
                      return ListTile(
                        title: Text(
                          '\$${ingreso['monto']} - ${ingreso['categoria']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(ingreso['fecha']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {},
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
}
