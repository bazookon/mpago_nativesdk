#!/bin/bash
# Script para automatizar la creación de nuevas versiones del SDK

set -e  # Salir si cualquier comando falla

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo "📦 Script de Release para MercadoPago Native SDK"
    echo ""
    echo "Uso: ./release.sh <version> [options]"
    echo ""
    echo "Argumentos:"
    echo "  <version>        Nueva versión (ej: 5.1.0)"
    echo ""
    echo "Opciones:"
    echo "  -h, --help       Mostrar esta ayuda"
    echo "  -n, --dry-run    Mostrar qué se haría sin ejecutar"
    echo "  --no-push       No hacer push automáticamente"
    echo ""
    echo "Ejemplos:"
    echo "  ./release.sh 5.1.0"
    echo "  ./release.sh 5.2.0 --dry-run"
    echo "  ./release.sh 5.1.1 --no-push"
    echo ""
}

# Función para logging
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Validar argumentos
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

VERSION=$1
DRY_RUN=false
NO_PUSH=false

# Procesar opciones
for arg in "$@"; do
    case $arg in
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --no-push)
            NO_PUSH=true
            shift
            ;;
    esac
done

# Validar formato de versión
if [[ ! $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    log_error "Formato de versión inválido. Use el formato X.Y.Z (ej: 5.1.0)"
    exit 1
fi

log_info "Iniciando proceso de release para versión $VERSION"

# Verificar que estamos en la rama main
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    log_warning "No estás en la rama 'main'. Rama actual: $CURRENT_BRANCH"
    read -p "¿Continuar de todos modos? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Operación cancelada"
        exit 1
    fi
fi

# Verificar que no hay cambios sin commit
if [ -n "$(git status --porcelain)" ]; then
    log_error "Hay cambios sin hacer commit. Por favor, haz commit o stash de tus cambios primero."
    git status --short
    exit 1
fi

# Verificar que el tag no existe
if git tag -l | grep -q "^$VERSION$"; then
    log_error "El tag $VERSION ya existe. Usa una versión diferente o elimina el tag existente."
    exit 1
fi

# Verificar que estamos actualizados con el remoto
log_info "Verificando estado del repositorio..."
git fetch origin

if [ "$DRY_RUN" = true ]; then
    log_warning "MODO DRY-RUN: Mostrando qué se haría sin ejecutar"
    echo ""
    echo "1. Actualizar VERSION_NAME en gradle.properties a $VERSION"
    echo "2. Hacer commit: 'Bump version to $VERSION'"
    echo "3. Crear tag: $VERSION"
    if [ "$NO_PUSH" = false ]; then
        echo "4. Push a origin/main"
        echo "5. Push del tag $VERSION"
    fi
    echo "6. Mostrar enlace de JitPack"
    exit 0
fi

# 1. Actualizar gradle.properties
log_info "Actualizando gradle.properties..."
sed -i "s/VERSION_NAME=.*/VERSION_NAME=$VERSION/" gradle.properties

# Verificar que el cambio se hizo correctamente
if grep -q "VERSION_NAME=$VERSION" gradle.properties; then
    log_success "gradle.properties actualizado correctamente"
else
    log_error "Error al actualizar gradle.properties"
    exit 1
fi

# 2. Hacer commit
log_info "Haciendo commit de los cambios..."
git add gradle.properties
git commit -m "Bump version to $VERSION"

# 3. Crear tag
log_info "Creando tag $VERSION..."
git tag -a $VERSION -m "Release version $VERSION - MercadoPago Native SDK"

# 4. Push (si no está deshabilitado)
if [ "$NO_PUSH" = false ]; then
    log_info "Haciendo push de los cambios..."
    git push origin "$CURRENT_BRANCH"
    
    log_info "Haciendo push del tag..."
    git push origin $VERSION
    
    log_success "Cambios y tag enviados al repositorio remoto"
else
    log_warning "Push deshabilitado. Para enviar manualmente:"
    echo "  git push origin $CURRENT_BRANCH"
    echo "  git push origin $VERSION"
fi

# 5. Mostrar información útil
echo ""
log_success "🎉 Release $VERSION creado exitosamente!"
echo ""
echo "📋 Información del release:"
echo "  • Versión: $VERSION"
echo "  • Tag: $VERSION"
echo "  • Commit: $(git rev-parse --short HEAD)"
echo ""
echo "🔗 Enlaces útiles:"
echo "  • JitPack: https://jitpack.io/#bazookon/mpago_nativesdk/$VERSION"
echo "  • GitHub Tag: https://github.com/bazookon/mpago_nativesdk/releases/tag/$VERSION"
echo ""
echo "📦 Para usar esta versión:"
echo "  implementation 'com.github.bazookon:mpago_nativesdk:$VERSION'"
echo ""

if [ "$NO_PUSH" = false ]; then
    log_info "Esperando a que JitPack procese el nuevo tag..."
    echo "Puedes verificar el estado en: https://jitpack.io/#bazookon/mpago_nativesdk/$VERSION"
fi

log_success "¡Proceso completado!"
