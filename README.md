# emuladornfc

Aplicación Flutter de demostración de **Host Card Emulation (HCE)** para Android. Emula una tarjeta NFC que puede recibir comandos APDU desde lectores NFC, parsear mensajes NDEF y abrir automáticamente las URLs extraídas en el navegador del dispositivo.

> Desarrollado por **Alejano** — `com.example.emuladornfc`

---

## Funcionalidad

- Registra un servicio HCE con el AID `D2760000850101`
- Recibe y procesa comandos APDU (`SELECT APP`, `SELECT NDEF FILE`, `UPDATE BINARY`)
- Parsea mensajes NDEF para extraer registros de tipo URI
- Abre automáticamente la URL extraída en el navegador mediante `Intent.ACTION_VIEW`
- Muestra el estado del servicio NFC y el AID registrado en la pantalla principal

**Prefijos de URL soportados:**

| Código | Prefijo |
|--------|---------|
| `0x01` | `http://www.` |
| `0x02` | `https://www.` |
| `0x03` | `http://` |
| `0x04` | `https://` |

---

## Pantallas

| Pantalla | Descripción |
|----------|-------------|
| **Splash** | Logo con spinner de carga; navega al Home tras 3 segundos |
| **Home** | Muestra el AID registrado e instrucciones de uso del servicio NFC |

---

## Arquitectura

El proyecto sigue **Clean Architecture** con el patrón **BLoC** para la gestión de estado.

```
lib/
├── main.dart
├── core/
│   └── routing/
│       └── app_router.dart          # GoRouter (rutas: / y /home)
└── features/
    ├── splash/
    │   └── presentation/
    │       ├── bloc/                # SplashBloc, SplashEvent, SplashState
    │       └── pages/splash_page.dart
    └── home/
        └── presentation/
            ├── bloc/                # HomeBloc, HomeEvent, HomeState
            └── pages/home_page.dart

android/app/src/main/kotlin/.../
└── MyHostApduService.kt             # Servicio NFC HCE (Kotlin)

android/app/src/main/res/xml/
└── apdu_service.xml                 # Configuración del AID
```

---

## Dependencias principales

| Paquete | Versión | Uso |
|---------|---------|-----|
| `flutter_bloc` | ^9.1.1 | Gestión de estado |
| `equatable` | ^2.0.8 | Igualdad de valor en BLoCs |
| `go_router` | ^17.0.0 | Navegación declarativa |
| `get_it` | ^9.2.1 | Inyección de dependencias |
| `cupertino_icons` | ^1.0.8 | Iconos iOS |

---

## Requisitos

- **Android** con soporte para NFC y HCE (`android.hardware.nfc.hce`)
- Permiso `android.permission.NFC` en el dispositivo
- Flutter SDK con Dart `^3.8.1`

> Esta app es **Android-only**. HCE no está disponible en iOS.

---

## Instalación y ejecución

```bash
# Clonar el repositorio
git clone <repo-url>
cd emuladornfc

# Instalar dependencias
flutter pub get

# Ejecutar en dispositivo Android con NFC
flutter run
```

---

## Implementación NFC (nativa)

El servicio NFC vive en `MyHostApduService.kt` y extiende `HostApduService` de Android. Al recibir un comando `UPDATE BINARY`, parsea el payload NDEF, extrae la URL del registro URI y lanza un intent para abrirla en el navegador.

El servicio se declara en `AndroidManifest.xml` como exportado, requiere el permiso `BIND_NFC_SERVICE` y referencia la configuración de AID en `res/xml/apdu_service.xml`.
