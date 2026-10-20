import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:capturate/funciones/edicion/catalogo_filtros.dart';
import 'package:capturate/funciones/edicion/controlador_edicion.dart';

/// Barra inferior desplazable con los filtros del catálogo.
class BarraFiltros extends StatelessWidget {
  const BarraFiltros({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = context.watch<ControladorEdicion>();

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: catalogoFiltros.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, indice) {
          final filtro = catalogoFiltros[indice];
          return ChoiceChip(
            label: Text(filtro.nombre),
            selected: filtro == controlador.filtroActivo,
            onSelected: controlador.listo
                ? (_) => controlador.seleccionarFiltro(filtro)
                : null,
          );
        },
      ),
    );
  }
}
