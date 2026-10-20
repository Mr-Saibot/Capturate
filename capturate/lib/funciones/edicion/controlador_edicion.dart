
import 'package:flutter/foundation.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

import 'package:capturate/funciones/edicion/catalogo_filtros.dart';
import 'package:capturate/funciones/edicion/servicio_filtros.dart';
import 'package:capturate/funciones/guardado/servicio_guardado.dart';

/// Estado de la pantalla de edición: filtro activo, vista previa y guardado.
class ControladorEdicion extends ChangeNotifier {
  ControladorEdicion({
    required this.bytesImagen,
    ServicioFiltros servicioFiltros = const ServicioFiltros(),
    ServicioGuardado servicioGuardado = const ServicioGuardado(),
  })  : _servicioFiltros = servicioFiltros,
        _servicioGuardado = servicioGuardado,
        _filtroActivo = catalogoFiltros.first;

  final Uint8List bytesImagen;
  final ServicioFiltros _servicioFiltros;
  final ServicioGuardado _servicioGuardado;

  /// Una configuración por filtro, creada la primera vez que se usa.
  final Map<Filtro, ShaderConfiguration> _configuraciones = {};

  TextureSource? _vistaPrevia;
  Filtro _filtroActivo;
  bool _huboError = false;
  bool _guardando = false;
  bool _guardada = false;
  bool _descartado = false;

  TextureSource? get vistaPrevia => _vistaPrevia;
  Filtro get filtroActivo => _filtroActivo;
  bool get huboError => _huboError;
  bool get guardando => _guardando;
  bool get listo => _vistaPrevia != null;

  /// Paso del flujo Seleccionar → Editar → Guardar.
  int get pasoActual => _guardada ? 3 : 2;

  ShaderConfiguration get configuracionActiva {
    return _configuraciones.putIfAbsent(
      _filtroActivo,
      _filtroActivo.crearConfiguracion,
    );
  }

  Future<void> cargarVistaPrevia() async {
    try {
      _vistaPrevia = await _servicioFiltros.cargarVistaPrevia(bytesImagen);
    } catch (_) {
      _huboError = true;
    }
    _notificar();
  }

  void seleccionarFiltro(Filtro filtro) {
    if (filtro == _filtroActivo) return;
    _filtroActivo = filtro;
    _guardada = false;
    _notificar();
  }

  Future<ResultadoGuardado> guardar() async {
    _guardando = true;
    _notificar();

    try {
      final png = await _servicioFiltros.exportarPng(
        bytesImagen,
        configuracionActiva,
      );
      final resultado = await _servicioGuardado.guardar(png);
      _guardada = resultado == ResultadoGuardado.guardada;
      return resultado;
    } catch (_) {
      // Cualquier fallo al exportar se informa al usuario sin romper la app.
      return ResultadoGuardado.error;
    } finally {
      _guardando = false;
      _notificar();
    }
  }

  @override
  void dispose() {
    _descartado = true;
    for (final configuracion in _configuraciones.values) {
      configuracion.dispose();
    }
    super.dispose();
  }

  /// Evita notificar si la pantalla se cerró mientras había una tarea en curso.
  void _notificar() {
    if (!_descartado) notifyListeners();
  }
}
