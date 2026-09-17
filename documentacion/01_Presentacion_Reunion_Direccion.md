# PROPUESTA DE SOLUCIÓN Y FLUJO OPERATIVO
## SISTEMA DE ASESORÍA JURÍDICA Y ESTADÍSTICA PROVINCIAL ("WEB ESTADÍSTICA JUSTICIA")
**Entidad:** Dirección Provincial de Justicia de Camagüey  
**Fecha de Presentación:** Marzo de 2026  
**Documentación de Apoyo:** [Documento de Requisitos Funcionales Completo](../Documento_Requisitos_Funcionales_Web_Estadistica_Justicia.md)  
**Diagrama Interactivo del Flujo:** [Abrir Diagrama HTML Interactivo](./diagramas/flujo_asesoria_justicia.html)

---

## 1. RESUMEN EJECUTIVO PARA LA DIRECCIÓN

El sistema **"Web Estadística Justicia"** ha sido concebido para resolver de forma definitiva los tres cuellos de botella actuales en el área de atención ciudadana:

1. **Eliminación del conteo manual:** Sustituye los libros de registro físico y el cuadre artesanal por un registro digital inmediato.
2. **Garantía de uniformidad estadística:** Separa objetivamente los casos que corresponden a la competencia del Ministerio de Justicia de aquellos ajenos a su jurisdicción, asegurando que las cifras elevadas al MINJUS sean 100% auditables e inobjetables.
3. **Control y supervisión directa:** La Dirección Provincial mantiene el control exclusivo sobre el dictamen de las vías de solución y la calificación del estado de cada expediente.

---

## 2. ARQUITECTURA DE FUNCIONES Y SEGURIDAD (ROLES)

El sistema opera bajo una estricta separación de responsabilidades:

```
┌──────────────────────────────────────┐     ┌──────────────────────────────────────┐
│       VENTANILLA / ATENCIÓN          │     │        DIRECCIÓN PROVINCIAL          │
├──────────────────────────────────────┤     ├──────────────────────────────────────┤
│ • Recepción física del ciudadano.    │     │ • Supervisión y auditoría total.     │
│ • Registro del caso y fáctico.       │     │ • Dictamen de la Vía de Solución.    │
│ • Evaluación inicial de competencia. │     │ • Calificación: Resuelto/No Resuelto │
│ • Clasificación (Materia/Vulnerab.). │     │ • Rectificación y baja justificada.  │
│ • Bloqueo tras guardar (sin editar). │     │ • Explotación de Matriz Estadística. │
└──────────────────┬───────────────────┘     └──────────────────▲───────────────────┘
                   │                                            │
                   └────────── Envío a Bandeja Provincial ──────┘
```

---

## 3. FLUJO OPERATIVO EN DOS ETAPAS

Para facilitar la comprensión visual de este flujo ante el consejo de dirección, se ha generado el diagrama técnico interactivo en:  
👉 **[`docs/diagramas/flujo_asesoria_justicia.html`](./diagramas/flujo_asesoria_justicia.html)** *(puede abrirse directamente en cualquier navegador)*.

### Etapa 1: Ventanilla (Atención al Ciudadano)
1. **Comparecencia:** El ciudadano acude y el operador abre un nuevo expediente.
2. **Captura Fáctica:** Se consigna el número de expediente, funcionario actuante y una síntesis exhaustiva en los *Fundamentos* (nombres, carnet de identidad, dirección, teléfono y descripción del conflicto).
3. **Filtro de Competencia (Regla RN-01):**
   - **Si Compete:** Se habilita la selección de **Materia** (*Civil, Familiar, Laboral, Mercantil, Administrativo*) y **Vulnerabilidad** (*NNA, VVD, PAM, PSD, PJA*).
   - **Si NO Compete:** Los campos de materia y vía se desactivan automáticamente. El expediente queda catalogado como *No Compete*, sumándose al total de atenciones pero excluyéndose de las ramas sustantivas.
4. **Envío:** Al pulsar *"Guardar y Enviar"*, el registro queda bloqueado para el operador, evitando alteraciones posteriores.

### Etapa 2: Dirección (Auditoría y Dictamen Legal)
1. **Bandeja Provincial:** La Directora visualiza todos los casos con indicadores de estado (*Pendiente, Resuelto, No Resuelto, No Compete*).
2. **Auditoría Individual:** Accede a la ficha, lee los fundamentos y corrige erratas materiales si existieran.
3. **Dictamen Institucional:**
   - Asigna la **Vía de Solución** (*Proceso Judicial, Notarial, Administrativo, Métodos Alternos*).
   - Califica el **Estado Final** (*Resuelto* o *No Resuelto*).
4. **Consolidación en Tiempo Real:** Al confirmar, las cifras impactan inmediatamente en la celda correspondiente del mes y en el acumulado anual de la provincia.

---

## 4. LA MATRIZ ESTADÍSTICA PROVINCIAL AUTOMATIZADA

La matriz anual presenta **13 filas** (Enero a Diciembre + Total Acumulado) y **20 columnas** organizadas en 5 bloques:

1. **Bloque 1 (Volumen General):** Total Casos Atendidos y Total Casos Competentes.
2. **Bloque 2 (Materias):** Civil, Familiar, Trabajo y Seg. Social, Mercantil, Administrativo.
3. **Bloque 3 (Vulnerabilidades):** NNA, VVD, PAM, PSD, PJA.
4. **Bloque 4 (Estado del Caso):** Resueltos, No Resueltos, No Compete.
5. **Bloque 5 (Vías de Solución):** Proceso Judicial, Notarial, Administrativo, Métodos Alternos.

### Ecuación de Blindaje Estadístico (Consistencia Matemática):
$$\text{Total Casos Atendidos} = \text{Competentes} + \text{No Compete}$$
$$\text{Total Casos Competentes} = M_1 + M_2 + M_3 + M_4 + M_5 = V_1 + V_2 + V_3 + V_4 + V_5$$
$$\text{Total Casos Atendidos} = \text{Resueltos} + \text{No Resueltos} + \text{No Compete}$$

---

## 5. RECURSOS DISPONIBLES PARA LA REUNIÓN

- **Especificación Completa:** [`Documento_Requisitos_Funcionales_Web_Estadistica_Justicia.md`](../Documento_Requisitos_Funcionales_Web_Estadistica_Justicia.md)
- **Hoja de Trabajo para Acuerdos:** [`02_Puntos_Negociacion_y_Acuerdos.md`](./02_Puntos_Negociacion_y_Acuerdos.md)
- **Diagrama de Flujo Interactivo:** [`docs/diagramas/flujo_asesoria_justicia.html`](./diagramas/flujo_asesoria_justicia.html)
