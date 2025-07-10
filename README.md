# MercadoPago Native SDK

MercadoPago Native SDK para Android distribuido a través de JitPack.

## Instalación

### Paso 1: Agregar el repositorio JitPack

En tu archivo `build.gradle` a nivel de proyecto (root), agrega el repositorio JitPack:

```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url 'https://jitpack.io' }
    }
}
```

### Paso 2: Agregar la dependencia

En el archivo `build.gradle` de tu módulo (app), agrega la dependencia:

```gradle
dependencies {
    implementation 'com.github.bazookon:mpago-nativesk:5.0.0'
}
```

## Uso

```kotlin
// Ejemplo de uso del SDK
// Aquí irían las instrucciones de uso específicas del SDK
```

## Versiones

- **5.0.0** - Versión inicial

## Licencia

Este proyecto está licenciado bajo la Licencia Apache 2.0.
