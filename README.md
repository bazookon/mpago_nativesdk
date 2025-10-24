# MercadoPago Native SDK

MercadoPago Native SDK para Android distribuido a través de JitPack.

## 📋 Tabla de Contenido

- [Instalación](#instalación)
- [Uso](#uso)
- [Versiones](#versiones)
- [Desarrollo](#desarrollo)
- [Crear Nueva Versión](#crear-nueva-versión)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Licencia](#licencia)

## 🚀 Instalación

### Método 1: Para proyectos con Android Gradle Plugin 7.0+

En tu archivo `settings.gradle` (nivel de proyecto), agrega el repositorio JitPack:

```gradle
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven { url 'https://jitpack.io' }
    }
}
```

### Método 2: Para proyectos con versiones anteriores

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

### Agregar la dependencia

En el archivo `build.gradle` de tu módulo (app), agrega la dependencia:

```gradle
dependencies {
    implementation 'com.github.bazookon:mpago_nativesdk:5.1.1'
    
    // O usar la última versión disponible:
    // implementation 'com.github.bazookon:mpago_nativesdk:latest'
    
    // O usar una versión específica del commit:
    // implementation 'com.github.bazookon:mpago_nativesdk:COMMIT_HASH'
}
```

## 💻 Uso

```kotlin
// Ejemplo de uso del SDK
// TODO: Agregar documentación específica del SDK cuando esté disponible

// Importar las clases necesarias
import com.mercadopago.nativesdk.*

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Inicializar el SDK
        // MercadoPagoSDK.initialize(context, "PUBLIC_KEY")
        
        // Ejemplo de uso
        // val payment = MercadoPagoSDK.createPayment(paymentData)
    }
}
```

## 📦 Versiones

| Versión   | Fecha      | Notas                                                                                                                                     |
| --------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| **5.1.1** | 2025-10-24 | ✅ Corrección: Detección correcta de la app principal en integración de smart apps<br>✅ Mejoras en el flujo de cuotas para iniciar un pago |
| **5.0.4** | 2025-09-02 | Correcciones y mejoras menores                                                                                                            |
| **5.0.0** | 2025-07-10 | Versión inicial del SDK nativo                                                                                                            |

### Compatibilidad

- **Android API Level**: 21+ (Android 5.0+)
- **Kotlin**: Compatible
- **Java**: Compatible
- **Android Gradle Plugin**: 7.0+

## 🛠 Desarrollo

### Estructura del Proyecto

```
mpago_nativesdk/
├── aar/
│   └── nativesdk-5.1.1.aar      # Archivo AAR del SDK
├── build.gradle                  # Configuración de Gradle para publicación
├── gradle.properties            # Propiedades del proyecto (versión, etc.)
├── settings.gradle              # Configuración del proyecto
├── jitpack.yml                  # Configuración específica para JitPack
└── README.md                    # Documentación
```

### Requisitos de Desarrollo

- **JDK**: OpenJDK 8 o superior
- **Gradle**: 8.0+
- **Git**: Para versionado

### Probar Localmente

```bash
# Clonar el repositorio
git clone https://github.com/bazookon/mpago_nativesdk.git
cd mpago_nativesdk

# Compilar y publicar localmente
./gradlew assemble publishToMavenLocal

# Verificar que se publicó correctamente
./gradlew publishToMavenLocal --info
```

## 🚀 Crear Nueva Versión

### Proceso Paso a Paso

1. **Actualizar la versión en `gradle.properties`**:
   ```properties
   VERSION_NAME=5.1.0
   ```

2. **Actualizar el archivo AAR** (si es necesario):
   ```bash
   # Reemplazar el archivo AAR en la carpeta aar/
   cp nuevo-nativesdk-5.1.0.aar aar/nativesdk-5.1.0.aar
   ```

3. **Actualizar referencias en `build.gradle`** (si cambió el nombre del AAR):
   ```gradle
   artifact("aar/nativesdk-5.1.0.aar") {
       extension 'aar'
   }
   ```

4. **Hacer commit de los cambios**:
   ```bash
   git add .
   git commit -m "Bump version to 5.1.0"
   git push origin main
   ```

5. **Crear y publicar el tag**:
   ```bash
   # Crear el tag (sin prefijo 'v' para mantener consistencia)
   git tag -a 5.1.0 -m "Release version 5.1.0"
   
   # Publicar el tag
   git push origin 5.1.0
   ```

6. **Verificar en JitPack**:
   - Ir a [https://jitpack.io/#bazookon/mpago_nativesdk](https://jitpack.io/#bazookon/mpago_nativesdk)
   - La nueva versión debería aparecer automáticamente
   - Hacer clic en "Get it" para compilar si es necesario

### Comandos Útiles

```bash
# Ver tags existentes
git tag -l

# Eliminar un tag local
git tag -d 5.0.0

# Eliminar un tag remoto
git push --delete origin 5.0.0

# Crear tag para commit específico
git tag -a 5.1.0 COMMIT_HASH -m "Release version 5.1.0"

# Ver información del tag
git show 5.0.0
```

### Automatización (Opcional)

Puedes crear un script para automatizar el proceso:

```bash
#!/bin/bash
# release.sh

if [ $# -eq 0 ]; then
    echo "Uso: ./release.sh <version>"
    echo "Ejemplo: ./release.sh 5.1.0"
    exit 1
fi

VERSION=$1

# Actualizar gradle.properties
sed -i "s/VERSION_NAME=.*/VERSION_NAME=$VERSION/" gradle.properties

# Commit y tag
git add gradle.properties
git commit -m "Bump version to $VERSION"
git tag -a $VERSION -m "Release version $VERSION"

# Push
git push origin main
git push origin $VERSION

echo "✅ Versión $VERSION creada y publicada"
echo "🔗 Verificar en: https://jitpack.io/#bazookon/mpago_nativesdk/$VERSION"
```

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia Apache 2.0. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📞 Soporte

- **Issues**: [GitHub Issues](https://github.com/bazookon/mpago_nativesdk/issues)
- **Documentación**: [JitPack](https://jitpack.io/#bazookon/mpago_nativesdk)

---

**Nota**: Este SDK está en desarrollo activo. Las APIs pueden cambiar en versiones futuras.
