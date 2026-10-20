import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';

/// Desenlaces posibles al guardar la imagen en la galería.
enum ResultadoGuardado { guardada, accesoDenegado, sinEspacio, noSoportado, error }

/// Aísla el plugin `gal` del resto de la aplicación.
class ServicioGuardado {
  const ServicioGuardado();

  /// Álbum de la galería donde quedan las imágenes editadas.
  static const String nombreAlbum = 'Capturate';

  Future<ResultadoGuardado> guardar(Uint8List bytesPng) async {
    // `gal` no tiene versión web: allí no existe una galería a la que escribir.
    if (kIsWeb) return ResultadoGuardado.noSoportado;

    try {
      if (!await Gal.hasAccess(toAlbum: true)) {
        final concedido = await Gal.requestAccess(toAlbum: true);
        if (!concedido) return ResultadoGuardado.accesoDenegado;
      }

      await Gal.putImageBytes(
        bytesPng,
        album: nombreAlbum,
        name: 'capturate_${DateTime.now().millisecondsSinceEpoch}',
      );
      return ResultadoGuardado.guardada;
    } on GalException catch (error) {
      return switch (error.type) {
        GalExceptionType.accessDenied => ResultadoGuardado.accesoDenegado,
        GalExceptionType.notEnoughSpace => ResultadoGuardado.sinEspacio,
        GalExceptionType.notSupportedFormat ||
        GalExceptionType.unexpected =>
          ResultadoGuardado.error,
      };
    }
  }
}
