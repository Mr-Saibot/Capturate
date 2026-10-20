import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_image_filters/flutter_image_filters.dart';

/// Aísla el plugin `flutter_image_filters` del resto de la aplicación.
class ServicioFiltros {
  const ServicioFiltros();

  /// Ancho de la versión reducida que se muestra en pantalla. Con ella los
  /// filtros se recalculan en tiempo real incluso en teléfonos modestos.
  static const int _anchoVistaPrevia = 1080;

  /// Carga la imagen en tamaño reducido para la vista previa.
  Future<TextureSource> cargarVistaPrevia(Uint8List bytes) {
    return TextureSource.fromMemory(
      bytes,
      targetSize: const ui.TargetImageSize(width: _anchoVistaPrevia),
    );
  }

  /// Aplica el filtro sobre la imagen en su resolución completa y la devuelve como PNG.
  Future<Uint8List> exportarPng(
    Uint8List bytes,
    ShaderConfiguration configuracion,
  ) async {
    final textura = await TextureSource.fromMemory(bytes);
    final imagen = await configuracion.export(textura, textura.size);
    try {
      final datos = await imagen.toByteData(format: ui.ImageByteFormat.png);
      if (datos == null) {
        throw const FormatException('No se pudo codificar la imagen como PNG.');
      }
      return datos.buffer.asUint8List();
    } finally {
      imagen.dispose();
    }
  }
}
