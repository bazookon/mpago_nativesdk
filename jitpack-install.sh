#!/bin/bash
# JitPack's "latest" image maps `jdk: openjdk11` to /usr/lib/jvm/jdk-11, which
# no longer exists. Gradle 8.0 only runs on Java 8–19, so pick a usable JDK
# and fall back to Temurin 17 via SDKMAN.
set -e

java_major() {
  "$1" -version 2>&1 | head -n 1 | sed -n 's/.* version "\([0-9][0-9]*\).*/\1/p'
}

java_ok() {
  [ -n "${1:-}" ] && [ -x "$1/bin/java" ] || return 1
  case "$(java_major "$1/bin/java")" in
    1 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19) return 0 ;;
    *) return 1 ;;
  esac
}

if java_ok "${JAVA_HOME:-}"; then
  echo "Using image JDK at $JAVA_HOME"
  export PATH="$JAVA_HOME/bin:$PATH"
else
  echo "JAVA_HOME is unusable (${JAVA_HOME:-unset}). Installing Temurin 17."
  # shellcheck disable=SC1091
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  JAVA_ID="17.0.20-tem"
  if [ ! -x "$HOME/.sdkman/candidates/java/$JAVA_ID/bin/java" ]; then
    sdk install java "$JAVA_ID"
  fi
  export JAVA_HOME="$HOME/.sdkman/candidates/java/$JAVA_ID"
  export PATH="$JAVA_HOME/bin:$PATH"
  java_ok "$JAVA_HOME" || {
    echo "Temurin 17 install did not produce a usable JDK at $JAVA_HOME" >&2
    exit 1
  }
fi

echo "JAVA_HOME=$JAVA_HOME"
"$JAVA_HOME/bin/java" -version
./gradlew -Pversion="$VERSION" assemble publishToMavenLocal
