import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  List<Map<String, dynamic>> ingresos = [
    {'monto': 3000, 'categoria': 'Salario', 'fecha': '2024-03-15'},
    {'monto': 500, 'categoria': 'Freelance', 'fecha': '2024-03-20'},
  ];

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
      onPressed: () {},
    );
  }

  Widget _tarjetaIngresosRecientes() {
    return Card(
      color: colorTarjeta,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tituloSeccion(Icons.history, 'Ingresos Recientes'),
            const SizedBox(height: 16),
            Column(
              children:
                  ingresos.map((ingreso) {
                    return ListTile(
                      title: Text(
                        '\$${ingreso['monto']} - ${ingreso['categoria']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(ingreso['fecha']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
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
    );
  }
}
