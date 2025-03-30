import 'package:flutter/material.dart';

class Contactenos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacto',
      home: SupportScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SupportScreen extends StatefulWidget {
  @override
  _SoportScreenState createState() => _SoportScreenState();
}

class _SoportScreenState extends State<SupportScreen> {
  final Color primaryColor = Color.fromARGB(255, 76, 110, 244);
  final Color mainBackgroundColor = Color.fromARGB(255, 245, 245, 245);
  final Color cardColor = Color.fromARGB(255, 255, 255, 255);
  final Color primaryTextColor = Color.fromARGB(255, 0, 0, 0);
  final Color secondaryTextColor = Color.fromARGB(255, 160, 160, 160);
  String? selectedIssue;
  final TextEditingController consultaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30),
              color: primaryColor,
              child: Center(
                child: Text(
                  'Contacto de Soporte',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card.filled(
                elevation: 4,
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.help_outlined, color: primaryColor),
                          SizedBox(width: 8),
                          Text(
                            'Preguntas Frecuentes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              //1
                              '¿Cómo registro mis ingresos?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Ve a la sección de Ingresos y completa el formulario con los detalles de tu ingreso.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 92, 92, 92),
                              ),
                            ),
                            Divider(),

                            Text(
                              //2
                              '¿Puedo editar un gasto después de registrarlo?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Si, en la pantalla de Gastos puedes editar o eliminar gastos recientes',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 92, 92, 92),
                              ),
                            ),
                            Divider(),

                            Text(
                              //3
                              '¿Cómo genero un reporte financiero?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Navega a la sección de Imprimir Reporte y selecciona el período deseado',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 92, 92, 92),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card.filled(
                color: cardColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_outlined,
                            color: primaryColor,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Enviar Consulta',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Nombre Completo',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: secondaryTextColor),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: secondaryTextColor),
                        ),
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedIssue,
                        dropdownColor: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        items:
                            [
                              'Inicio de sesión',
                              'Restablecimiento de contraseña',
                              'Problemas de conección',
                              'Problemas de sincronización de datos',
                              'Otro',
                            ].map((issue) {
                              return DropdownMenuItem(
                                value: issue,
                                child: Text(issue),
                              );
                            }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Seleccionar Asunto',
                          labelStyle: TextStyle(color: primaryTextColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedIssue = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        maxLines: 4,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          labelText: ('Describe tu consulta o problema'),
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: secondaryTextColor),
                          alignLabelWithHint: true,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: Icon(Icons.send_sharp, color: Colors.white),
                        label: Text('Enviar Consulta'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: primaryColor,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: Card.filled(
                  color: cardColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Información de Contacto',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Correo: ***************@mail.com',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Teléfono: +***********',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Horario: ************',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
