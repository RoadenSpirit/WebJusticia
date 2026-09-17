# DOCUMENTO DEFINITIVO: INTERFACES, FLUJO DE CASOS Y MATRIZ ESTADÍSTICA
## SISTEMA "WEB ESTADÍSTICA JUSTICIA" - CAMAGÜEY
**Propósito:** Guía clara, directa y práctica (sin lenguaje rebuscado) para entender el sistema de un solo vistazo.  
**Versión:** 1.0 Definitiva  
**Documento Word Generado:** [`word/Documento_Definitivo_Sistema_Justicia.docx`](./word/Documento_Definitivo_Sistema_Justicia.docx)

---

## 1. LAS 5 INTERFACES A GRANDES RASGOS

El sistema cuenta con 5 pantallas pensadas para que cada funcionario haga su trabajo rápido, sin enredos y sin interferir en las responsabilidades de los demás:

### Pantalla 1: Acceso al Sistema (Login)
* **Qué hace:** Una pantalla limpia donde cada persona pone su usuario y contraseña.
* **La magia detrás:** El sistema sabe de inmediato quién entra y lo manda a su lugar de trabajo:
  - Si es el **operador de ventanilla**, lo envía directo a registrar casos.
  - Si es la **Directora Provincial**, la envía a la bandeja provincial para auditar casos y revisar los balances estadísticos.
  - Si es el **administrador técnico**, solo le permite gestionar contraseñas y copias de seguridad, sin ver datos jurídicos.

### Pantalla 2: Formulario de Registro de Casos (Ventanilla)
* **Qué hace:** Es el formulario que llena el operador mientras el ciudadano está sentado frente a él contándole su situación.
* **Cómo funciona:**
  - Primero se anota el número de caso, la fecha de hoy y el nombre del funcionario que atiende.
  - Luego se redactan los **Fundamentos** (nombre, carnet, dirección, teléfono y el cuento completo de su problema).
  - Tiene un interruptor clave: **"¿Nos compete o no nos compete?"**.
    - Si marca **NO**, el sistema apaga en gris todo lo demás para no perder tiempo.
    - Si marca **SÍ**, se abre la lista para marcar la **Materia** (Civil, Familiar, etc.) y si la persona tiene alguna **Vulnerabilidad** (menor de edad, anciano, etc.).
  - Abajo tiene dos campos con candado visual (*Vía de Solución* y *Estado*). El operador no los puede tocar; le avisan claramente que eso lo decide la Directora.

### Pantalla 3: Mis Expedientes Registrados (Ventanilla)
* **Qué hace:** Es la libreta digital del operador de ventanilla.
* **Cómo funciona:** Ve la relación de los casos que ha atendido hoy o en el mes. Puede pulsar **"Ver Ficha"** para revisar lo que escribió en modo de solo lectura.
* **Seguridad:** Aquí **NO hay botones de editar ni de borrar**. Una vez que el operador le dio a enviar, el caso queda blindado. Si se equivocó en una letra o un número, tiene que avisarle a la Directora para que ella lo rectifique.

### Pantalla 4: Bandeja de Auditoría y Ficha de Dictamen (Dirección Provincial)
* **Qué hace:** Es el panel de control exclusivo de la Directora Provincial. Aquí ve todos los casos de toda la provincia ordenados del más nuevo al más viejo.
* **Semáforo visual:** Usa etiquetas de colores automáticas:
  - 🟡 **Amarillo (`Pendiente`):** Caso nuevo que acaba de enviar ventanilla y espera dictamen.
  - 🟢 **Verde (`Resuelto`):** Caso concluido satisfactoriamente.
  - 🟠 **Naranja (`No Resuelto`):** Caso que quedó trunco o inconcluso.
  - ⚪ **Gris (`No Compete`):** Caso descartado por falta de competencia.
* **La Ficha de Dictamen:** Al pulsar **"Auditar y Dictaminar"**, la Directora lee todo lo que se escribió. Ella sí tiene permiso para corregir cualquier errata. Y es quien decide formalmente:
  1. Por cuál **Vía de Solución** se canaliza el asunto (si va a juicio, a notaría, etc.).
  2. Si el caso queda calificado como **Resuelto** o **No Resuelto**.
  3. Si fuera un caso duplicado o falso, puede pulsar **"Eliminar Expediente"**, pero el sistema le exige escribir el motivo obligatorio para el registro de seguridad.

### Pantalla 5: Panel de la Matriz Estadística Anual (Dirección Provincial)
* **Qué hace:** Es la gran pantalla que sustituye el conteo manual con papel y regla.
* **Cómo funciona:** Muestra una tabla con los 12 meses del año más la fila de Total Acumulado. Tiene 20 columnas bien organizadas por colores. Cada vez que la Directora dictamina un caso o que entra un caso no competente, los números de la tabla se actualizan solos al segundo, sin tener que darle a recalcular ni hacer fórmulas en Excel.

---

## 2. EL VIAJE COMPLETO DE UN CASO Y EL DETALLE DE CADA CAMPO

Vamos a seguir el camino de un caso desde que el ciudadano pisa la oficina hasta que su número queda grabado para siempre en el balance del año:

### Paso 1: La entrada del ciudadano y los datos de cabecera
1. **Campo `no_expediente`:** Identificador único del caso. La recomendación técnica es que el sistema lo ponga solito con formato correlativo (ejemplo: `EXP-2026-0001`, `EXP-2026-0002`) para que nadie repita números por error. Si en la oficina usan un talonario en papel preexistente, se permite teclearlo a mano.
2. **Campo `fecha_atencion`:** Día en que la persona vino a la oficina. El sistema la llena automáticamente con la fecha de hoy, pero permite ajustarla si se están regularizando casos del día anterior.
3. **Campo `responsable`:** Nombre del asesor o funcionario de ventanilla que está escuchando al usuario.
4. **Campo `fundamentos` (¡EL MÁS IMPORTANTE!):** Como en esta primera versión no tenemos 10 casillas separadas para nombre, carnet, calle, etc., aquí el operador escribe todo junto: **Nombre y apellidos del ciudadano, su Carnet de Identidad, de qué municipio viene, su teléfono y el cuento completo de su problema**. Debe quedar bien redactado porque es lo que luego leerá la Directora para tomar decisiones (Regla RN-02).

### Paso 2: El interruptor maestro de Competencia (`es_competente`)
El operador se pregunta: *¿Esto que pide el ciudadano le toca resolverlo a Justicia o es bronca de otra entidad?* Aquí solo hay dos caminos:

> **CAMINO A: MARCÓ "NO COMPETE" (DESCARTE AUTOMÁTICO - RN-01)**  
> Ejemplo típico: Un vecino viene a pedir que metan preso a alguien porque le dio un golpe (eso es penal, le toca a la Policía y Fiscalía, no a Justicia).  
> • El sistema bloquea y apaga en gris las casillas de Materia, Vulnerabilidad y Vía de Solución (les pone valor vacío `NULL`).  
> • El Estado del caso se pone solito en **"No Compete"**.  
> • El operador guarda el caso y queda listo.  
> • **Impacto en los números:** Suma +1 en *Total Casos Atendidos* (porque se le dedicó tiempo al ciudadano), pero **NO** ensucia los números de materias ni de vías.

> **CAMINO B: MARCÓ "SÍ ES COMPETENTE"**  
> El asunto sí es de nuestra competencia (un divorcio, una herencia, un problema con una vivienda o una cooperativa). Al marcar SÍ, la pantalla desbloquea de inmediato las dos listas que vienen a continuación:

### Paso 3: Las dos clasificaciones obligatorias (Materia y Vulnerabilidad)

#### 1. Campo `materia`: Encuadramos el problema en una de 5 ramas del derecho:
* **Civil:** Conflictos de casas, terrenos particulares, herencias, donaciones, préstamos entre particulares y contratos civiles ordinarios.
* **Familiar:** Todo lo que tiene que ver con el Código de las Familias: pensiones de alimentos, divorcios, quién se queda con los niños (guarda y cuidado), régimen para que los abuelos vean a los nietos.
* **Trabajo y Seguridad Social:** Broncas de trabajo, despidos, traslados, gente que reclama sus años de servicio para jubilarse o trámites de pensiones por enfermedad e invalidez.
* **Mercantil:** Asuntos de los nuevos actores económicos: socios de MIPYMES, cooperativas (CNA) y contratos comerciales entre empresas.
* **Administrativo:** Trámites con organismos del Estado: inconformidades con la Dirección Municipal de la Vivienda, licencias de Planificación Física o errores en inscripciones del Registro Civil.

#### 2. Campo `vulnerabilidad`: Se marca si la persona tiene una condición prioritaria (opción única en MVP):
* **`NNA` (Niño, Niña o Adolescente):** Menores de 18 años involucrados directamente (ejemplo: una madre reclamando los alimentos de su hijo).
* **`VVD` (Víctima de Violencia y Discriminación):** Personas que sufren violencia en el hogar, maltrato o discriminación por género o raza.
* **`PAM` (Persona Adulto Mayor):** Abuelos de 60 años o más en situación de indefensión, abandono o pleitos con familiares por su casa.
* **`PSD` (Persona en Situación de Discapacidad):** Personas con limitaciones físicas, de vista, oído o intelectuales que dificultan su defensa.
* **`PJA` (Persona Jurídico Ausente):** Casos donde el dueño del bien o el familiar involucrado está fuera de Cuba o en paradero desconocido y hay que resolver el estatus legal de los bienes o menores que quedaron aquí.

### Paso 4: El botón de enviar y el cerrojo de ventanilla
El operador pulsa **"Guardar y Enviar Expediente"**. Confirma en la ventana emergente y el caso viaja a la bandeja provincial, quedando completamente congelado para el operador (inmutabilidad RN-03).

### Paso 5: La Directora audita, dictamina y cierra el caso
La Directora entra a su bandeja, ve el caso con etiqueta amarilla de *Pendiente* y pulsa **"Auditar y Dictaminar"**:
1. **Rectificación:** Corrige cualquier falta de ortografía o dato mal puesto por ventanilla.
2. **Asigna la `via_solucion` (4 opciones institucionales):**
   - **Proceso Judicial:** Si hay que poner una demanda ante los Tribunales Populares.
   - **Notarial:** Si se resuelve en la Notaría (poderes, testamentos, escrituras).
   - **Administrativo:** Si tiene que ir a resolverlo a la Vivienda, al Carné o al INASS.
   - **Métodos Alternos:** Si se le orienta resolverlo por mediación, conciliación o diálogo entre partes sin ir a juicio.
3. **Califica el `estado_caso` (Cierre definitivo):**
   - **Resuelto:** Si al ciudadano se le dio la orientación completa, se le aclaró el camino legal y el trámite quedó satisfecho al 100%.
   - **No Resuelto:** Si la persona no volvió a traer los papeles, si no compareció o si el caso quedó trunco esperando un informe externo.
4. **Al pulsar "Guardar":** El caso queda formalmente cerrado y sus números impactan en vivo en la Matriz Estadística.

---

## 3. CÓMO SE VE LA TABLA ESTADÍSTICA (EJEMPLO REAL Y LEYENDA)

### Tabla de Ejemplo: Balance Mensual y Acumulado (20 Columnas)

| Mes | Total Atendidos | Comp. | Civil | Fam. | Trab. | Merc. | Adm. | NNA | VVD | PAM | PSD | PJA | Resuel. | No Res. | No Comp. | Judicial | Notarial | Admin. | M. Alt. |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Enero** | **120** | **95** | 30 | 40 | 12 | 5 | 8 | 25 | 15 | 35 | 12 | 8 | 80 | 15 | **25** | 45 | 30 | 12 | 8 |
| **Febrero** | **110** | **88** | 28 | 38 | 10 | 4 | 8 | 22 | 14 | 32 | 12 | 8 | 75 | 13 | **22** | 42 | 28 | 10 | 8 |
| **...** | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... |
| **Diciembre** | **130** | **105** | 35 | 45 | 12 | 5 | 8 | 30 | 18 | 38 | 11 | 8 | 90 | 15 | **25** | 50 | 32 | 15 | 8 |
| **TOTAL ANUAL** | **1,450** | **1,150** | **365** | **485** | **135** | **55** | **110** | **300** | **190** | **420** | **140** | **100** | **980** | **170** | **300** | **545** | **365** | **145** | **95** |

---

### Leyenda Explicativa: Qué significa cada una de las 20 Columnas

#### 🔷 BLOQUE 1: VOLUMEN GENERAL (Columnas 1 y 2)
* **Col 1 (`Total Casos Atendidos`):** Cuenta a todas las personas que fueron atendidas físicamente en la oficina en el mes, sin importar si su caso era nuestro o no. Cada expediente creado suma +1 aquí.
* **Col 2 (`Total Competentes`):** De todos los que vinieron, cuántos casos sí eran competencia legal de la Dirección Provincial de Justicia. Es la suma exacta de las 5 materias.

#### 🔶 BLOQUE 2: DESGLOSE POR MATERIAS - SOLO COMPETENTES (Columnas 3 a 7)
*(La suma de estas 5 columnas tiene que dar exactamente igual a la Columna 2 - Total Competentes)*
* **Col 3 (`Civil`):** Asuntos de vivienda particular, terrenos, contratos civiles, herencias y posesión.
* **Col 4 (`Familiar`):** Asuntos del Código de las Familias (alimentos, divorcios, comunicación y guarda/cuidado).
* **Col 5 (`Trabajo y Seg. Social`):** Conflictos de trabajo, jubilaciones ante el INASS y subsidios.
* **Col 6 (`Mercantil`):** Trámites de MIPYMES, cooperativas CNA y contratos comerciales.
* **Col 7 (`Administrativo`):** Trámites de Vivienda, Carné de Identidad y Planificación Física.

#### 🔴 BLOQUE 3: VULNERABILIDAD SOCIAL DETECTADA (Columnas 8 a 12)
*(Muestra cuántas personas con situación de vulnerabilidad fueron atendidas entre los casos competentes)*
* **Col 8 (`NNA`):** Menores de 18 años cuyos derechos están en juego.
* **Col 9 (`VVD`):** Víctimas de violencia intrafamiliar, maltrato o discriminación.
* **Col 10 (`PAM`):** Adultos mayores de 60 años en situación de indefensión o desamparo.
* **Col 11 (`PSD`):** Personas en situación de discapacidad física, sensorial o mental.
* **Col 12 (`PJA`):** Personas fuera de Cuba o con paradero desconocido con bienes o menores aquí.

#### 🟢 BLOQUE 4: ESTADO DE RESOLUCIÓN (Columnas 13 a 15)
*(Indica cómo terminó la atención brindada a los ciudadanos)*
* **Col 13 (`Resueltos`):** Casos donde el ciudadano recibió la respuesta completa y se fue con la solución o el trámite encauzado.
* **Col 14 (`No Resueltos`):** Casos que quedaron truncos porque la persona no volvió con las pruebas o falta un informe externo.
* **Col 15 (`No Compete`):** Casos que se descartaron de inmediato en ventanilla porque el tema no era de Justicia.

#### 🟣 BLOQUE 5: VÍAS DE SOLUCIÓN DICTAMINADAS POR LA DIRECTORA (Columnas 16 a 19)
*(Por qué camino institucional mandó la Directora a resolver los casos competentes)*
* **Col 16 (`Proceso Judicial`):** Se orientó poner demanda ante los Tribunales Populares.
* **Col 17 (`Notarial`):** Se orientó acudir a la Notaría (poderes, testamentos, escrituras).
* **Col 18 (`Administrativo`):** Se canalizó hacia la Vivienda, Carné, INASS u organismo de gobierno.
* **Col 19 (`Métodos Alternos`):** Se orientó resolver por mediación, conciliación o diálogo sin juicio.

---

### 💡 El "Truco del Cuadre" (Cómo saber que los números están perfectos)
Para que la Directora tenga la tranquilidad absoluta de que los informes que eleva a instancias superiores no tienen ni un solo descuadre, el sistema verifica internamente estas dos cuentas sencillas:

1. **Cuadre de Entrada:**
   $$\text{Total Atendidos (Col 1)} = \text{Total Competentes (Col 2)} + \text{No Compete (Col 15)}$$
   *(Todo ciudadano que entró por la puerta o era competencia de Justicia o no lo era).*

2. **Cuadre de Salida:**
   $$\text{Total Atendidos (Col 1)} = \text{Resueltos (Col 13)} + \text{No Resueltos (Col 14)} + \text{No Compete (Col 15)}$$
   *(Toda persona atendida tiene que haber terminado obligatoriamente en una de esas tres situaciones).*
