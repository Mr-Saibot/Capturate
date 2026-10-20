# Capturate

Aplicación móvil hecha con Flutter para capturar o importar una foto, aplicarle
filtros en tiempo real y guardar el resultado en la galería del dispositivo.

Solución al reto **FotoMagia**. Plataforma principal: **Android**.

## Flujo de la aplicación

1. **Seleccionar:** un botón principal despliega dos opciones, *Tomar foto* o
   *Elegir de la galería*.
2. **Editar:** la imagen aparece con una barra de filtros en la parte inferior.
   Cada filtro se aplica en tiempo real, sin guardar primero. Se puede hacer zoom
   con los dedos.
3. **Guardar:** la imagen filtrada se guarda en la galería del dispositivo, dentro
   del álbum *Capturate*, y se muestra un mensaje de confirmación.

Un indicador en la parte superior muestra en qué paso está el usuario.

## Plugins elegidos

Se eligió un plugin por categoría, como pide el enunciado.

| Categoría | Plugin | Por qué |
|---|---|---|
| Captura | `image_picker` | Una sola API cubre cámara y galería, y el sistema gestiona buena parte de los permisos. `camera` obligaba a construir toda la interfaz de captura y `photo_manager` es excesivo, porque no se necesita explorar álbumes. |
| Filtros | `flutter_image_filters` | Aplica los filtros con shaders en la GPU, lo que permite verlos en tiempo real. `image` procesa en CPU y se sentiría lento con fotos grandes. |
| Permisos | `permission_handler` | Gestiona el permiso de cámara y distingue entre denegado y denegado permanentemente, para llevar al usuario a los ajustes. |
| Guardado | `gal` | Registra la imagen en la galería real del dispositivo, algo que `path_provider` por sí solo no hace. Su uso fue confirmado como permitido. |

Además se usa `provider` para el estado.

## Arquitectura

```
lib/
├── main.dart
├── app.dart
├── nucleo/        # permisos, tema y widgets compartidos
└── funciones/     # una carpeta por paso: seleccion, edicion, guardado
```

Principios aplicados:

- **Un servicio por plugin.** `ServicioPermisos`, `ServicioSelectorImagen`,
  `ServicioFiltros` y `ServicioGuardado` son los únicos archivos que importan su
  plugin. Cambiar un plugin implica tocar un solo archivo.
- **La lógica fuera de las pantallas.** Cada pantalla tiene un `ChangeNotifier`
  (`ControladorSeleccion`, `ControladorEdicion`) y la interfaz solo reacciona a su
  estado.
- **Árbol de widgets claro.** Las pantallas componen widgets con nombre
  (`VistaPreviaImagen`, `BarraFiltros`, `BotonGuardar`) en lugar de tener un
  `build` largo.
- **Filtros como datos.** `catalogo_filtros.dart` contiene la lista de filtros;
  agregar uno es sumar una entrada.

## Manejo de permisos

- **Cámara:** se pide al tocar *Tomar foto*, no al abrir la app.
  - Denegado: se muestra un mensaje y la app sigue funcionando.
  - Denegado permanentemente: se muestra un diálogo con el botón *Abrir ajustes*.
- **Galería (elegir):** `image_picker` usa el selector del sistema, que no requiere
  un permiso explícito.
- **Guardado:** `gal` pide acceso a la galería la primera vez. Si se niega, se
  explica el motivo y se ofrece ir a los ajustes.
- Los errores al seleccionar, exportar o guardar se capturan y se informan al
  usuario; la aplicación no se cierra.

## Decisiones de rendimiento

- La foto se limita a 2560 px de lado al elegirla, para no cargar imágenes de
  decenas de megapíxeles en memoria.
- La vista previa usa una copia de 1080 px de ancho, de modo que los filtros se
  recalculan con fluidez.
- Al guardar, el filtro se aplica sobre la imagen en su **resolución completa**
  (dentro del límite anterior).

## Filtros disponibles

Original, Blanco y negro, Sepia, Vívido, Contraste, Póster y Negativo.

## Limitaciones conocidas

- **Web:** el plugin `gal` no tiene versión web, por lo que en navegador el botón
  *Guardar* muestra un aviso en lugar de guardar. La aplicación está pensada para
  Android.
- **iOS:** no se probó ni se configuró.

## Bonus incluidos

- Zoom con `InteractiveViewer`.
- Transición animada al cambiar de filtro.

## Cómo ejecutarla

Requisitos: Flutter SDK y un dispositivo o emulador Android.

```bash
flutter pub get
flutter run
```

Para compilar contra el plugin de permisos actual, `pubspec.yaml` fija
`permission_handler_android: ^13.0.0` mediante `dependency_overrides`, porque la
versión 14 exige Android SDK 37.

La configuración nativa está en `android/app/src/main/AndroidManifest.xml`:
permiso de cámara, `WRITE_EXTERNAL_STORAGE` limitado a Android 10 o inferior y
`requestLegacyExternalStorage`.
