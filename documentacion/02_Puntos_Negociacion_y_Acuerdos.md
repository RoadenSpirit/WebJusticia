# GUÍA DE PUNTOS CRÍTICOS Y ACUERDOS DE REUNIÓN
## PROYECTO: "WEB ESTADÍSTICA JUSTICIA" (CAMAGÜEY)
**Objetivo:** Obtener la validación formal de la Directora Provincial en los cuatro puntos de diseño que impactan la operativa diaria.

---

### PUNTO 1: CONSECUTIVO DEL NÚMERO DE EXPEDIENTE

* **Pregunta para el Cliente:**  
  *¿Desean mantener la digitación libre de números de expediente o prefieren una numeración correlativa automática administrada por el sistema?*
* **Propuesta del Equipo Técnico:**  
  Generación automática con formato `EXP-[AÑO]-[NÚMERO]` (ej. `EXP-2026-0001`).  
  *Ventaja:* Evita expedientes duplicados, omisiones y números traspapelados entre distintos operadores.
* **Espacio para el Acuerdo:**
  > [ ] **Aprobado:** Generación automática (`EXP-2026-XXXX`).  
  > [ ] **Alternativa:** Entrada manual para compatibilidad con talonario físico preexistente.  
  > **Observaciones:** _______________________________________________________

---

### PUNTO 2: VULNERABILIDADES (¿EXCLUYENTES O MÚLTIPLES?)

* **Pregunta para el Cliente:**  
  *¿Cómo debe registrarse a un ciudadano que reúne simultáneamente varias condiciones de vulnerabilidad (ej. Adulto Mayor + Discapacidad: `PAM + PSD`)?*
* **Propuesta del Equipo Técnico para el MVP:**  
  Selección de una vulnerabilidad principal prevalente en el selector y constancia de las secundarias en el texto de los *Fundamentos*.  
  *Justificación:* Mantiene la exactitud matemática de la matriz ($\text{Total} = V_1 + V_2 + \dots$) sin sobredimensionar el número real de personas atendidas.
* **Espacio para el Acuerdo:**
  > [ ] **Aprobado para MVP:** Opción única excluyente (la principal).  
  > [ ] **Fase 2:** Evaluación de casillas múltiples con subtotal estadístico desacoplado.  
  > **Observaciones:** _______________________________________________________

---

### PUNTO 3: REGISTRO DEL FUNCIONARIO RESPONSABLE

* **Pregunta para el Cliente:**  
  *¿El nombre del asesor se digita en texto libre o se selecciona de una lista predefinida de funcionarios de la Dirección?*
* **Propuesta del Equipo Técnico:**  
  Texto libre para el MVP de entrega inmediata, con compromiso de migrar a un listado cerrado y administrable en la Fase 2.
* **Espacio para el Acuerdo:**
  > [ ] **Aprobado:** Texto libre para entrega inicial.  
  > [ ] **Preferencia:** Cargar de inicio la nómina de funcionarios autorizados.  
  > **Observaciones:** _______________________________________________________

---

### PUNTO 4: PROTOCOLO DE RECTIFICACIÓN Y BAJA DE EXPEDIENTES

* **Pregunta para el Cliente:**  
  *¿Qué controles deben regir cuando la Dirección necesite rectificar o dar de baja un expediente ya registrado?*
* **Propuesta del Equipo Técnico:**  
  Exclusividad absoluta para el rol *Dirección*. Toda baja o modificación sustancial requerirá un motivo justificado que quedará registrado en una bitácora técnica de seguridad para preservar la transparencia ante inspecciones del MINJUS.
* **Espacio para el Acuerdo:**
  > [ ] **Aprobado:** Bitácora de auditoría con motivo obligatorio de anulación.  
  > **Observaciones:** _______________________________________________________

---

### FIRMAS DE CONFORMIDAD

| Por la Dirección Provincial de Justicia | Por el Equipo de Desarrollo |
| :--- | :--- |
| **Nombre:** ____________________________ | **Nombre:** ____________________________ |
| **Cargo:** Directora Provincial | **Cargo:** Responsable Técnico |
| **Firma:** _____________________________ | **Firma:** _____________________________ |
| **Fecha:** _____ / _____ / 2026 | **Fecha:** _____ / _____ / 2026 |
