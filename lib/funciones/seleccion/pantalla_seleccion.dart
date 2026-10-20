import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:capturate/funciones/seleccion/controlador_seleccion.dart';
import 'package:capturate/funciones/seleccion/widgets/boton_elegir_imagen.dart';
import 'package:capturate/funciones/seleccion/widgets/presentacion_app.dart';
import 'package:capturate/nucleo/widgets/indicador_pasos.dart';

/// Paso 1: el usuario elige entre tomar una foto o importarla de la galería.
class PantallaSeleccion extends StatelessWidget {
  const PantallaSeleccion({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ControladorSeleccion(),
      child: const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                IndicadorPasos(pasoActual: 1),
                Expanded(child: PresentacionApp()),
                BotonElegirImagen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
