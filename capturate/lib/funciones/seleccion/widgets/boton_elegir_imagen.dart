import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:capturate/funciones/edicion/pantalla_edicion.dart';
import 'package:capturate/funciones/seleccion/controlador_seleccion.dart';
import 'package:capturate/funciones/seleccion/widgets/hoja_origen_imagen.dart';
import 'package:capturate/nucleo/widgets/dialogo_permiso.dart';

/// Botón principal: despliega las dos opciones y, con la imagen, pasa a editar.
class BotonElegirImagen extends StatelessWidget {
  const BotonElegirImagen({super.key});

  @override
  Widget build(BuildContext context) {
    final ocupado = context.select<ControladorSeleccion, bool>((c) => c.ocupado);

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: ocupado ? null : () => _elegirImagen(context),
        icon: ocupado
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add_photo_alternate_outlined),
        label: const Text('Elegir imagen'),
      ),
    );
  }

  Future<void> _elegirImagen(BuildContext context) async {
    final origen = await HojaOrigenImagen.mostrar(context);
    if (origen == null || !context.mounted) return;

    final resultado = await context.read<ControladorSeleccion>().elegir(origen);
    if (!context.mounted) return;

    switch (resultado) {
      case ImagenElegida(:final bytes):
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => PantallaEdicion(bytesImagen: bytes),
          ),
        );
      case SeleccionCancelada():
        break;
      case PermisoCamaraDenegado():
        _mostrarMensaje(context, 'Sin el permiso de cámara no se puede tomar la foto.');
      case PermisoCamaraBloqueado():
        DialogoPermiso.mostrar(
          context,
          mensaje: 'El permiso de cámara está bloqueado. '
              'Actívalo en los ajustes de la aplicación para tomar fotos.',
        );
      case ErrorSeleccion():
        _mostrarMensaje(context, 'No se pudo obtener la imagen. Inténtalo de nuevo.');
    }
  }

  void _mostrarMensaje(BuildContext context, String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }
}
