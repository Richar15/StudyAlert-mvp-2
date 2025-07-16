import 'package:flutter/material.dart';
import 'package:dashatar_flutter/dashatar_flutter.dart';

// Enum para la alineación de la punta del globo
enum BubbleAlignment {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  bottomCenter,
  topCenter,
  leftCenter,
  rightCenter,
}

/// Globo de diálogo con estilo de chat y más color
class ComicBubble extends StatelessWidget {
  final String message;
  final BubbleAlignment alignment;
  final double fontSize; // Nuevo parámetro para el tamaño de la fuente

  const ComicBubble({
    super.key,
    required this.message,
    this.alignment = BubbleAlignment.bottomLeft,
    this.fontSize = 16, // Tamaño de fuente por defecto
  });

  @override
  Widget build(BuildContext context) {
    const Color bubbleColor = Color(0xFFE0F7FA); // Un azul claro muy suave (Cyan 50)
    const Color textColor = Color(0xFF004D40); // Un verde azulado oscuro (Teal 900)

    // Determinar padding basado en el tamaño de la fuente para mejor escalado
    final double horizontalPadding = fontSize * 1.25;
    final double verticalPadding = fontSize * 0.9;

    // Determinar la posición del triángulo relativa al cuerpo del globo
    double triangleLeft = 0;
    double triangleRight = 0;
    double triangleTop = 0;
    double triangleBottom = 0;
    AlignmentGeometry bubbleAlignment;

    switch (alignment) {
      case BubbleAlignment.bottomCenter:
        bubbleAlignment = Alignment.topCenter; // El cuerpo del globo está encima del triángulo
        triangleBottom = -10; // El triángulo se extiende por debajo del globo
        triangleLeft = 0; // Centrado horizontalmente
        triangleRight = 0;
        break;
      case BubbleAlignment.bottomLeft:
        bubbleAlignment = Alignment.topLeft;
        triangleBottom = -10;
        triangleLeft = 15; // Desplazamiento desde la izquierda
        break;
      case BubbleAlignment.bottomRight:
        bubbleAlignment = Alignment.topRight;
        triangleBottom = -10;
        triangleRight = 15; // Desplazamiento desde la derecha
        break;
      case BubbleAlignment.topCenter:
        bubbleAlignment = Alignment.bottomCenter;
        triangleTop = -10;
        triangleLeft = 0;
        triangleRight = 0;
        break;
      case BubbleAlignment.topLeft:
        bubbleAlignment = Alignment.bottomLeft;
        triangleTop = -10;
        triangleLeft = 15;
        break;
      case BubbleAlignment.topRight:
        bubbleAlignment = Alignment.bottomRight;
        triangleTop = -10;
        triangleRight = 15;
        break;
      case BubbleAlignment.leftCenter:
        bubbleAlignment = Alignment.centerRight;
        triangleLeft = -10;
        triangleTop = 0; // Centrado verticalmente
        triangleBottom = 0;
        break;
      case BubbleAlignment.rightCenter:
        bubbleAlignment = Alignment.centerLeft;
        triangleRight = -10;
        triangleTop = 0;
        triangleBottom = 0;
        break;
    }

    return Stack(
      clipBehavior: Clip.none, // Permite que el triángulo se dibuje fuera de los límites
      alignment: bubbleAlignment, // Alinea el cuerpo del globo dentro del stack
      children: [
        // El cuerpo principal del globo
        Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
              height: 1.3,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // La punta del globo
        Positioned(
          left: alignment.toString().contains('Center') || alignment.toString().contains('Left') ? triangleLeft : null,
          right: alignment.toString().contains('Right') ? triangleRight : null,
          top: alignment.toString().contains('Center') || alignment.toString().contains('Top') ? triangleTop : null,
          bottom: alignment.toString().contains('Bottom') ? triangleBottom : null,
          child: CustomPaint(
            painter: BubbleTriangle(
              bubbleColor: bubbleColor,
              alignment: alignment,
            ),
            size: const Size(20, 10), // Tamaño fijo para el triángulo
          ),
        ),
      ],
    );
  }
}

class BubbleTriangle extends CustomPainter {
  final Color bubbleColor;
  final BubbleAlignment alignment;

  BubbleTriangle({required this.bubbleColor, required this.alignment});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = bubbleColor;
    final path = Path();

    switch (alignment) {
      case BubbleAlignment.bottomCenter:
      case BubbleAlignment.bottomLeft:
      case BubbleAlignment.bottomRight:
      // El triángulo apunta hacia abajo (base arriba, punta abajo)
        path.moveTo(size.width / 2, size.height); // Punta
        path.lineTo(0, 0); // Base superior izquierda
        path.lineTo(size.width, 0); // Base superior derecha
        break;
      case BubbleAlignment.topCenter:
      case BubbleAlignment.topLeft:
      case BubbleAlignment.topRight:
      // El triángulo apunta hacia arriba (base abajo, punta arriba)
        path.moveTo(size.width / 2, 0); // Punta
        path.lineTo(0, size.height); // Base inferior izquierda
        path.lineTo(size.width, size.height); // Base inferior derecha
        break;
      case BubbleAlignment.leftCenter:
      // El triángulo apunta hacia la izquierda (base a la derecha, punta a la izquierda)
        path.moveTo(0, size.height / 2); // Punta
        path.lineTo(size.width, 0); // Base superior derecha
        path.lineTo(size.width, size.height); // Base inferior derecha
        break;
      case BubbleAlignment.rightCenter:
      // El triángulo apunta hacia la derecha (base a la izquierda, punta a la derecha)
        path.moveTo(size.width, size.height / 2); // Punta
        path.lineTo(0, 0); // Base superior izquierda
        path.lineTo(0, size.height); // Base inferior izquierda
        break;
    }

    path.close();
    canvas.drawPath(path, paint);

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Widget que encapsula la mascota Dashatar y su globo de texto
class DashatarMascot extends StatelessWidget {
  final String message;
  final int dashatarIndex;
  final DashatarType dashatarType;
  final BubbleAlignment bubbleAlignment;
  final double dashatarHeight; // Nuevo parámetro para la altura de Dashatar
  final double dashatarWidth;  // Nuevo parámetro para el ancho de Dashatar
  final double bubbleFontSize; // Nuevo parámetro para el tamaño de fuente del globo

  const DashatarMascot({
    super.key,
    required this.message,
    this.dashatarIndex = 5,
    this.dashatarType = DashatarType.developer,
    this.bubbleAlignment = BubbleAlignment.bottomCenter,
    this.dashatarHeight = 150, // Tamaño grande por defecto
    this.dashatarWidth = 150,  // Tamaño grande por defecto
    this.bubbleFontSize = 16,  // Tamaño de fuente por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ComicBubble(
          message: message,
          alignment: bubbleAlignment,
          fontSize: bubbleFontSize, // Pasar el tamaño de fuente
        ),
        SizedBox(height: dashatarHeight * 0.1), // Espaciado dinámico
        SizedBox( // Envuelve Dashatar en un SizedBox para controlar su tamaño
          height: dashatarHeight,
          width: dashatarWidth,
          child: Dashatar(
            index: dashatarIndex,
            type: dashatarType,
            // Los parámetros height y width se aplican al SizedBox, no directamente a Dashatar
          ),
        ),
      ],
    );
  }
}
