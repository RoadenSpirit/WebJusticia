---
name: Web Estadística Justicia (SIAC-JUS)
institution: Dirección Provincial de Justicia de Camagüey
ministry: Ministerio de Justicia (MINJUS) • República de Cuba
mode: Operate
version: 1.0.0
description: Sistema Oficial de Radicación de Asesoría Jurídica y Tabulación de la Matriz Estadística Provincial (20 Columnas)
---

# MANUAL DE IDENTIDAD VISUAL Y DISEÑO DE INTERFAZ (DESIGN.md)

Este documento fija la norma estética, jerarquía visual, paleta semántica y principios de interacción del sistema **Web Estadística Justicia**, conforme a los lineamientos de diseño institucional del Ministerio de Justicia y la directriz `impeccable` (Modo *Operate*).

---

## 1. Filosofía de Diseño: "Autoridad, Claridad Documental y Rigor Jurídico"

* **No es una plantilla SaaS ni una landing comercial:** Es una aplicación pública ministerial orientada a funcionarios del derecho y directores técnicos.
* **El instrumento desaparece en la labor:** Interfaz sobria, sin animaciones decorativas gratuitas ni gradientes estridentes.
* **Inmutabilidad y Fe Pública:** Cada pantalla evoca un acta legal estructurada (fechas, consecutivos oficiales, sellos de estado).
* **Cero ambigüedad interactiva:** Los elementos seleccionados (materias, vulnerabilidades, competencia) presentan estados activos inequívocos y de alto contraste.

---

## 2. Paleta de Colores Institucional (Design Tokens)

```yaml
colors:
  # Identidad Ministerial Principal
  ministerial:
    950: "#061322"   # Cintillo supremo de la República
    900: "#0c2340"   # Barra superior, botones de máxima jerarquía
    800: "#0f2744"   # Fondo de cabecera principal y tarjetas activas
    700: "#183c66"   # Hover primario e insignias de módulo
    600: "#255388"   # Bordes de foco y selección

  # Acento Dorado Heráldico (Dirección y Sellos de Autoridad)
  heraldic:
    gold: "#b8860b"       # Distintivo Directora Provincial
    gold-light: "#fef3c7" # Fondo de insignias VIP
    gold-border: "#fde68a"# Borde acentuado

  # Lienzo y Papelería Administrativa
  surface:
    canvas: "#f1f5f9"    # Fondo general del sistema (descanso ocular en turnos largos)
    paper: "#ffffff"     # Tarjetas de acta y tablas
    subtle: "#f8fafc"    # Bloques de datos secundarios
    input-bg: "#f8fafc"  # Fondo de inputs en reposo

  # Bordes y Separadores
  border:
    default: "#cbd5e1"   # Delimitadores de campos y tablas
    strong: "#94a3b8"    # Bordes de agrupación formal
    active: "#0f2744"    # Borde de selección obligatoria

  # Semáforo Procesal Institucional (Bandeja y Matriz)
  states:
    resuelto:
      text: "#14532d"
      bg: "#dcfce7"
      border: "#86efac"
    pendiente:
      text: "#78350f"
      bg: "#fef3c7"
      border: "#fcd34d"
    no-resuelto:
      text: "#7c2d12"
      bg: "#ffedd5"
      border: "#fdba74"
    no-compete:
      text: "#334155"
      bg: "#e2e8f0"
      border: "#cbd5e1"
```

---

## 3. Sistema Tipográfico

* **Tipografía de Interfaz:** `Inter`, `Segoe UI`, `system-ui`, `-apple-system`, `sans-serif`.
  * Escala fija y compacta adaptada al software administrativo.
  * Títulos de sección: `text-xs font-black uppercase tracking-wider text-[#0f2744]`.
  * Etiquetas de formulario: `text-[10px] font-bold text-slate-600 uppercase tracking-wider`.
* **Tipografía Numérica Tabular (`font-mono tabular-nums`):**
  * **Uso obligatorio** para:
    1. Carnets de Identidad (`74051209871`) con espaciado uniforme.
    2. Consecutivos de expediente (`EXP-2026-0001`).
    3. Celdas numéricas de la Matriz Estadística de 20 columnas.
    4. Horas y sellos de tiempo.

---

## 4. Jerarquía de Componentes y Reglas de Interacción

### A. Botones y Selectores
1. **Botón Principal de Radicación:** Azul ministerial profundo (`#0f2744`), texto blanco en mayúsculas, peso semibold/extrabold, sombra suave.
2. **Tarjetas Selectoras (Materias y Vulnerabilidades):**
   * **Estado Inactivo:** Fondo blanco, borde `#cbd5e1`, texto `#1e293b`.
   * **Estado Hover:** Borde `#94a3b8`.
   * **Estado Seleccionado (Activo):** Fondo `#0f2744`, texto blanco, borde `#0f2744`, sombra y anillo de confirmación.
3. **Interruptor de Competencia (RN-01):**
   * "SÍ COMPETE": Verde oliva ministerial (`#15803d`) al estar activo.
   * "NO COMPETE": Gris pizarra oscuro (`#1e293b`) al estar activo, con despliegue de alerta explicativa institucional.

### B. Formularios como "Acta Notarial"
* Los datos del ciudadano se ordenan por numerales romanos:
  * **I. Generales del Compareciente**
  * **II. Examen de Competencia Jurisdiccional**
  * **III. Materia Jurídica Aplicable**
  * **IV. Identificación de Vulnerabilidad Social**
* **Separación de Roles:** Los campos privativos de la Dirección (Vía de Solución y Calificación de Cierre) **no se muestran** al personal de ventanilla para evitar sobrecarga y preservar la reserva institucional.

### C. La Matriz Estadística de 20 Columnas
* Agrupada en 5 bloques cromáticos con doble cabecera:
  1. **Atención General:** Azul cielo suave (`#dbeafe`).
  2. **Materias Jurídicas:** Cian suave (`#e0f2fe`).
  3. **Vulnerabilidades:** Ámbar suave (`#fef3c7`).
  4. **Estados:** Esmeralda suave (`#d1fae5`).
  5. **Vías Dictaminadas:** Violeta / Índigo suave (`#e0e7ff`).
* Fila de **TOTAL ANUAL** al pie: Fondo azul ministerial supremo (`#0c2340`), números luminosos de alto contraste y comprobador de cuadre matemático en tiempo real.

---

## 5. Sistema de Adaptabilidad Móvil y Táctil (Skill Impeccable)

Siguiendo las pautas de `reference/adapt.md` y `reference/craft-floor.md`:

### A. Touch Targets y Ergonomía del Pulgar
* **Área táctil mínima:** $\ge 42-44\,\text{px}$ en todos los botones, selectores y conmutadores.
* **Prevención de Zoom Automático en iOS:** Todos los campos `<input>` y `<select>` cuentan con `text-base sm:text-sm` para impedir el zoom involuntario de Safari en iPhone.
* **Safe-Area Insets:** Soporte completo de márgenes seguros para dispositivos con notch (`viewport-fit=cover`).

### B. Dualidad Arquitectónica: Tablas Clásicas vs. Tarjetas Móviles
* **Escritorio ($\ge 768\,\text{px}$):** Tablas de alta densidad de información para funcionarios que operan en terminales fijos con mouse.
* **Móvil ($< 768\,\text{px}$):** Sustitución por tarjetas contextuales apiladas que desglosan:
  * Número de expediente monoespaciado y fecha.
  * Badge cromático de estado procesal (*Radicado*, *En Trámite*, *Concluido*).
  * Ciudadano, municipio, materia jurídica y responsable asignado.
  * Botones de acción táctiles directos con ancho y altura optimizados (`Gestionar`, `Editar`, `PDF`).

### C. Navegación en la Matriz Estadística de 20 Columnas
* **Columna "Mes" Congelada (`sticky left-0`):** Permite el desplazamiento horizontal fluido conservando en todo momento el mes como ancla visual a la izquierda con sombra sutil de elevación.
* **Tarjetas Resumen de KPIs Ejecutivos:** 4 tarjetas superiores (*Total Atendidos*, *Competentes MINJUS*, *Casos Concluidos*, *Apto para Pago*) que resumen los indicadores provinciales sin forzar scroll en pantallas pequeñas.

