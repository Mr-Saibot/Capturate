import 'package:flutter/material.dart';

/// Muestra el flujo Seleccionar → Editar → Guardar y resalta el paso actual.
class IndicadorPasos extends StatelessWidget {
  const IndicadorPasos({super.key, required this.pasoActual});

  /// Paso resaltado, de 1 a 3.
  final int pasoActual;

  static const List<String> _nombres = ['Seleccionar', 'Editar', 'Guardar'];

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < _nombres.length; i++) ...[
          if (i > 0) Icon(Icons.chevron_right, size: 18, color: colores.outline),
          Text(
            '${i + 1}. ${_nombres[i]}',
            style: TextStyle(
              fontWeight: i + 1 == pasoActual ? FontWeight.w600 : FontWeight.normal,
              color: i + 1 == pasoActual ? colores.primary : colores.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
