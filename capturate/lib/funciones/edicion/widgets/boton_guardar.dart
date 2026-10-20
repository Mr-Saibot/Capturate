import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:capturate/funciones/edicion/controlador_edicion.dart';
import 'package:capturate/funciones/guardado/mensaje_guardado.dart';

/// Botón de la barra superior que exporta la imagen y la guarda en la galería.
class BotonGuardar extends StatelessWidget {
  const BotonGuardar({super.key});

  @override
  Widget build(BuildContext context) {
    final guardando = context.select<ControladorEdicion, bool>((c) => c.guardando);
    final listo = context.select<ControladorEdicion, bool>((c) => c.listo);

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FilledButton(
        onPressed: guardando || !listo ? null : () => _guardar(context),
        child: guardando
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Guardar'),
      ),
    );
  }

  Future<void> _guardar(BuildContext context) async {
    final resultado = await context.read<ControladorEdicion>().guardar();
    if (!context.mounted) return;
    mostrarResultadoGuardado(context, resultado);
  }
}
