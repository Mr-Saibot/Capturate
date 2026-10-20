import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:capturate/funciones/edicion/controlador_edicion.dart';
import 'package:capturate/funciones/edicion/widgets/barra_filtros.dart';
import 'package:capturate/funciones/edicion/widgets/boton_guardar.dart';
import 'package:capturate/funciones/edicion/widgets/vista_previa_imagen.dart';
import 'package:capturate/nucleo/widgets/indicador_pasos.dart';

/// Pasos 2 y 3: el usuario elige un filtro y guarda el resultado.
class PantallaEdicion extends StatelessWidget {
  const PantallaEdicion({super.key, required this.bytesImagen});

  final Uint8List bytesImagen;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ControladorEdicion(bytesImagen: bytesImagen)..cargarVistaPrevia(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar'),
          actions: const [BotonGuardar()],
        ),
        body: const SafeArea(
          child: Column(
            children: [
              _PasosEdicion(),
              Expanded(child: VistaPreviaImagen()),
              BarraFiltros(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Indicador de pasos que avanza a "Guardar" cuando la imagen ya se guardó.
class _PasosEdicion extends StatelessWidget {
  const _PasosEdicion();

  @override
  Widget build(BuildContext context) {
    final paso = context.select<ControladorEdicion, int>((c) => c.pasoActual);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: IndicadorPasos(pasoActual: paso),
    );
  }
}
