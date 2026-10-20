import 'package:flutter/foundation.dart';

import 'package:capturate/funciones/seleccion/servicio_selector_imagen.dart';
import 'package:capturate/nucleo/permisos/servicio_permisos.dart';

/// Posibles desenlaces de intentar elegir una imagen.
sealed class ResultadoSeleccion {
  const ResultadoSeleccion();
}

final class ImagenElegida extends ResultadoSeleccion {
  const ImagenElegida(this.bytes);

  final Uint8List bytes;
}

final class SeleccionCancelada extends ResultadoSeleccion {
  const SeleccionCancelada();
}

final class PermisoCamaraDenegado extends ResultadoSeleccion {
  const PermisoCamaraDenegado();
}

final class PermisoCamaraBloqueado extends ResultadoSeleccion {
  const PermisoCamaraBloqueado();
}

final class ErrorSeleccion extends ResultadoSeleccion {
  const ErrorSeleccion();
}

/// Coordina permisos y selector de imagen; la pantalla solo reacciona al resultado.
class ControladorSeleccion extends ChangeNotifier {
  ControladorSeleccion({
    ServicioSelectorImagen? selector,
    ServicioPermisos permisos = const ServicioPermisos(),
  })  : _selector = selector ?? ServicioSelectorImagen(),
        _permisos = permisos;

  final ServicioSelectorImagen _selector;
  final ServicioPermisos _permisos;

  bool _ocupado = false;
  bool get ocupado => _ocupado;

  Future<ResultadoSeleccion> elegir(OrigenImagen origen) async {
    // En web el navegador gestiona el permiso de cámara por su cuenta.
    if (origen == OrigenImagen.camara && !kIsWeb) {
      final bloqueo = await _verificarCamara();
      if (bloqueo != null) return bloqueo;
    }

    _cambiarOcupado(true);
    try {
      final bytes = await _selector.elegir(origen);
      return bytes == null ? const SeleccionCancelada() : ImagenElegida(bytes);
    } on Exception {
      return const ErrorSeleccion();
    } finally {
      _cambiarOcupado(false);
    }
  }

  /// Devuelve `null` si se puede usar la cámara, o el motivo por el que no.
  Future<ResultadoSeleccion?> _verificarCamara() async {
    final permiso = await _permisos.solicitarCamara();
    return switch (permiso) {
      ResultadoPermiso.concedido => null,
      ResultadoPermiso.denegado => const PermisoCamaraDenegado(),
      ResultadoPermiso.denegadoPermanente => const PermisoCamaraBloqueado(),
    };
  }

  void _cambiarOcupado(bool valor) {
    _ocupado = valor;
    notifyListeners();
  }
}
