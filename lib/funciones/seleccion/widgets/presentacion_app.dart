import 'package:flutter/material.dart';

/// Nombre y descripción de la app, centrados en la pantalla de inicio.
class PresentacionApp extends StatelessWidget {
  const PresentacionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.photo_filter_outlined, size: 64, color: tema.colorScheme.primary),
          const SizedBox(height: 16),
          Text('Capturate', style: tema.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Toma o elige una foto, aplica un filtro y guárdala en tu galería.',
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyLarge?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
