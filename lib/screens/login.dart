// importando la liberia material
import 'package:flutter/material.dart';

class login extends StatelessWidget {
  const login({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 43, 247, 230),
        title: const Text("Contactenos"),
      ),
      body: const Text("Programación movil II "),
    );
  }
} // fin de la clase
