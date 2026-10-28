# MANUAL TÉCNICO DE ARQUITECTURA, BACKEND Y MEJORAS IMPLEMENTADAS
## SISTEMA SIAC-JUS | DIRECCIÓN PROVINCIAL DE JUSTICIA DE CAMAGÜEY
**Versión:** 2.5 Definitiva  
**Fecha de Publicación:** Septiembre 2026  
**Entorno de Producción:** [https://your-domain.com](https://your-domain.com)  
**Autoría Técnica:** Equipo de Desarrollo de Software Jurídico

---

## 1. RESUMEN EJECUTIVO Y PROPÓSITO DEL SISTEMA SIAC-JUS

El sistema **SIAC-JUS** (*Sistema de Información para la Asesoría y Control Jurídico*) es la plataforma institucional diseñada y desplegada para la Dirección Provincial de Justicia de Camagüey (MINJUS), con el objetivo de sustituir los controles manuales en papel y hojas de cálculo dispersas por un entorno digital unificado, ágil y auditable.

El sistema administra el ciclo de vida completo de la comparecencia ciudadana:
1. **Recepción en Ventanilla:** Radicación con número de talonario físico, datos del ciudadano, examen de competencia jurisdiccional, asignación de materia jurídica y detección de vulnerabilidades sociales.
2. **Auditoría y Dictamen de Dirección:** Despacho exclusivo de la Directora Provincial, asignación nominal de asesores, determinación de aptitud de cobro/pago y resolución procesal.
3. **Consolidado Estadístico Automático:** Generación en tiempo real de la Matriz Estadística Anual de 20+ columnas, cumpliendo estrictamente los balances matemáticos ministeriales ($C_1 = C_2 + C_3$).
4. **Emisión de Documentos Oficiales:** Generación e impresión directa de Actas Oficiales de Asesoría en PDF con validez institucional.

---

## 2. ARQUITECTURA DE BACKEND Y BASE DE DATOS SQLITE

Para garantizar máxima resiliencia operativa bajo las condiciones de infraestructura de telecomunicaciones en Cuba (baja latencia requerida, ancho de banda fluctuante y simplicidad de mantenimiento sin dependencias externas pesadas), se implementó una arquitectura basada en **PHP 8 nativo** acoplado a **SQLite 3**.

### 2.1. Almacenamiento y Persistencia (`/api/data/justicia_camaguey.sqlite`)
* **Motor:** SQLite 3 transaccional, con soporte ACID nativo.
* **Ubicación Física:** `/home/your_ssh_user/domains/your-domain.com/public_html/api/data/justicia_camaguey.sqlite`.
* **Ventajas Operativas:** Cero mantenimiento de servicios de base de datos tipo daemon (MySQL/PostgreSQL), copias de seguridad inmediatas copiando un único archivo binario y respuesta de lectura en memoria en < 5 milisegundos.

### 2.2. Esquema Relacional de Datos

#### Tabla `expedientes`
```sql
CREATE TABLE IF NOT EXISTS expedientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    no_expediente TEXT NOT NULL UNIQUE,
    fecha_atencion TEXT NOT NULL,
    ciudadano_nombre TEXT NOT NULL,
    ciudadano_ci TEXT,
    ciudadano_municipio TEXT NOT NULL,
    ciudadano_direccion TEXT,
    ciudadano_telefono TEXT,
    fundamentos TEXT NOT NULL,
    es_competente INTEGER NOT NULL DEFAULT 1,
    materia TEXT,
    vulnerabilidades TEXT,          -- Arreglo serializado en JSON (['NNA', 'PAM', ...])
    via_solucion TEXT NOT NULL,
    responsable TEXT,               -- Asignado exclusivamente por la Directora
    estado_caso TEXT NOT NULL DEFAULT 'Radicado', -- 'Radicado' | 'En Trámite' | 'Concluido' | 'No Compete'
    apto_pago INTEGER NOT NULL DEFAULT 0,
    observaciones_direccion TEXT,
    trazas_auditoria TEXT,          -- Historial de eventos y marcas de tiempo en JSON
    is_deleted INTEGER NOT NULL DEFAULT 0,
    motivo_eliminacion TEXT,
    usuario_eliminacion TEXT,
    fecha_eliminacion TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

#### Tabla `usuarios`
```sql
CREATE TABLE IF NOT EXISTS usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    nombre_completo TEXT NOT NULL,
    rol TEXT NOT NULL,              -- 'Directora' | 'Personal'
    activo INTEGER NOT NULL DEFAULT 1,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

### 2.3. Endpoints de la API RESTful

| Archivo | Método | Parámetros / Acción | Función |
| :--- | :---: | :--- | :--- |
| `api/auth.php` | `POST` | `action=login`, `{username, password}` | Autenticación institucional con hash seguro de contraseñas. |
| `api/expedientes.php` | `GET` | *(sin params)* | Lista de expedientes activos y papelera (JSON). |
| `api/expedientes.php` | `POST` | `action=crear` | Radicación de nuevo expediente en ventanilla. |
| `api/expedientes.php` | `POST` | `action=actualizar` | Edición de datos generales de expediente existente. |
| `api/expedientes.php` | `POST` | `action=auditar` | Dictamen de Dirección: asignación de responsable, cambio de estado, apto de pago y observaciones. |
| `api/expedientes.php` | `POST` | `action=soft_delete` | Envío a papelera ministerial protegida con registro de motivo y usuario. |
| `api/expedientes.php` | `POST` | `action=restaurar` | Recuperación de expedientes desde la papelera. |
| `api/usuarios.php` | `GET` / `POST` / `DELETE` | `id`, `{username, password, nombre, rol}` | Administración de cuentas de acceso para operadores provinciales. |
| `api/seed.php` | `GET` | `action=poblar` | Carga de 30 casos de prueba normalizados por municipio para demostraciones y balances estadísticos. |
| `api/pdf.php` | `GET` | `id={id}&format={html\|pdf}` | Generación de Acta Oficial en HTML o descarga binaria en `.pdf`. |

---

## 3. GENERADOR DE DOCUMENTOS Y DESCARGA BINARIA EN PDF (DOMPDF)

### 3.1. Diagnóstico del Problema Inicial
En versiones tempranas, al solicitar la descarga de la ficha en PDF, el enlace invocaba una vista HTML o una llamada `window.print()` que en conexiones lentas no renderizaba tipografías ni márgenes adecuados, obligando al usuario a lidiar con el diálogo de impresión del navegador.

### 3.2. Solución Definitiva Implementada
Se integró **Dompdf 3.1.6** directamente en el entorno PHP del servidor vía Composer. El endpoint `api/pdf.php` opera con doble modalidad:

1. **Parámetro `format=pdf` (Predeterminado):**
   * El script compila el código HTML del acta en memoria con CSS optimizado para impresión A4 (`@page { margin: 18mm 15mm; }`).
   * Configura Dompdf con soporte para imágenes y tablas densas:
     ```php
     $options = new Options();
     $options->set('isRemoteEnabled', true);
     $options->set('defaultFont', 'Helvetica');
     $dompdf = new Dompdf($options);
     $dompdf->loadHtml($html);
     $dompdf->setPaper('A4', 'portrait');
     $dompdf->render();
     ```
   * Emite cabeceras HTTP de descarga binaria directa:
     ```php
     header('Content-Type: application/pdf');
     header('Content-Disposition: attachment; filename="Ficha_Expediente_' . $caso['no_expediente'] . '.pdf"');
     header('Cache-Control: private, max-age=0, must-revalidate');
     echo $dompdf->output();
     ```
2. **Parámetro `format=html` (Inspección rápida):**
   * Retorna el documento HTML estilizado para previsualización inmediata en navegador si el usuario desea revisarlo antes de descargar el binario.

---

## 4. MOTOR DE BÚSQUEDA INTELIGENTE CLIENT-SIDE (IR) PARA CONEXIONES LENTAS

### 4.1. El Desafío de Conectividad (< 500 kbps)
En las condiciones de red habituales en sedes provinciales y municipales en Cuba, realizar búsquedas enviando peticiones HTTP sucesivas por cada pulsación de tecla (`onkeyup`) genera cuellos de botella, congelamientos de interfaz y respuestas desincronizadas.

### 4.2. Estrategia de Búsqueda Implementada
Se implementó un motor de **Recuperación de Información (IR - Information Retrieval)** ejecutado al 100% en el navegador del cliente (*Client-Side Engine*):

1. **Cero Peticiones de Red durante la Búsqueda:** El conjunto de casos activos se sincroniza una sola vez al cargar la página. Toda la búsqueda, lematización y ponderación se ejecuta en memoria JavaScript en menos de 3 milisegundos.
2. **Filtrado de Palabras Vacías (*Stopwords* en Español):**
   Un catálogo de más de 60 conectores, artículos y preposiciones (`de`, `la`, `en`, `por`, `con`, `para`, etc.) es eliminado de la consulta para concentrar la búsqueda en lexemas con valor semántico.
3. **Lematizador / Stemmer Heurístico Adaptado:**
   Algoritmo morfológico que remueve desinencias verbales, nominales y sufijos en español (`-acion`, `-imiento`, `-ando`, `-ieron`, `-es`, `-as`, etc.) para permitir encontrar expedientes aunque el término buscado esté en plural o como forma conjugada (ej. *viviendas* $\rightarrow$ *viviend*, *herencias* $\rightarrow$ *herenc*).
4. **Scoring Ponderado Multi-Campo:**
   Cada expediente recibe una puntuación matemática según la jerarquía de los campos coincidentes:
   * **No. de Expediente:** Coincidencia exacta o parcial $\rightarrow$ **100 puntos**.
   * **Carnet de Identidad:** Coincidencia numérica $\rightarrow$ **80 puntos**.
   * **Nombre del Ciudadano:** Coincidencia en nombres o apellidos $\rightarrow$ **50 puntos**.
   * **Asesor Responsable:** Coincidencia nominal $\rightarrow$ **25 puntos**.
   * **Materia Jurídica:** Coincidencia $\rightarrow$ **15 puntos**.
   * **Municipio:** Coincidencia territorial $\rightarrow$ **15 puntos**.
   * **Fundamentos / Hechos:** Coincidencia de contenido narrativo $\rightarrow$ **5 puntos**.
5. **Bonificación Multi-Término:** Si la consulta contiene múltiples palabras clave y un expediente satisface todas simultáneamente, el puntaje total se multiplica por **1.5x**.

---

## 5. PRIORIZACIÓN Y FLUJO OPERATIVO EN LA BANDEJA DE DIRECCIÓN

### 5.1. Regla de Negocio: Casos Radicados Primero
Para la Directora Provincial, el tiempo es crítico. Los casos con estado **Radicado** son aquellos recién registrados en ventanilla que aún no cuentan con especialista asignado ni dictamen preliminar. 

* **Comportamiento sin Búsqueda:** Los casos se ordenan de manera estricta colocando todos los expedientes **Radicados** al principio de la bandeja, destacados con fondo ambarino y borde acentuado. Una vez despachados todos los radicados, se listan los casos *En Trámite*, *Concluidos* y *No Compete* en orden cronológico descendente.
* **Comportamiento con Búsqueda Activa:** Si la Directora escribe una consulta en el buscador, el algoritmo prioriza automáticamente por puntuación de relevancia ($Score_{IR}$), permitiendo ubicar cualquier expediente específico en milésimas de segundo.

---

## 6. OPTIMIZACIÓN RESPONSIVE MÓVIL (SKILL IMPECCABLE)

Siguiendo las pautas de diseño técnico de la skill **impeccable** ([`reference/adapt.md`](file:///C:/Users/aruiz/.gemini/antigravity-cli/builtin/skills/impeccable/reference/adapt.md) y [`reference/craft-floor.md`](file:///C:/Users/aruiz/.gemini/antigravity-cli/builtin/skills/impeccable/reference/craft-floor.md)), se transformó la experiencia de usuario para garantizar operatividad completa desde teléfonos inteligentes y tablets institucionales:

### 6.1. Touch Targets y Ergonomía
* Todos los elementos interactivos (botones de acción, pestañas, selectores, checkboxes de vulnerabilidad) cuentan con una altura mínima de **42 a 44 píxeles**, cumpliendo los estándares de accesibilidad táctil para el pulgar.
* Se configuró `text-base sm:text-sm` en todos los inputs para evitar que los dispositivos móviles con iOS / Safari ejecuten zoom automático molesto al hacer foco en un campo.

### 6.2. Dualidad Arquitectónica: Tablas vs. Tarjetas
En lugar de forzar tablas con scroll infinito que saturan la pantalla de un teléfono, el sistema opera con dos capas de renderizado condicional mediante Tailwind CSS:

1. **Pantallas Grandes ($\ge$ 768px - `hidden md:block`):**
   * Tabla institucional clásica de alta densidad con columnas completas para monitoreo en monitores de escritorio.
2. **Pantallas Móviles (< 768px - `md:hidden`):**
   * Contenedores dinámicos (`#cards-mis-expedientes` y `#cards-auditoria`) que presentan cada expediente como una **tarjeta independiente**:
     * Número de expediente y fecha en tipografía monoespaciada tabular.
     * Insignia (*badge*) con la semántica de color oficial del estado.
     * Nombre del ciudadano y municipio resaltados.
     * Bloque contextual con materia, vulnerabilidades y funcionario asignado.
     * Barra de botones táctiles directos: `Gestionar`, `Editar` y descarga de `PDF`.

### 6.3. Matriz Estadística Móvil (20 Columnas)
* **Columna "Mes" Congelada (*Sticky Left*):** La primera columna permanece estática (`sticky left-0 z-10`) con una sutil sombra lateral (`shadow-[2px_0_4px_rgba(0,0,0,0.06)]`), permitiendo navegar las 20 columnas numéricas sin perder jamás la referencia temporal del mes.
* **KPIs Resumen Ejecutivos:** Bloque superior con 4 tarjetas de métricas inmediatas (*Total Atendidos*, *Competentes MINJUS*, *Casos Concluidos*, *Apto para Pago*) que permiten conocer el estado provincial en un vistazo sin necesidad de scroll horizontal.

---

## 7. IDENTIDAD GRÁFICA INSTITUCIONAL (MINJUS CAMAGÜEY)

Alineado con los canales oficiales de la Dirección Provincial de Justicia de Camagüey:
* **Paleta de Color Oficial:**
  * Azul Marino Institucional: `#0c2340` (Primary Header & Actions).
  * Azul Profundo Sub-cintillo: `#081626`.
  * Dorado/Ámbar Oficial: `#d97706` / `#f59e0b` (Lema y Acentos de Pago).
* **Cintillo Superior de la República:**
  * `República de Cuba / Ministerio de Justicia (MINJUS) / «Por un servicio jurídico ético, ágil y transparente»`.
* **Emblemas Oficiales:** Balanza de la justicia vectorial en SVG de trazo formal, integrada en login, cabecera y favicons.

---

## 8. PIPELINE DE DESPLIEGUE CONTINUO

El flujo de entrega a producción opera bajo una arquitectura de tres niveles:

```
[ Entorno de Desarrollo Local (Windows) ]
                   │
                   ▼ (SCP / Git)
[ Servidor de Compilación Intermedio (VPS) ]
  • Node.js + Astro Build Engine
  • Validación de bundle estático (/dist)
                   │
                   ▼ (deploy.sh vía SSH/SCP Puerto 22)
[ Servidor de Producción Hostinger (your_ssh_user) ]
  • Webroot: /public_html
  • Directorio /api protegido (Persistencia SQLite y librerías Composer intactas)
  • Permisos automáticos: 755 (directorios) / 644 (archivos)
```

**Resultado:** Despliegue verificado y activo en **[https://your-domain.com](https://your-domain.com)**.
