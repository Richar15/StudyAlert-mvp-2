import 'package:flutter/material.dart';
import 'package:studyalert_mvp_2/task/task_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskCard extends StatelessWidget {
  final TaskModel tarea;
  final VoidCallback onCompletar;

  const TaskCard({
    super.key,
    required this.tarea,
    required this.onCompletar,
  });

  void _abrirEnlace() async {
    final uri = Uri.parse(tarea.enlace);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('No se pudo abrir el enlace: ${tarea.enlace}');
    }
  }

  Future<void> _mostrarDobleConfirmacion(BuildContext context) async {

    const TextStyle buttonTextStyle = TextStyle(
      color: Color(0xFF62A8EA),
      fontWeight: FontWeight.w600,
      fontSize: 16,
      shadows: [
        Shadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          color: Colors.black26,
        ),
      ],
    );

    bool? primeraConfirmacion = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Completado'),
          content: Text('¿Estás seguro de que quieres marcar "${tarea.tipoActividad}" como completada?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No confirmar
              child: const Text('Cancelar', style: buttonTextStyle), // Aplicar estilo
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirmar
              child: const Text('Sí, estoy seguro', style: buttonTextStyle), // Aplicar estilo
            ),
          ],
        );
      },
    );

    if (primeraConfirmacion == true) {
      // Segunda confirmación
      bool? segundaConfirmacion = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('¡Última Confirmación!'),
            content: Text('¿Realmente quieres completar "${tarea.tipoActividad}"? Esta acción no se puede deshacer.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // No confirmar
                child: const Text('No, espera', style: buttonTextStyle), // Aplicar estilo
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Confirmar
                child: const Text('Sí, completar ahora', style: buttonTextStyle), // Aplicar estilo
              ),
            ],
          );
        },
      );

      if (segundaConfirmacion == true) {
        onCompletar(); // Ejecutar la acción solo si ambas confirmaciones son positivas
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 6, // Aumentar elevación para más profundidad
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Bordes más redondeados
      child: Padding(
        padding: const EdgeInsets.all(18), // Más padding interno
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tarea.tipoActividad,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800, // Más negrita
                color: Color(0xFF2B2B2C), // Color oscuro para contraste
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 6,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Más espacio
            Text(
              "Asignatura: ${tarea.asignatura}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black12,
                  ),
                ],
              ),
            ),
            Text(
              "Vence: ${tarea.fechaVencimiento.toLocal().toString().split(' ')[0]}", // Formato de fecha más simple
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black12,
                  ),
                ],
              ),
            ),
            Text(
              "Tiempo restante: ${tarea.tiempoRestante}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black12,
                  ),
                ],
              ),
            ),
            Text(
              "Estado: ${tarea.estado}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black12,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Más espacio antes de los botones
            Wrap(
              spacing: 10, // Más espacio entre botones
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => _mostrarDobleConfirmacion(context), // Llama a la función de doble confirmación
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF62A8EA), // Color de la app
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    elevation: 4,
                  ),
                  child: const Text(
                    "Marcar como completado",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _abrirEnlace,
                  icon: const Icon(Icons.open_in_new, color: Color(0xFF62A8EA)),
                  label: const Text(
                    "Abrir enlace",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF62A8EA),
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF62A8EA), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    elevation: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
