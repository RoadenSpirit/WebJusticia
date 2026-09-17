#!/bin/bash
# Script de Despliegue Automático para Web Justicia en Hostinger
set -e

TARGET_HOST="your_server_ip"
TARGET_PORT="22"
TARGET_USER="your_ssh_user"
TARGET_PATH="/home/your_ssh_user/domains/your-domain.com/public_html"

echo "==> 1. Compilando proyecto Astro en estático..."
npm run build

echo "==> 2. Limpiando directorio remoto en Hostinger..."
ssh -p $TARGET_PORT -o StrictHostKeyChecking=no $TARGET_USER@$TARGET_HOST "find $TARGET_PATH/ -mindepth 1 -delete"

echo "==> 3. Subiendo archivos compilados (dist/*)..."
scp -P $TARGET_PORT -r dist/* $TARGET_USER@$TARGET_HOST:$TARGET_PATH/

echo "==> 4. Ajustando permisos en el servidor web..."
ssh -p $TARGET_PORT -o StrictHostKeyChecking=no $TARGET_USER@$TARGET_HOST "chmod 755 $TARGET_PATH && find $TARGET_PATH/ -type d -exec chmod 755 {} + && find $TARGET_PATH/ -type f -exec chmod 644 {} +"

echo "==> ¡Despliegue completado con éxito en https://your-domain.com!"
