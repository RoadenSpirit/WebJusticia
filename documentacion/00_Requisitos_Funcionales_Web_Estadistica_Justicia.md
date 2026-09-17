# DOCUMENTO DE ESPECIFICACIÓN DE REQUISITOS FUNCIONALES (ERS / DRF)
## SISTEMA DE GESTIÓN Y ESTADÍSTICA DE ASESORÍA JURÍDICA ("WEB ESTADÍSTICA JUSTICIA")
**Cliente:** Dirección Provincial de Justicia de Camagüey  
**Tipo de Documento:** Propuesta de Solución y Requisitos Funcionales del Sistema  
**Versión:** 1.0 (Borrador Integral para Aprobación de Proyecto)  
**Fecha de Presentación:** Marzo de 2026  
**Clasificación:** Documento Oficial de Ingeniería de Software / Alcance de Producto (MVP)

---

## 1. INTRODUCCIÓN Y CONTEXTO INSTITUCIONAL

### 1.1. Propósito del Documento
El presente documento tiene por objetivo definir, con carácter riguroso y detallado, los requerimientos funcionales, reglas de negocio, flujos operativos, arquitectura de permisos y especificación de interfaces del sistema de información web denominado **"Web Estadística Justicia"**. 

Este documento constituye la base técnica y contractual para la presentación formal ante la **Dirección Provincial de Justicia de Camagüey**, sirviendo como guía definitiva para el desarrollo, validación y aceptación del Producto Mínimo Viable (MVP).

### 1.2. Situación Actual y Problemática
Diariamente acuden a la Dirección Provincial de Justicia de Camagüey ciudadanos en busca de orientación y asesoría jurídica sobre situaciones personales, familiares, laborales o patrimoniales. 

Actualmente, el registro de estas atenciones y la posterior confección de los balances estadísticos mensuales y anuales presentan los siguientes retos:
1. **Dispersión de la información:** Riego de pérdida o inconsistencia en los libros de registro manuales o ficheros ofimáticos locales.
2. **Duplicidad de esfuerzos:** El personal de ventanilla anota los casos, pero luego la Dirección debe realizar un conteo manual para tabular variables complejas (materias, vulnerabilidades, vías de solución y estados de resolución).
3. **Falta de uniformidad estadística:** Dificultad para auditar con exactitud qué casos corresponden a la competencia del Ministerio y cuáles se descartan por no ser de su jurisdicción, afectando la veracidad de los balances presentados a instancias superiores.

### 1.3. Solución Propuesta
Desarrollar una aplicación web centralizada, accesible mediante roles diferenciados, que permita:
1. **A los funcionarios de Atención a la Ciudadanía:** Registrar en tiempo real cada caso recibido mediante un formulario estandarizado, vinculando la situación sociojurídica del usuario y determinando de forma inmediata la competencia del asunto.
2. **A la Dirección Provincial de Justicia:** Ejercer control institucional y auditoría técnica sobre cada expediente, dictaminar la vía de solución formal, calificar el estado de resolución del caso y disponer de una **Matriz Estadística Automatizada** que consolide en tiempo real las métricas mensuales y anuales de la provincia.

---

## 2. ARQUITECTURA DE ROLES Y MATRIZ DE PERMISOS (RBAC)

El sistema implementará un esquema estricto de Control de Acceso Basado en Roles (*Role-Based Access Control*), garantizando la integridad de los expedientes y la separación de funciones entre la atención primaria y la dirección técnica.

### 2.1. Definición de Roles del Sistema

*   **Rol 1: Personal de Atención al Ciudadano (Operador de Ventanilla)**
    *   *Objetivo:* Recepción física del usuario, apertura del expediente, redacción del fundamento fáctico y clasificación preliminar.
    *   *Límites de acción:* No puede dictaminar vías de solución formales ni declarar un caso como "Resuelto", ni modificar expedientes una vez guardados.
*   **Rol 2: Dirección / Supervisión (Directora Provincial de Justicia)**
    *   *Objetivo:* Máxima autoridad funcional. Supervisa la labor del personal, audita el contenido de los casos, dictamina la Vía de Solución institucional, declara el Estado final del caso (Resuelto / No Resuelto) y explota el tablero estadístico provincial.
    *   *Límites de acción:* Posee facultades exclusivas de corrección, edición retrospectiva y anulación/eliminación de expedientes ante inconsistencias.
*   **Rol 3: Administrador del Sistema (Soporte Técnico)**
    *   *Objetivo:* Mantenimiento operativo de la plataforma (creación de credenciales, restablecimiento de contraseñas, auditoría de fallas y respaldos de la base de datos).
    *   *Límites de acción:* Rol estrictamente técnico sin acceso ni injerencia en los datos jurídicos o las estadísticas institucionales.

### 2.2. Matriz de Control de Acceso y Funcionalidades

| Módulo / Funcionalidad | Personal de Atención | Dirección Provincial | Administrador Técnico |
| :--- | :---: | :---: | :---: |
| **Inicio de Sesión y Perfil** | ✔ | ✔ | ✔ |
| **Formulario: Crear Expediente** | ✔ | ✔ | ❌ |
| **Formulario: Asignar Vía de Solución** | ❌ (Bloqueado) | ✔ (Exclusivo) | ❌ |
| **Formulario: Dictaminar Estado (Resuelto/No Resuelto)** | ❌ (Bloqueado) | ✔ (Exclusivo) | ❌ |
| **Listado de Casos: Propios** | ✔ (Solo lectura) | ✔ | ❌ |
| **Listado de Casos: Toda la Provincia** | ❌ | ✔ | ❌ |
| **Auditoría Individual de Caso (Ficha Detalle)** | ❌ | ✔ | ❌ |
| **Edición / Rectificación de Casos Guardados** | ❌ | ✔ (Exclusivo) | ❌ |
| **Eliminación / Baja de Expediente** | ❌ | ✔ (Exclusivo) | ❌ |
| **Panel de Matriz Estadística (12 Meses + Total)** | ❌ | ✔ (Exclusivo) | ❌ |
| **Gestión de Cuentas y Contraseñas** | ❌ | ❌ | ✔ (Exclusivo) |

---

## 3. DICCIONARIO DE DATOS Y REGLAS DE NEGOCIO DEL EXPEDIENTE

Cada atención realizada genera un único registro (expediente). A continuación se especifican las características técnicas, tipos de datos y comportamientos lógicos de cada campo:

### 3.1. Especificación Técnica de Campos

| Nombre del Campo | Tipo de Dato | Control UI | Obligatorio | Editores Permitidos | Descripción / Regla |
| :--- | :--- | :--- | :---: | :--- | :--- |
| `no_expediente` | Alfanumérico (VarChar 50) | Input texto | Sí | Atención / Dirección | Identificador único del caso. *(Ver Punto de Negociación 1)*. |
| `fecha_atencion` | Fecha (Date) | Datepicker | Sí | Atención / Dirección | Fecha de la comparecencia física. Por defecto toma la fecha actual del sistema. |
| `responsable` | Texto (VarChar 150) | Input texto | Sí | Atención / Dirección | Nombre del funcionario que atiende al ciudadano. *(Ver Punto de Negociación 2)*. |
| `es_competente` | Booleano / Selector | Radio / Switch | Sí | Atención / Dirección | Determina si el asunto planteado está bajo la jurisdicción de la entidad. |
| `fundamentos` | Texto Extenso (Text) | Textarea enriquecido | Sí | Atención / Dirección | Narrativa fáctica comprensiva. Consolida datos del ciudadano y el fondo del caso. |
| `materia` | Enum / Catálogo | Select / Radio | Condicional | Atención / Dirección | Rama del derecho que encuadra el conflicto. *(Obligatorio solo si Compete)*. |
| `vulnerabilidad` | Enum / Catálogo | Radio Button | Condicional | Atención / Dirección | Sigla de vulnerabilidad social detectada. *(Obligatorio solo si Compete)*. |
| `via_solucion` | Enum / Catálogo | Select / Radio | Condicional | **Solo Dirección** | Canal institucional por el que se orienta o encauza la solución del caso. |
| `estado_caso` | Enum / Catálogo | Select / Badge | Sí | **Solo Dirección** (Automático si No Compete) | Situación procesal de la atención brindada. |

---

### 3.2. Catálogos y Valores Admisibles

#### A. Materia Jurídica
Aplica estrictamente cuando el caso es **Competente**:
1. **Civil:** Conflictos sobre propiedad, obligaciones, contratos, sucesiones hereditarias, declaraciones de ausencia, entre otros.
2. **Familiar:** Procesos derivados del Código de las Familias (guarda y cuidado, régimen de comunicación, alimentos, tutela, divorcio, reconocimiento de unión de hecho).
3. **Trabajo y Seguridad Social:** Reclamaciones de derechos laborales, pensiones por edad, invalidez total/parcial, subsidios de maternidad o asistencia social.
4. **Mercantil:** Disputas o asesoría vinculadas a actores económicos (MIPYMES, cooperativas no agropecuarias, empresas estatales, contratos comerciales).
5. **Administrativo:** Asuntos vinculados a actuaciones de la administración pública, vivienda, planificación física o actos de autoridades administrativas.

#### B. Tipo de Vulnerabilidad
El sistema implementa la clasificación estandarizada mediante siglas de cinco (5) tipos:
1. **`NNA` (Niño, Niña y Adolescente):** Menores de 18 años cuyos derechos fundamentales o de representación se encuentran en evaluación.
2. **`VVD` (Víctima, Violencia y Discriminación):** Personas que denuncian o evidencian haber sufrido violencia de género, intrafamiliar, discriminación racial, de orientación sexual o institucional.
3. **`PAM` (Persona Adulto Mayor):** Ciudadanos de 60 años o más en situación de indefensión, desamparo o dependencia económica/familiar.
4. **`PSD` (Persona en Situación de Discapacidad):** Personas con limitaciones físicas, sensoriales, intelectuales o psicosociales que dificultan su pleno acceso a la justicia.
5. **`PJA` (Persona Jurídico Ausente):** Supuestos legales donde la parte involucrada se encuentra fuera del territorio nacional o en ignorado paradero, requiriendo representación de oficio o tutela de bienes.

#### C. Vía de Solución
Canal determinado **únicamente por la Dirección**:
1. **Proceso Judicial:** Remisión formal o indicación de que el asunto debe dirimirse ante los Tribunales Populares (demanda, procedimiento de jurisdicción voluntaria, etc.).
2. **Notarial:** Remisión para otorgamiento de escrituras públicas, actas de notoriedad, testamentos, poderes especiales o trámites ante Notaría.
3. **Administrativo:** Solución directa ante Direcciones Municipales/Provinciales (Trámites de la Vivienda, Carné de Identidad, Registro del Estado Civil, etc.).
4. **Métodos Alternos:** Solución basada en mediación, conciliación prejudicial, negociación guiada o diálogo directo entre partes.

#### D. Estado del Caso
Categorías de cierre del expediente:
1. **`No Compete`:** Asignado automáticamente cuando la entidad no tiene facultad legal sobre el conflicto (ejemplo: materia estrictamente penal sustantiva radicada en Fiscalía/PGR, asuntos de competencia comunal ajena, etc.).
2. **`Resuelto`:** Asignado por la Dirección cuando el ciudadano recibió la orientación integral requerida, se agotó la vía de consulta o se canalizó con éxito el trámite.
3. **`No Resuelto`:** Asignado por la Dirección cuando la consulta queda inconclusa por falta de comparecencia, insuficiencia de elementos probatorios aportados por el ciudadano o cuando se encuentra a la espera de un informe externo complementario.

---

### 3.3. Reglas de Negocio Estrictas (Business Rules)

*   **RN-01 (Manejo del Caso "No Compete"):**
    *   Si el campo `es_competente` se marca como **"NO"**:
        *   Los campos `materia`, `vulnerabilidad` y `via_solucion` se bloquean inmediatamente en la interfaz y su valor en base de datos se registra como `NULL` (nulo).
        *   El campo `estado_caso` adopta el valor inalterable de `No Compete`.
        *   El caso se computa dentro de `Total Casos Atendidos`, pero se omite matemáticamente de los totales de Materias, Vulnerabilidades y Vías de Solución.
*   **RN-02 (Fundamentos como Identificación Integral):**
    *   Dado que en el MVP no existen campos atómicos separados para nombres, apellidos, Carnet de Identidad (CI), dirección o teléfono del solicitante, el campo `fundamentos` es de carácter **mandatorio y exhaustivo**.
    *   La interfaz incorporará un marcador visual (*placeholder*) que recordará al operador registrar obligatoriamente: *Nombre completo del ciudadano, CI, municipio de residencia, número de contacto y síntesis fáctica de la situación jurídica planteada*.
*   **RN-03 (Inmutabilidad para Atención):**
    *   Una vez que el personal de atención pulsa el botón **"Registrar y Enviar Expediente"**, el caso queda en estado bloqueado para dicho usuario.
    *   No se permite edición, corrección ortográfica ni borrado por parte del operador que lo originó. Cualquier rectificación debe ser solicitada formalmente a la Dirección Provincial.
*   **RN-04 (Jurisdicción Exclusiva de Dirección):**
    *   Los campos `via_solucion` y `estado_caso` (para casos competentes) son totalmente invisibles o se encuentran bloqueados en modo solo lectura en la interfaz del Personal de Atención.
    *   Solo una cuenta con rol `Dirección` puede acceder a la ficha de auditoría, examinar los fundamentos y guardar los valores de dichos campos.
*   **RN-05 (Consistencia de Vulnerabilidad Excluyente):**
    *   En el MVP, el selector de vulnerabilidad es de opción única (*radio button*). Si un ciudadano posee más de una condición, el operador registrará la de mayor gravedad jurídica y dejará constancia de las restantes en el cuerpo de los `fundamentos`.

---

## 4. FLUJO DE TRABAJO INTEGRAL (WORKFLOW EN DOS ETAPAS)

El ciclo de vida del expediente garantiza un flujo ordenado desde la mesa de entrada hasta el informe gerencial:

```
                      INICIO: COMPARECENCIA DEL CIUDADANO
                                      │
                                      ▼
               ┌──────────────────────────────────────────────┐
               │   ETAPA 1: ATENCIÓN AL CIUDADANO (VENTANILLA) │
               └──────────────────────────────────────────────┘
                                      │
                        ¿El asunto es Competencia de Justicia?
                         /                                                      [ SÍ ]                                  [ NO ]
                       │                                      │
         • Ingresa No. Exp y Responsable.       • Ingresa No. Exp y Responsable.
         • Redacta Fundamentos (Datos + Caso).  • Redacta Fundamentos explicativos.
         • Selecciona Materia (Civil, etc.).    • Bloqueo automático de Materia,
         • Selecciona Vulnerabilidad (NNA...).    Vulnerabilidad y Vía.
                       │                        • Estado = "No Compete".
                       │                                      │
                       └───────────────────┬──────────────────┘
                                           │
                                           ▼
                           [ GUARDAR / ENVIAR EXPEDIENTE ]
                                           │
                           (Expediente Bloqueado para Operador)
                                           │
                                           ▼
               ┌──────────────────────────────────────────────┐
               │     ETAPA 2: AUDITORÍA Y RESOLUCIÓN (DIRECCIÓN)│
               └──────────────────────────────────────────────┘
                                           │
                     • La Directora ingresa a la Bandeja Provincial.
                     • Abre la Ficha de Auditoría del Expediente.
                     • Lee y analiza minuciosamente los Fundamentos.
                                           │
                           ¿Requiere rectificación fáctica?
                            /                                                   [ SÍ ]                            [ NO ]
                          │                                │
            • Edita datos erróneos.           • Asigna "Vía de Solución"
            • Guarda cambios auditados.         (Judicial, Notarial, etc.).
                          │                   • Dictamina "Estado":
                          │                     (Resuelto / No Resuelto).
                          └────────────────┬───────────────┘
                                           │
                                           ▼
                             [ CONFIRMAR Y CERRAR CASO ]
                                           │
                                           ▼
                ┌──────────────────────────────────────────────┐
                │        IMPACTO EN MATRIZ ESTADÍSTICA         │
                │  Actualización automática en tiempo real de  │
                │  las celdas del mes y acumulación anual.     │
                └──────────────────────────────────────────────┘
```

---

## 5. ESPECIFICACIÓN DETALLADA DE INTERFACES (UI/UX)

A continuación se definen los elementos visuales, estructura y controles interactivos de las cinco (5) pantallas principales del sistema:

### 5.1. Pantalla 1: Acceso al Sistema (Login)
*   **Propósito:** Autenticar al usuario de forma segura y redirigirlo automáticamente al panel correspondiente a su perfil.
*   **Elementos Visuales:**
    *   Cabecera con Escudo Oficial o Logotipo del Ministerio de Justicia y título: *"Dirección Provincial de Justicia de Camagüey - Web Estadística Justicia"*.
    *   Formulario centrado con campos:
        *   `Usuario / Correo Electrónico` (Input texto).
        *   `Contraseña` (Input protegido con opción de visibilidad).
        *   Botón de acción principal: `Iniciar Sesión`.
    *   Mensajes de alerta ante credenciales inválidas o cuenta inhabilitada.

### 5.2. Pantalla 2: Formulario de Registro de Atención (Rol: Atención)
*   **Propósito:** Capturar de forma ágil y guiada los datos de la asesoría brindada al ciudadano.
*   **Estructura y Disposición:**
    *   **Barra Superior:** Identificación del operador logueado, fecha del día y botón `Cerrar Sesión`.
    *   **Sección A (Encabezado del Caso):**
        *   Campo `No. de Expediente`: Caja de texto (con validación de no duplicidad).
        *   Campo `Fecha`: Datepicker con valor por defecto igual a la fecha de hoy.
        *   Campo `Funcionario Responsable`: Caja de texto editable manual.
    *   **Sección B (Evaluación de Competencia):**
        *   Selector de Alternativa:
            *   `( ) El caso es de Competencia de la Dirección Provincial`
            *   `( ) El caso NO Compete a esta entidad`
    *   **Sección C (Fundamentos de la Asesoría):**
        *   Área de texto amplio (`Textarea` de mínimo 6 líneas):
        *   *Texto de ayuda integrado:* `"Describa detalladamente: Nombre y apellidos del solicitante, Carnet de Identidad, dirección/municipio, teléfono de contacto y descripción de la consulta legal planteada."`
    *   **Sección D (Clasificación Jurídica - Condicional):**
        *   *Si marcó "Competente":* Se habilitan dos subgrupos:
            1.  *Materia:* Desplegable con opciones: `Civil`, `Familiar`, `Trabajo y Seg. Social`, `Mercantil`, `Administrativo`.
            2.  *Vulnerabilidad:* Grupo de botones de radio: `( ) NNA` | `( ) VVD` | `( ) PAM` | `( ) PSD` | `( ) PJA`.
        *   *Si marcó "NO Compete":* Los subgrupos se muestran en gris (*disabled*) con una etiqueta explicativa: `"No aplica por falta de competencia material."`
    *   **Sección E (Campos Exclusivos de Dirección - Informativos):**
        *   Muestra dos campos en estado desactivado con candado visual:
            *   `Vía de Solución:` *[ Pendiente de dictamen por Dirección ]*
            *   `Estado de Resolución:` *[ Pendiente de dictamen por Dirección ]*
    *   **Botón de Acción:**
        *   Botón prominente: `Guardar y Enviar Expediente`.
        *   Ventana modal de confirmación antes del envío: *"¿Está seguro de enviar el expediente? Una vez guardado no podrá modificar los datos."*

### 5.3. Pantalla 3: Mis Expedientes Registrados (Rol: Atención)
*   **Propósito:** Brindar al personal de ventanilla una relación de control de los casos que ha atendido en la jornada o en el mes.
*   **Elementos Visuales:**
    *   Tabla con columnas: `No. Expediente`, `Fecha`, `Resumen Fundamentos (primeros 60 caracteres)`, `Competente (Sí/No)`, `Materia`, `Estado`.
    *   Acción única por fila: `Ver Ficha` (solo lectura, sin botones de edición).

### 5.4. Pantalla 4: Bandeja de Auditoría y Dictamen (Rol: Dirección)
*   **Propósito:** Proporcionar a la Directora Provincial el control exhaustivo de todos los casos de la provincia para su calificación y dictamen legal.
*   **Elementos Visuales:**
    *   Listado tabular de todos los expedientes provinciales, ordenados cronológicamente (más recientes primero).
    *   Indicador visual de estado mediante etiquetas de color (*badges*):
        *   *Pendiente de Dictamen* (Amarillo).
        *   *Resuelto* (Verde).
        *   *No Resuelto* (Naranja).
        *   *No Compete* (Gris).
    *   Botón de acción por fila: `Auditar y Dictaminar`.
*   **Modal / Vista de Dictamen de Caso:**
    *   Despliega el expediente completo para lectura minuciosa.
    *   Permite a la Directora:
        1. Modificar cualquier campo si existiera una errata (incluyendo Fundamentos y Materia).
        2. Seleccionar la **Vía de Solución** definitiva (`Proceso Judicial`, `Notarial`, `Administrativo`, `Métodos Alternos`).
        3. Seleccionar el **Estado del Caso** (`Resuelto` o `No Resuelto`).
        4. Botón `Eliminar Expediente` (con diálogo de confirmación que solicita justificación para evitar borrados accidentales).
        5. Botón `Guardar y Actualizar Estadísticas`.

### 5.5. Pantalla 5: Panel Estadístico Consolidado (Rol: Dirección)
*   **Propósito:** Visualizar de forma inmediata, en una única pantalla de alta densidad informativa, el comportamiento estadístico mensual y anual de la asesoría jurídica.
*   **Elementos Visuales:**
    *   Selector de Año de Consulta (por defecto el año en curso, ej. 2026).
    *   **Matriz Tabular General (13 Filas x 20 Columnas)**, estilizada profesionalmente con separación cromática por bloques de datos.

---

## 6. ESPECIFICACIÓN MATEMÁTICA DE LA MATRIZ ESTADÍSTICA

La tabla resumen provincial no requiere procesamiento externo; se calcula directamente sobre la base de datos de expedientes registrados.

### 6.1. Esquema Completo de Columnas de la Matriz

La tabla se estructura en **cinco (5) bloques conceptuales**:

```
┌─────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┐
│   BLOQUE 1      │   BLOQUE 2      │   BLOQUE 3      │   BLOQUE 4      │   BLOQUE 5      │
│ VOLUMEN GENERAL │   MATERIAS      │ VULNERABILIDAD  │     ESTADO      │ VÍAS SOLUCIÓN   │
└─────────────────┴─────────────────┴─────────────────┴─────────────────┴─────────────────┘
```

#### Detalle de Columnas (Izquierda a Derecha):
1. **Fila Base:** `Mes` (Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Septiembre, Octubre, Noviembre, Diciembre) + Fila Final: `TOTAL ACUMULADO`.
2. **Bloque 1: Volumen General**
   * Col 1: `Total Casos Atendidos` ($C_1$)
   * Col 2: `Total Casos Competentes` ($C_2$)
3. **Bloque 2: Desglose por Materias (Solo Competentes)**
   * Col 3: `Civil` ($M_1$)
   * Col 4: `Familiar` ($M_2$)
   * Col 5: `Trabajo y Seg. Social` ($M_3$)
   * Col 6: `Mercantil` ($M_4$)
   * Col 7: `Administrativo` ($M_5$)
4. **Bloque 3: Desglose por Vulnerabilidad Social**
   * Col 8: `NNA` ($V_1$)
   * Col 9: `VVD` ($V_2$)
   * Col 10: `PAM` ($V_3$)
   * Col 11: `PSD` ($V_4$)
   * Col 12: `PJA` ($V_5$)
5. **Bloque 4: Estado de los Casos**
   * Col 13: `Resueltos` ($E_1$)
   * Col 14: `No Resueltos` ($E_2$)
   * Col 15: `No Compete` ($E_3$)
6. **Bloque 5: Vías de Solución Dictaminadas (Solo Competentes)**
   * Col 16: `Proceso Judicial` ($S_1$)
   * Col 17: `Notarial` ($S_2$)
   * Col 18: `Administrativo` ($S_3$)
   * Col 19: `Métodos Alternos` ($S_4$)

---

### 6.2. Reglas de Validación y Consistencia Matemática (Auditoría Cruzada)

Para certificar que la matriz es inexpugnable ante inspecciones ministeriales, el sistema ejecutará internamente las siguientes comprobaciones lógicas por cada mes:

1. **Ecuación de Descarte de Competencia:**
   $$	ext{Total Casos Atendidos } (C_1) = 	ext{Total Competentes } (C_2) + 	ext{No Compete } (E_3)$$
2. **Cuadre de Materias vs. Competentes:**
   $$	ext{Total Competentes } (C_2) = M_1 + M_2 + M_3 + M_4 + M_5$$
3. **Cuadre de Vulnerabilidades vs. Competentes:**
   $$	ext{Total Competentes } (C_2) = V_1 + V_2 + V_3 + V_4 + V_5$$
   *(Nota: Siempre que la vulnerabilidad sea mutuamente excluyente. Si no hubiera vulnerabilidad aplicable, el sistema contabilizará un subtotal estricto).*
4. **Cuadre de Estados de Casos:**
   $$	ext{Total Casos Atendidos } (C_1) = 	ext{Resueltos } (E_1) + 	ext{No Resueltos } (E_2) + 	ext{No Compete } (E_3)$$
5. **Cuadre de Vías de Solución vs. Casos Dictaminados:**
   $$	ext{Total Dictaminados por Dirección} = S_1 + S_2 + S_3 + S_4$$
   *(Los casos competentes que aún no hayan sido dictaminados por la Dirección figurarán en la bandeja de auditoría hasta equilibrar la ecuación).*

---

## 7. PUNTOS CRÍTICOS PARA LA REUNIÓN DE NEGOCIACIÓN CON EL CLIENTE

Durante la reunión de mañana, estos cuatro (4) aspectos específicos deben ser presentados y puntualizados de forma explícita para fijar los acuerdos institucionales:

### 7.1. Punto 1: Formato y Consecutivo del "No. de Expediente"
*   **Situación:** En el requerimiento original se propone un campo de texto abierto.
*   **Propuesta técnica al cliente:** Proponer la generación **automática y secuencial** mediante el formato `EXP-[AÑO]-[NÚMERO]` (Ejemplo: `EXP-2026-0001`, `EXP-2026-0002`).
*   **Justificación para el cliente:** Evita que dos operadores utilicen el mismo número por equivocación, previene saltos numéricos y elimina errores de digitación en las auditorías provinciales. Si la Dirección ya utiliza un talonario oficial impreso, se admitirá el modo manual respetando su método tradicional.

### 7.2. Punto 2: Exclusividad vs. Concurrencia de Vulnerabilidades
*   **Situación:** Actualmente el diseño establece que las siglas son mutuamente excluyentes (un solo *radio button* por expediente).
*   **Propuesta técnica al cliente:** Validar si en la realidad de Camagüey se presentan casos donde coinciden múltiples condiciones (por ejemplo: un Adulto Mayor que además presenta Discapacidad: `PAM + PSD`, o una mujer víctima de violencia con menores a cargo: `VVD + NNA`).
*   **Acuerdo para MVP:** Mantenerlo como **excluyente** para la fase 1 (marcando la prevalente y anotando el resto en fundamentos) y dejar abierta la posibilidad de selección múltiple (*checkboxes*) para la fase 2 sin alterar la estructura central.

### 7.3. Punto 3: Estandarización de Responsables (Catálogo vs. Manual)
*   **Situación:** En el MVP, el campo `Responsable` es un texto libre tecleado por el operador.
*   **Riesgo informado al cliente:** Al teclear manualmente, el mismo funcionario puede ser registrado como *"Lic. Carlos Pérez"*, *"Carlos Pérez"* o *"carlos"*, imposibilitando futuros reportes de rendimiento individual por asesor.
*   **Acuerdo:** Se aprueba manual para la entrega inmediata del MVP, con el compromiso de que en la siguiente iteración se cargará una tabla de funcionarios predefinida administrada por la Dirección.

### 7.4. Punto 4: Política de Edición y Cancelación de Expedientes
*   **Situación:** La Dirección solicitó facultades plenas para editar y eliminar expedientes.
*   **Propuesta técnica al cliente:** Establecer que toda eliminación solicite un motivo obligatorio y quede registrada internamente en una bitácora técnica de seguridad, garantizando que no se alteren balances estadísticos ya remitidos a instancias superiores sin previo conocimiento de la Dirección.

---

## 8. DELIMITACIÓN DEL ALCANCE: MVP VS. FASES POSTERIORES

Para garantizar el cumplimiento de los tiempos de entrega pactados, el proyecto se divide rigurosamente en fases:

### 8.1. Fase 1: Producto Mínimo Viable (MVP) - En Alcance
*   Autenticación de usuarios bajo los tres roles (`Atención`, `Dirección`, `Admin`).
*   Formulario web interactivo con lógica condicional de bloqueo ante "No Compete".
*   Bandeja provincial de auditoría y dictamen de Vía de Solución y Estado por la Directora.
*   Permisos asimétricos (bloqueo para atención, edición y anulación exclusiva para dirección).
*   Tablero de Matriz Estadística Anual consolidada con los 5 bloques y cálculo automático.

### 8.2. Fase 2: Optimizaciones y Servicios Avanzados - Fuera de Alcance Inicial
*   Motor de búsqueda avanzado multicriterio (por rango de fechas, texto libre en fundamentos o carnet).
*   Exportación con un solo clic de la Matriz Estadística hacia Microsoft Excel (`.xlsx`) o reporte oficial en PDF con membrete del MINJUS.
*   Módulo de gestión de catálogo de funcionarios responsables.
*   Métricas gráficas (gráficos de barras y pastel por materia y vulnerabilidad).

---

## 9. ACTA DE APROBACIÓN DE LA PROPUESTA TÉCNICA

Por medio del presente documento, las partes manifiestan su conformidad con los requerimientos funcionales, reglas lógicas y alcance aquí expuestos para el desarrollo del sistema **Web Estadística Justicia**:

| Por el Equipo de Desarrollo | Por la Dirección Provincial de Justicia |
| :--- | :--- |
| **Firma:** _________________________________ | **Firma:** _________________________________ |
| **Nombre:** Responsable Técnico del Proyecto | **Nombre:** Directora Provincial de Justicia |
| **Fecha:** _____ / _____ / 2026 | **Fecha:** _____ / _____ / 2026 |
| **Lugar:** Camagüey, Cuba | **Lugar:** Camagüey, Cuba |
