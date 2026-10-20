import 'package:flutter/material.dart';

/// Tema único de la aplicación.
///
/// Es oscuro a propósito: en una app de fotos, el fondo neutro deja que los
/// colores de la imagen sean lo más importante de la pantalla.
class TemaApp {
  const TemaApp._();

  static ThemeData get oscuro {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4F7CAC),
        brightness: Brightness.dark,
      ),
    );
  }
}
