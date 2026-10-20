import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// De dónde se obtiene la imagen.
enum OrigenImagen { camara, galeria }

/// Aísla el plugin `image_picker` del resto de la aplicación.
class ServicioSelectorImagen {
  ServicioSelectorImagen() : _selector = ImagePicker();

  final ImagePicker _selector;

  /// Lado máximo en píxeles. Evita cargar en memoria fotos de 50 MP enteras,
  /// lo que en un teléfono de gama de entrada haría la edición muy lenta.
  static const double _ladoMaximo = 2560;

  /// Devuelve los bytes de la imagen elegida, o `null` si el usuario cancela.
  Future<Uint8List?> elegir(OrigenImagen origen) async {
    final archivo = await _selector.pickImage(
      source: origen == OrigenImagen.camara
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: _ladoMaximo,
      maxHeight: _ladoMaximo,
    );
    if (archivo == null) return null;
    return archivo.readAsBytes();
  }
}
