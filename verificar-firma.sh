#!/bin/bash

#Verificador de firmas PGP hecho por Wrench
#Dependencias: gpg, zbar.

if [[ -z "$1" ]]; then
    echo "Uso: $0 <imagen-con-qr.png> [archivo-original]"
    exit 1
fi

IMAGEN="$1"
ARCHIVO_ORIGINAL="$2"

if [[ ! -f "$IMAGEN" ]]; then
    echo "Archivo no encontrado: $IMAGEN"
    exit 1
fi

QR_CONTENT=$(zbarimg --quiet --raw "$IMAGEN")
if [[ -z "$QR_CONTENT" ]]; then
    echo "No se encontró ningún código QR en la imagen."
    exit 1
fi

TMP_SIG=$(mktemp --suffix=.asc)
echo "$QR_CONTENT" > "$TMP_SIG"

echo "[+] Firma extraída al archivo: $TMP_SIG"
echo "[+] Verificando con gpg..."

if [[ -n "$ARCHIVO_ORIGINAL" ]]; then
    if [[ ! -f "$ARCHIVO_ORIGINAL" ]]; then
        echo "Archivo original no encontrado: $ARCHIVO_ORIGINAL"
        exit 1
    fi
    gpg --verify "$TMP_SIG" "$ARCHIVO_ORIGINAL"
else
    gpg --verify "$TMP_SIG"
fi

rm "$TMP_SIG"

