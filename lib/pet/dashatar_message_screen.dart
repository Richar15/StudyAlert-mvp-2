import 'package:flutter/material.dart';
import 'package:dashatar_flutter/dashatar_flutter.dart';
import 'package:studyalert_mvp_2/pet/run_logic_pet.dart'; // Necesario para DashatarType


class DashatarMessageScreen extends StatelessWidget {
  const DashatarMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Fondo de la pantalla
      appBar: AppBar(
        title: const Text(
          'Mascota Dashatar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent, // Color de la AppBar
        elevation: 4,
      ),
      body: Center(
        child: DashatarMascot(
          message: '¡Vaya! 😅 Tienes muchas tareas pendientes, ¡a trabajar! 📚⏰',
          dashatarIndex: 5,
          dashatarType: DashatarType.developer,
          bubbleAlignment: BubbleAlignment.bottomCenter,
        ),
      ),
    );
  }
}
