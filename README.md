# Gestor de Ventas Flutter

Aplicación móvil de gestión de ventas desarrollada en **Flutter**, utilizando **Riverpod** para el manejo de estado, **SQLite** para almacenamiento local y **Firebase** (Firestore y Auth) para sincronización remota y autenticación.

---

##  Características

* **Autenticación** con email/contraseña (Firebase Auth)
* **CRUD** de productos:

  * Agregar, editar y eliminar productos
  * Sincronización en tiempo real entre SQLite local y Firestore remoto
* **Registro de ventas**:

  * Selección de producto desde un dropdown
  * Validación de stock disponible
  * Cálculo automático del total (precio × cantidad)
  * Eliminación de ventas deslizando (Dismissible)
  * Actualización automática del stock tras cada venta
* **Tema personalizado** en tonos púrpura
* **Validaciones** y mensajes de error con `SnackBar`
* **Responsive UI**: formularios centrados y scrollables

---

##  Instalación

1. **Clonar el repositorio**:

   ```bash
   git clone https://github.com/musaggeta/app_ventas.git
   cd app_ventas
   ```

2. **Instalar dependencias**:

   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**:

   * Añadir tus archivos `google-services.json` (Android) y `GoogleService-Info.plist` (iOS) en sus respectivas carpetas.
   * Asegurarte de tener habilitados Firestore y Auth en la consola de Firebase.

4. **Ejecutar en un dispositivo/emulador**:

   ```bash
   flutter run
   ```

---

## 📱 Uso

1. **Registro / Login**:

   * Pantalla de registro con validaciones de formato.
   * Tras registrarse, el usuario debe iniciar sesión.
2. **Pantalla principal**:

   * Navegación a través de `Drawer` entre Productos y Ventas.
3. **Productos**:

   * Lista de productos sincronizados.
   * Botón flotante para agregar nuevos.
   * Swipe para eliminar y diálogo para editar.
4. **Ventas**:

   * Lista de ventas registradas.
   * Swipe para eliminar.
   * Botón flotante para registrar una venta: elegir producto, cantidad y ver total.

---

##  Estructura del proyecto

```
lib/
├─ application/      # Providers (auth, producto, venta)
├─ auth/             # Páginas de login y registro
├─ data/
│  ├─ local/         # Bases de datos SQLite
│  ├─ remote/        # DataSources Firestore
│  └─ repository/    # Repositorios que unen local y remoto
├─ models/           # Clases Producto y Venta
├─ presentation/
│  ├─ pages/         # Widgets de UI (productos, ventas, forms)
│  └─ utils/         # Utilidades (snackbar)
└─ main.dart         # Punto de entrada con AuthWrapper
```

---

##  Generar APK

Para crear el APK de release:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

El archivo resultante estará en `build/app/outputs/flutter-apk/app-release.apk`.

---

##  Licencia

Proyecto de ejemplo para fines académicos.
