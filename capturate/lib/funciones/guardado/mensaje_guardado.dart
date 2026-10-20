import 'package:flutter/material.dart';

import 'package:capturate/funciones/guardado/servicio_guardado.dart';
import 'package:capturate/nucleo/widgets/dialogo_permiso.dart';

/// Informa al usuario cómo terminó el guardado.
void mostrarResultadoGuardado(BuildContext context, ResultadoGuardado resultado) {
  final mensaje = switch (resultado) {
    ResultadoGuardado.guardada =>
      'Imagen guardada en tu galería (álbum ${ServicioGuardado.nombreAlbum}).',
    ResultadoGuardado.sinEspacio =>
      'No hay espacio suficiente para guardar la imagen.',
    ResultadoGuardado.noSoportado =>
      'Guardar en la galería no está disponible en la versión web.',
    ResultadoGuardado.error =>
      'No se pudo guardar la imagen. Inténtalo de nuevo.',
    ResultadoGuardado.accesoDenegado => null,
  };

  if (mensaje == null) {
    DialogoPermiso.mostrar(
      context,
      mensaje: 'Para guardar la imagen necesitamos acceso a tu galería. '
          'Puedes activarlo en los ajustes de la aplicación.',
    );
    return;
  }

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(mensaje)));
}
