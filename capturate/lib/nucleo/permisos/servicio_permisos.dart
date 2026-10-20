import 'package:permission_handler/permission_handler.dart';

/// Resultado simplificado de pedir un permiso.
enum ResultadoPermiso { concedido, denegado, denegadoPermanente }

/// Aísla el plugin `permission_handler` del resto de la aplicación.
class ServicioPermisos {
  const ServicioPermisos();

  /// Pide el permiso de cámara (si ya estaba concedido, responde sin preguntar).
  Future<ResultadoPermiso> solicitarCamara() async {
    final estado = await Permission.camera.request();
    return _traducir(estado);
  }

  /// Abre los ajustes de la aplicación en el sistema.
  Future<void> abrirAjustes() async {
    await openAppSettings();
  }

  ResultadoPermiso _traducir(PermissionStatus estado) {
    if (estado.isGranted) return ResultadoPermiso.concedido;
    if (estado.isPermanentlyDenied) return ResultadoPermiso.denegadoPermanente;
    return ResultadoPermiso.denegado;
  }
}
