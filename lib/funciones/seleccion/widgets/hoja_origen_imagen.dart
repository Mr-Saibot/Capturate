import 'package:flutter/material.dart';

import 'package:capturate/funciones/seleccion/servicio_selector_imagen.dart';

/// Hoja inferior con los dos caminos: tomar una foto o elegir de la galería.
class HojaOrigenImagen extends StatelessWidget {
  const HojaOrigenImagen({super.key});

  /// Muestra la hoja y devuelve el origen elegido, o `null` si se cierra.
  static Future<OrigenImagen?> mostrar(BuildContext context) {
    return showModalBottomSheet<OrigenImagen>(
      context: context,
      builder: (_) => const HojaOrigenImagen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Tomar foto'),
            onTap: () => Navigator.pop(context, OrigenImagen.camara),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Elegir de la galería'),
            onTap: () => Navigator.pop(context, OrigenImagen.galeria),
          ),
        ],
      ),
    );
  }
}
