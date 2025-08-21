#!/bin/bash
set -e

BASE_DIR=$(dirname "$0")
SRC_DIR="$BASE_DIR/src/main/java"
LIB_DIR="$BASE_DIR/lib"
BUILD_DIR="$BASE_DIR/build"

# Nettoyage
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Compilation avec les libs MySQL + JSON
javac -cp "$LIB_DIR/*" -d "$BUILD_DIR" $(find "$SRC_DIR" -name "*.java")

# Création du jar
jar cf "$BASE_DIR/mysql5_wrapper_java.jar" -C "$BUILD_DIR" .

echo "✅ Jar généré: $BASE_DIR/mysql5_wrapper_java.jar"
