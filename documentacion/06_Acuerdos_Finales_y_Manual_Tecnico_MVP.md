# MANUAL TÉCNICO Y ACUERDOS DEFINITIVOS DE IMPLEMENTACIÓN
## SISTEMA DE ASESORÍA JURÍDICA Y ESTADÍSTICA PROVINCIAL ("WEB ESTADÍSTICA JUSTICIA")
**Cliente:** Dirección Provincial de Justicia de Camagüey  
**Fecha de Consolidación:** Septiembre de 2026  
**Versión:** 2.0 (Post-Reunión y Fase de Pruebas con BD Espejo)  
**Clasificación:** Documento Oficial de Arquitectura y Reglas de Negocio  

---

## 1. INTRODUCCIÓN Y ACTUALIZACIONES DE NEGOCIO
Tras la reunión de trabajo con la Dirección Provincial de Justicia y la sesión de refinamiento técnico, se acordó la evolución del modelo operativo del sistema respecto a los borradores preliminares.

### Principales Decisiones Incorporadas:
1. **Atribución Estricta del Funcionario Responsable:**
   - El personal de ventanilla (operador) **no puede asignar especialista**. El campo fue removido del formulario de radicación.
   - La **Directora Provincial** es la única facultada para analizar el caso, evaluar la complejidad jurídica y designar al asesor responsable.
2. **Nuevo Modelo Procesal de Estados:**
   - 🟡 **`Radicado`:** Expediente generado en ventanilla, a la espera de revisión por la Dirección.
   - 🔵 **`En Trámite`:** Caso revisado y con especialista asesor asignado por la Directora.
   - 🟢 **`Concluido`:** Expediente cerrado oficialmente tras registrarse la nota de conclusión del especialista o secretaría.
   - ⚪ **`No Compete`:** Cierre automático y descarte por falta de jurisdicción del Ministerio de Justicia.
3. **Condición Financiera Exclusiva ("Apto para Pago"):**
   - Durante la fase `En Trámite` y antes del cierre, la Directora determina si el trámite aplica cobro arancelario o si goza de exención/gratuidad. Este control es invisible e inaccesible para los operadores de ventanilla.
4. **Gama Cromática Institucional para Lectura Rápida en Dirección:**
   - La bandeja provincial implementa un semáforo visual de alto contraste:
     - Ámbar (`#d97706` / `bg-amber-50`): Atención prioritaria inmediata (casos pendientes de asignación).
     - Azul ministerial (`#0284c7` / `bg-sky-50`): Trámite activo con asesor.
     - Verde esmeralda (`#059669` / `bg-emerald-50`): Trámite cerrado con éxito.
     - Gris neutro (`#64748b` / `bg-slate-100`): Asuntos descartados por falta de competencia.
     - Sello heráldico dorado: Distintivo de expedientes calificados como **Apto para Pago**.
5. **Orden Cronológico Descendente:**
   - Todos los listados ordenan los casos con los más recientes arriba (`fecha_atencion DESC, id DESC`).
6. **Datos Estructurados del Compareciente:**
   - Nombre y Apellidos, Carnet de Identidad (flexible, sin bloqueo rígido para extranjeros o indocumentados), Dirección Particular, Municipio de Residencia y Teléfono de Contacto.
7. **Vulnerabilidades Múltiples:**
   - Casillas de verificación independiente (`NNA`, `VVD`, `PAM`, `PSD`, `PJA`), computando cada marca en su columna de la Matriz.
8. **Trazabilidad y Edición Compartida:**
   - Ambos perfiles pueden rectificar errores fácticos. El sistema genera una bitácora inmutable: fecha/hora, usuario y diferencias de valores anteriores y nuevos.
9. **Papelera de Desechados (Soft Delete):**
   - Ningún expediente se borra físicamente. La Directora tiene acceso a la papelera dentro de **Ajustes de Dirección** y puede restaurar cualquier caso.
10. **Ajustes de Dirección y Gestión de Usuarios:**
    - Panel para crear y administrar operadores con roles `Directora` o `Personal` con contraseñas encriptadas con `bcrypt`.

---

## 2. ARQUITECTURA TÉCNICA Y PERSISTENCIA

```
[ Navegador Web ] (Astro Frontend)
       │
       ▼ (HTTPS / JSON REST API)
[ Hostinger Web Server ]
  ├── api/db.php           (Conexión PDO SQLite, tablas y modo WAL)
  ├── api/auth.php         (Autenticación con contraseñas bcrypt)
  ├── api/expedientes.php  (CRUD, asignación, pago, conclusión y trazas)
  ├── api/usuarios.php     (Alta, listado y baja de cuentas institucionales)
  ├── api/pdf.php          (Generador de Ficha Oficial individual imprimible)
  ├── api/seed.php         (Poblador de base de datos espejo con 30 casos)
  └── api/data/justicia.db (Archivo SQLite protegido con .htaccess)
```

---

## 3. CATÁLOGO DE LA BASE DE DATOS ESPEJO (30 CASOS DE PRUEBA)
El archivo `api/seed.php` contiene 30 comparecencias reales modeladas para los 13 municipios de Camagüey distribuidas a lo largo de 2026:
- **Casos Concluidos (Enero - Mayo):** Herencias notariales, alimentos, divorcios, litigios MIPYME, mediaciones cooperativas.
- **Casos En Trámite (Junio - Agosto):** Viviendas con ausentes (PJA), reclamaciones laborales OJL, uniones de hecho, peritajes notariales a domicilio.
- **Casos Radicados (Septiembre):** Casos recientes en bandeja de entrada esperando asignación de responsable por la Directora.
- **Casos No Compete:** Conflictos vecinales de orden público (PNR), multas contravencionales (DIS), aranceles aduanales (Aduana).
- **Casos en Papelera:** 2 expedientes de prueba desechados para validar el flujo de restauración de la Directora.
