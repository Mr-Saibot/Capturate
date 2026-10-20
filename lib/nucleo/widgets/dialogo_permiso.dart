import 'package:flutter/material.dart';

import 'package:capturate/nucleo/permisos/servicio_permisos.dart';

/// Diálogo que explica por qué falta un permiso y lleva al usuario a los ajustes.
class DialogoPermiso extends StatelessWidget {
  const DialogoPermiso({super.key, required this.mensaje});

  final String mensaje;

  static Future<void> mostrar(BuildContext context, {required String mensaje}) {
    return showDialog<void>(
      context: context,
      builder: (_) => DialogoPermiso(mensaje: mensaje),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Permiso necesario'),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            const ServicioPermisos().abrirAjustes();
          },
          child: const Text('Abrir ajustes'),
        ),
      ],
    );
  }
}
