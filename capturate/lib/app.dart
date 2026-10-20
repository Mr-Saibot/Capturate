import 'package:flutter/material.dart';

import 'package:capturate/funciones/seleccion/pantalla_seleccion.dart';
import 'package:capturate/nucleo/tema/tema_app.dart';

/// Raíz de la aplicación: define el tema y la pantalla inicial.
class AplicacionCapturate extends StatelessWidget {
  const AplicacionCapturate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capturate',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.oscuro,
      home: const PantallaSeleccion(),
    );
  }
}
