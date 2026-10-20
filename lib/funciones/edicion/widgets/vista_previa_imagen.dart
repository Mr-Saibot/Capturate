import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:provider/provider.dart';

import 'package:capturate/funciones/edicion/controlador_edicion.dart';

/// Imagen con el filtro activo aplicado en tiempo real. Admite zoom con los dedos.
class VistaPreviaImagen extends StatelessWidget {
  const VistaPreviaImagen({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = context.watch<ControladorEdicion>();
    final textura = controlador.vistaPrevia;

    if (controlador.huboError) {
      return const Center(
        child: Text('No se pudo preparar la imagen para editar.'),
      );
    }
    if (textura == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return InteractiveViewer(
      maxScale: 5,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: SizedBox.expand(
          key: ValueKey(controlador.filtroActivo.nombre),
          child: ImageShaderPreview(
            texture: textura,
            configuration: controlador.configuracionActiva,
          ),
        ),
      ),
    );
  }
}
