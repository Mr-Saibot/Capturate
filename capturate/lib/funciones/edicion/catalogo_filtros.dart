import 'dart:ui' show Color;

import 'package:flutter_image_filters/flutter_image_filters.dart';

/// Un filtro de la barra: su nombre y cómo construir su configuración de shader.
class Filtro {
  const Filtro({required this.nombre, required this.crearConfiguracion});

  final String nombre;
  final ShaderConfiguration Function() crearConfiguracion;
}

/// Catálogo de filtros disponibles. Para agregar uno basta con sumar una entrada.
final List<Filtro> catalogoFiltros = [
  Filtro(nombre: 'Original', crearConfiguracion: NoneShaderConfiguration.new),
  Filtro(nombre: 'Blanco y negro', crearConfiguracion: GrayscaleShaderConfiguration.new),
  Filtro(nombre: 'Sepia', crearConfiguracion: _crearSepia),
  Filtro(nombre: 'Vívido', crearConfiguracion: _crearVivido),
  Filtro(nombre: 'Contraste', crearConfiguracion: _crearContraste),
  Filtro(nombre: 'Póster', crearConfiguracion: _crearPoster),
  Filtro(nombre: 'Negativo', crearConfiguracion: ColorInvertShaderConfiguration.new),
];

ShaderConfiguration _crearSepia() {
  return MonochromeShaderConfiguration()
    ..color = const Color.fromRGBO(153, 115, 77, 1)
    ..intensity = 1.0;
}

ShaderConfiguration _crearVivido() {
  return SaturationShaderConfiguration()..saturation = 1.6;
}

ShaderConfiguration _crearContraste() {
  return ContrastShaderConfiguration()..contrast = 1.4;
}

ShaderConfiguration _crearPoster() {
  return PosterizeShaderConfiguration()..colorLevels = 5.0;
}
