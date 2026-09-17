# ESPECIFICACIÓN INTEGRAL DE FLUJO DE EXPEDIENTE Y ÁRBOLES DE DECISIÓN
## SISTEMA DE ASESORÍA JURÍDICA Y ESTADÍSTICA PROVINCIAL ("WEB ESTADÍSTICA JUSTICIA")
**Cliente:** Dirección Provincial de Justicia de Camagüey  
**Tipo de Documento:** Guía Operativa, Modelo de Campos y Lógica de Decisión Paso a Paso  
**Versión:** 1.0  
**Fecha:** Marzo de 2026  

---

## 1. INTRODUCCIÓN Y VISIÓN PANORÁMICA

Este documento describe con granularidad técnica y funcional el ciclo de vida completo de un expediente dentro del sistema **"Web Estadística Justicia"**, desde el momento en que un ciudadano comparece ante la ventanilla de **Atención a la Ciudadanía** hasta que el caso es auditado, dictaminado y cerrado por la **Directora Provincial de Justicia**, impactando de forma matemática e inmediata en la **Matriz Estadística Provincial**.

```mermaid
flowchart TD
    subgraph ETAPA1["ETAPA 1: VENTANILLA (ATENCIÓN A LA CIUDADANÍA)"]
        A["1.1 Llegada física del ciudadano"] --> B["1.2 Apertura de formulario"]
        B --> C["1.3 Captura de datos de cabecera y Fundamentos"]
        C --> D{"¿Es competencia de Justicia? (Decisión D-1)"}
        D -- "SÍ" --> E["Habilitación de Materia y Vulnerabilidad"]
        D -- "NO" --> F["Bloqueo automático RN-01: Estado = 'No Compete'"]
        E --> G["Envío a Dirección (Bloqueo de edición operador)"]
        F --> G
    end

    subgraph ETAPA2["ETAPA 2: DIRECCIÓN PROVINCIAL (AUDITORÍA Y DICTAMEN)"]
        G --> H["2.1 Bandeja Provincial (Badge 'Pendiente' o 'No Compete')"]
        H --> I["2.2 Apertura de Ficha Individual de Auditoría"]
        I --> J{"¿Requiere rectificación fáctica? (Decisión D-2)"}
        J -- "SÍ" --> K["Edición de fáctico/materia por Directora"]
        J -- "NO" --> L{"¿Es caso No Compete? (Decisión D-3)"}
        K --> L
        L -- "SÍ" --> M["Confirmación directa de archivo No Compete"]
        L -- "NO" --> N["Asignación de Vía de Solución (Decisión D-4)"]
        N --> O["Dictamen de Estado: Resuelto / No Resuelto (Decisión D-5)"]
        O --> P["Guardar y Consolidar"]
        M --> P
    end

    subgraph IMPACTO["IMPACTO ESTADÍSTICO EN TIEMPO REAL"]
        P --> Q["Matriz Provincial: Actualización de celda mensual y total anual"]
    end

    style ETAPA1 fill:#f0f9ff,stroke:#0284c7,stroke-width:2px;
    style ETAPA2 fill:#fdf4ff,stroke:#c026d3,stroke-width:2px;
    style IMPACTO fill:#f0fdf4,stroke:#16a34a,stroke-width:2px;
```

---

## 2. ETAPA 1: ATENCIÓN A LA CIUDADANÍA (VENTANILLA)

### 2.1. Descripción Operativa
El ciudadano comparece físicamente en la sede provincial. El operador de ventanilla accede al sistema con su usuario y contraseña (rol `Atención`) y pulsa en **"Nuevo Expediente"**.

---

### 2.2. Catálogo Detallado de Campos en Etapa 1

| Campo | Control de Interfaz (UI) | Tipo / Longitud | Obligatorio | Valor por Defecto / Ayuda (*Placeholder*) | Comportamiento y Validación |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **`no_expediente`** | Caja de texto (`<input type="text">`) | Alfanumérico (VarChar 50) | **SÍ** | `"EXP-2026-0001"` *(o manual)* | Clave única. El sistema valida en tiempo real que no exista duplicidad en la base de datos provincial. |
| **`fecha_atencion`** | Selector de fecha (`<input type="date">`) | Date (YYYY-MM-DD) | **SÍ** | Fecha actual del servidor | Bloquea fechas futuras. Permite retroceder si se regularizan casos del día anterior. |
| **`responsable`** | Caja de texto (`<input type="text">`) | VarChar(150) | **SÍ** | `"Nombre y apellidos del asesor"` | Nombre del funcionario que atiende al ciudadano. |
| **`es_competente`** | Selector de Radio Button doble | Booleano (`true` / `false`) | **SÍ** | *(Sin selección previa obligatoria)* | **Interruptor maestro del árbol de decisión.** Dispara la lógica condicional en la interfaz. |
| **`fundamentos`** | Área de texto enriquecido / multilinea (`<textarea rows="6">`) | Text (hasta 4000 caracteres) | **SÍ** | *"Describa detalladamente: Nombre y apellidos del solicitante, Carnet de Identidad, dirección/municipio, teléfono de contacto y resumen fáctico de la consulta..."* | **Campo exhaustivo de identificación.** Al no existir campos atómicos separados para los datos personales, concentra la información civil y los hechos del conflicto (Regla RN-02). |
| **`materia`** | Menú desplegable (`<select>`) | Enum (5 opciones) | **Condicional** | *"Seleccione la rama jurídica..."* | **Habilitado solo si `es_competente = true`.** Si es falso, permanece deshabilitado (`disabled`) con valor `NULL`. |
| **`vulnerabilidad`** | Grupo de 5 Radio Buttons | Enum (5 siglas) | **Condicional** | *(Ninguno marcado)* | **Habilitado solo si `es_competente = true`.** Opción única obligatoria si compete. |
| **`via_solucion`** | Caja informativa bloqueada con candado | Enum | **NO (Para Ventanilla)** | `[ Pendiente de dictamen por Dirección ]` | **Solo lectura / bloqueado.** El operador no puede modificar ni seleccionar este valor. |
| **`estado_caso`** | Caja informativa bloqueada con candado | Enum | **NO (Para Ventanilla)** | `[ Pendiente de dictamen por Dirección ]` *(o "No Compete" automático)* | Si `es_competente = false`, muestra automáticamente `"No Compete"`. Si es verdadero, muestra `"Pendiente de Auditoría"`. |

---

### 2.3. Árbol de Decisión 1 (AD-1): En Ventanilla

```mermaid
flowchart TD
    INICIO(["Inicio: Operador captura No. Exp, Fecha, Responsable y Fundamentos"]) --> EVAL{"¿El asunto compete a la Dirección Provincial de Justicia?"}
    
    EVAL -- "SÍ (es_competente = true)" --> COMP_SI["1. Desbloquear campos 'Materia' y 'Vulnerabilidad'<br>2. Ocultar mensaje de descarte<br>3. Estado_caso interno = 'Pendiente'"]
    
    COMP_SI --> SEL_MAT{"Selección de Materia (Obligatoria)"}
    SEL_MAT --> M1["Civil (Propiedad, herencias, contratos)"]
    SEL_MAT --> M2["Familiar (Divorcios, pensiones, guarda y cuidado)"]
    SEL_MAT --> M3["Trabajo y Seg. Social (Reclamaciones, pensiones)"]
    SEL_MAT --> M4["Mercantil (MIPYMES, cooperativas, comercio)"]
    SEL_MAT --> M5["Administrativo (Vivienda, actos administrativos)"]
    
    M1 & M2 & M3 & M4 & M5 --> SEL_VULN{"Selección de Vulnerabilidad (Obligatoria, Opción Única)"}
    SEL_VULN --> V1["NNA: Niño, Niña o Adolescente"]
    SEL_VULN --> V2["VVD: Víctima de Violencia / Discriminación"]
    SEL_VULN --> V3["PAM: Persona Adulto Mayor"]
    SEL_VULN --> V4["PSD: Persona en Situación de Discapacidad"]
    SEL_VULN --> V5["PJA: Persona Jurídico Ausente"]
    
    V1 & V2 & V3 & V4 & V5 --> BOTON_ENV["Pulsar 'Guardar y Enviar Expediente'"]

    EVAL -- "NO (es_competente = false)" --> COMP_NO["1. Bloquear inmediatamente 'Materia' (set NULL)<br>2. Bloquear 'Vulnerabilidad' (set NULL)<br>3. Bloquear 'Vía de Solución' (set NULL)<br>4. Asignar automáticamente estado_caso = 'No Compete'"]
    
    COMP_NO --> BOTON_ENV
    
    BOTON_ENV --> CONFIRM{"Modal de Confirmación:<br>¿Está seguro de enviar? Una vez enviado no podrá modificar los datos"}
    CONFIRM -- "Cancelar" --> EDITAR["Permite seguir editando"]
    CONFIRM -- "Aceptar" --> GUARDADO["1. Inserción en Base de Datos<br>2. Expediente Bloqueado para Operador (RN-03)<br>3. Notificación a Bandeja Provincial de Dirección"]

    style EVAL fill:#fef08a,stroke:#ca8a04,stroke-width:2px;
    style COMP_NO fill:#fee2e2,stroke:#dc2626,stroke-width:2px;
    style COMP_SI fill:#dcfce7,stroke:#16a34a,stroke-width:2px;
    style CONFIRM fill:#e0e7ff,stroke:#4f46e5,stroke-width:2px;
```

---

## 3. ETAPA INTERMEDIA: TRANSFERENCIA Y BLOQUEO DE INTEGRIDAD (RN-03)

1. **Inmutabilidad para Ventanilla:** En cuanto el operador confirma el envío, el registro pasa a estado protegido.
2. **Acceso de Ventanilla en *"Mis Expedientes"*:**
   - La pantalla muestra una tabla de consulta histórica de los casos creados por dicho operador.
   - Solo dispone del botón **`Ver Ficha`** en modalidad estrictamente de solo lectura.
   - No existen botones de *"Editar"*, *"Actualizar"* ni *"Borrar"*.
   - Cualquier error detectado con posterioridad por el operador debe ser comunicado formalmente a la Directora para su enmienda institucional.

---

## 4. ETAPA 2: DIRECCIÓN PROVINCIAL (AUDITORÍA, DICTAMEN Y CIERRE)

### 4.1. Descripción Operativa
La **Directora Provincial de Justicia** accede al sistema con sus credenciales de máxima jerarquía funcional (rol `Dirección`). La plataforma la sitúa en la **Bandeja Provincial de Expedientes**, donde confluyen todas las atenciones registradas en la provincia.

---

### 4.2. Vista 1 de Dirección: Bandeja Provincial de Expedientes

La bandeja presenta el listado general con herramientas de ordenación cronológica y semáforo visual:

| Elemento UI | Descripción / Función |
| :--- | :--- |
| **Tabla Provincial** | Columnas: `No. Expediente`, `Fecha`, `Responsable`, `Competente`, `Materia`, `Vulnerabilidad`, `Estado`, `Acciones`. |
| **Badges de Estado** | • **Amarillo (`Pendiente`):** Caso competente enviado por ventanilla que aún no ha sido dictaminado por la Directora.<br>• **Gris (`No Compete`):** Caso descartado por falta de jurisdicción institucional.<br>• **Verde (`Resuelto`):** Caso concluido satisfactoriamente con orientación agotada.<br>• **Naranja (`No Resuelto`):** Caso concluido por incomparecencia o falta de elementos. |
| **Filtro Rápido** | Permite filtrar por: *Todos los casos*, *Pendientes de dictamen*, *Casos resueltos*, *No compete*. |
| **Botón de Acción por Fila** | **`Auditar y Dictaminar`**: Abre el modal / pantalla de auditoría individual del caso. |

---

### 4.3. Vista 2 de Dirección: Ficha de Auditoría y Dictamen Legal

Al ingresar a la ficha del caso, la Directora tiene a su disposición todos los campos del expediente con facultades plenas de rectificación y dictamen:

| Sección en Ficha | Campos Disponibles | Permisos de Dirección | Reglas de Interacción |
| :--- | :--- | :---: | :--- |
| **Cabecera** | `no_expediente`, `fecha_atencion`, `responsable` | Edición plena | Permite rectificar errores en la numeración o el nombre del asesor. |
| **Fáctico** | `fundamentos` | Edición plena | Permite enriquecer, clarificar o corregir la redacción fáctica de ventanilla. |
| **Competencia** | `es_competente` | Edición plena | Si la Directora rectifica de "No Compete" a "Competente" (o viceversa), el sistema reajusta la visibilidad de los catálogos. |
| **Clasificación** | `materia`, `vulnerabilidad` | Edición plena | Permite rectificar la rama jurídica si el operador la tipificó erróneamente. |
| **Dictamen: Vía de Solución** | `via_solucion` | **Exclusivo de Dirección** | Menú desplegable con 4 opciones institucionales. Obligatorio si el caso es competente. |
| **Dictamen: Estado del Caso** | `estado_caso` | **Exclusivo de Dirección** | Selector entre `Resuelto` y `No Resuelto`. (Si es "No Compete", se fija automáticamente). |
| **Botón Crítico de Baja** | `Eliminar Expediente` | **Exclusivo de Dirección** | Abre modal de confirmación exigiendo **Motivo obligatorio** y dejando rastro en la bitácora técnica. |
| **Botón de Cierre** | `Guardar y Actualizar Estadísticas` | **Exclusivo de Dirección** | Cierra el ciclo del expediente e impacta en la Matriz. |

---

### 4.4. Árbol de Decisión 2 (AD-2): En la Ficha de Dirección

```mermaid
flowchart TD
    BANDEJA(["Directora selecciona expediente en Bandeja Provincial"]) --> ABRIR["Abre Ficha de Auditoría y lee Fundamentos"]
    
    ABRIR --> DEC_BAJA{"¿El expediente es inválido, duplicado o viciado de nulidad?"}
    
    DEC_BAJA -- "SÍ (Solicita Baja)" --> MODAL_BAJA["Modal de Seguridad:<br>Ingresar motivo obligatorio de eliminación"]
    MODAL_BAJA --> REG_BITACORA["Registro en Bitácora de Auditoría:<br>Fecha, Usuario, No. Exp y Justificación"]
    REG_BITACORA --> FIN_ELIMINADO(["Expediente eliminado / Baja lógica"])
    
    DEC_BAJA -- "NO" --> DEC_RECT{"¿Los fundamentos o clasificación contienen erratas de ventanilla?"}
    
    DEC_RECT -- "SÍ" --> RECTIFICAR["Directora enmienda: No. Exp, Responsable, Fundamentos o Materia"]
    DEC_RECT -- "NO" --> DEC_COMP{"¿El caso es Competente o No Compete?"}
    RECTIFICAR --> DEC_COMP
    
    DEC_COMP -- "Es NO COMPETE" --> CIERRE_NO_COMP["1. Verifica que Materia y Vulnerabilidad sean NULL<br>2. Estado permanece inalterable: 'No Compete'<br>3. Vía de Solución permanece NULL"]
    
    DEC_COMP -- "Es COMPETENTE" --> ASIG_VIA{"Selección Obligatoria de VÍA DE SOLUCIÓN"}
    
    ASIG_VIA --> S1["Proceso Judicial: Remisión formal a Tribunales Populares"]
    ASIG_VIA --> S2["Notarial: Remisión a Notaría (escrituras, testamentos, poderes)"]
    ASIG_VIA --> S3["Administrativo: Solución en Vivienda, Carné, Planif. Física, etc."]
    ASIG_VIA --> S4["Métodos Alternos: Conciliación, mediación o negociación guiada"]
    
    S1 & S2 & S3 & S4 --> ASIG_ESTADO{"Dictamen Obligatorio de ESTADO DEL CASO"}
    
    ASIG_ESTADO --> E_RESUELTO["Resuelto: Consulta evacuada y trámite encauzado con éxito"]
    ASIG_ESTADO --> E_NO_RESUELTO["No Resuelto: Falta de comparecencia, falta de pruebas o informe pendiente"]
    
    E_RESUELTO & E_NO_RESUELTO & CIERRE_NO_COMP --> GUARDAR_DIR["Pulsar 'Guardar y Actualizar Estadísticas'"]
    
    GUARDAR_DIR --> IMPACTO_MATRIZ["RECALCULO INMEDIATO DE LA MATRIZ:<br>• Incrementa celda del mes correspondiente (1-12)<br>• Incrementa acumulado anual (Fila 13)<br>• Verifica cuadre de ecuaciones de consistencia"]

    style DEC_BAJA fill:#fee2e2,stroke:#dc2626,stroke-width:2px;
    style DEC_COMP fill:#fef08a,stroke:#ca8a04,stroke-width:2px;
    style ASIG_VIA fill:#e0e7ff,stroke:#4338ca,stroke-width:2px;
    style ASIG_ESTADO fill:#dcfce7,stroke:#15803d,stroke-width:2px;
    style IMPACTO_MATRIZ fill:#ecfdf5,stroke:#059669,stroke-width:3px;
```

---

## 5. IMPACTO EXACTO EN LA MATRIZ ESTADÍSTICA (MAPEO DE CELDAS)

Cuando la Directora confirma el dictamen, el caso impacta exclusivamente en la fila del **Mes de Atención** (`fecha_atencion`) y en la fila final **TOTAL ACUMULADO**, de acuerdo con las siguientes reglas:

```
┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ CASO TIPO A: "NO COMPETE"                                                                                      │
├────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  [+] Suma +1 en Bloque 1: 'Total Casos Atendidos' (Col 1)                                                      │
│  [=] NO suma en Bloque 1: 'Total Casos Competentes' (Col 2 queda intacta)                                      │
│  [=] NO suma en Bloque 2: 'Materias' (Cols 3 a 7 quedan intactas)                                              │
│  [=] NO suma en Bloque 3: 'Vulnerabilidades' (Cols 8 a 12 quedan intactas)                                    │
│  [+] Suma +1 en Bloque 4: 'No Compete' (Col 15)                                                                │
│  [=] NO suma en Bloque 5: 'Vías de Solución' (Cols 16 a 19 quedan intactas)                                     │
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ CASO TIPO B: "COMPETENTE" (Ejemplo: Familiar, Adulto Mayor [PAM], Notarial, Resuelto)                         │
├────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  [+] Suma +1 en Bloque 1: 'Total Casos Atendidos' (Col 1)                                                      │
│  [+] Suma +1 en Bloque 1: 'Total Casos Competentes' (Col 2)                                                    │
│  [+] Suma +1 en Bloque 2: Materia correspondiente ('Familiar', Col 4)                                          │
│  [+] Suma +1 en Bloque 3: Vulnerabilidad correspondiente ('PAM', Col 10)                                      │
│  [+] Suma +1 en Bloque 4: Estado correspondiente ('Resueltos', Col 13)                                         │
│  [+] Suma +1 en Bloque 5: Vía de Solución dictaminada ('Notarial', Col 17)                                      │
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 6. SÍNTESIS COMPARATIVA DE CAMPOS POR ROL

| Campo | Rol: Personal de Atención | Rol: Directora Provincial | Rol: Administrador Técnico |
| :--- | :---: | :---: | :---: |
| `no_expediente` | Escritura inicial | Lectura y Rectificación | Sin acceso |
| `fecha_atencion` | Escritura inicial | Lectura y Rectificación | Sin acceso |
| `responsable` | Escritura inicial | Lectura y Rectificación | Sin acceso |
| `es_competente` | Selección inicial | Lectura y Rectificación | Sin acceso |
| `fundamentos` | Redacción inicial | Lectura y Rectificación | Sin acceso |
| `materia` | Selección inicial (si compete) | Lectura y Rectificación | Sin acceso |
| `vulnerabilidad` | Selección inicial (si compete) | Lectura y Rectificación | Sin acceso |
| `via_solucion` | **Bloqueado (Solo lectura)** | **Dictamen Obligatorio** | Sin acceso |
| `estado_caso` | **Bloqueado (Solo lectura)** | **Dictamen Obligatorio** | Sin acceso |
| `Eliminar registro` | **Prohibido** | **Permitido con justificación** | Sin acceso |
| `Matriz Estadística` | **Sin acceso** | **Acceso y explotación plena** | Sin acceso |
