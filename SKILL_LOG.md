# 📋 SKILL_LOG — Registro de skills creadas

---

## Configuración inicial

- Se confirmó que la instancia de OpenClaw estaba activa y que era posible mantener una conversación con el agente Kai.
- Se obtuvo el token de estudiante de 4Geeks/BreatheCode.
- El token se almacenó de forma segura como variable de entorno `BREATHECODE_TOKEN` en `/root/.openclaw/.env`.
- El valor real del token no se incluyó en ninguna skill ni se subió al repositorio de GitHub.

---

## Conversación de descubrimiento

La integración con 4Geeks se inició mediante una conversación con OpenClaw.

### Solicitud inicial

> "Quiero darte la habilidad de conectarte a mi cuenta de 4Geeks usando mi token de estudiante, sin que tenga que desarrollar código de mi parte. ¿Qué debemos hacer?"

### Qué sugirió OpenClaw

OpenClaw propuso utilizar el token de estudiante para autenticarse contra la Student API de BreatheCode y mantener la credencial fuera de los archivos de las skills.

Durante la conversación se consultó la referencia oficial de la Student API para identificar los endpoints y el formato correcto de autenticación.

### Información necesaria

Para realizar la integración fue necesario:

- disponer del token de estudiante;
- almacenarlo de forma segura como `BREATHECODE_TOKEN`;
- consultar la referencia oficial de endpoints de BreatheCode;
- comprobar que la autenticación funcionaba antes de construir las siguientes skills.

A partir de esta conversación se creó la primera skill, `4geeks-auth`, y posteriormente las demás capacidades se fueron construyendo una a una mediante nuevas conversaciones con OpenClaw.

### Resultado del descubrimiento

Se decidió construir capacidades independientes, manteniendo una única responsabilidad por skill y utilizando únicamente los endpoints necesarios de la Student API de BreatheCode.

---

## Skill 1 — 4geeks-auth

### 🗓️ Fecha de creación

1 de septiembre de 2026

---

### 💬 Prompt inicial

> *"Kai, el token de 4Geeks ya está guardado como variable de entorno BREATHECODE_TOKEN. No muestres nunca su valor. Quiero empezar la Skill 1 — Autenticar: debe verificar contra BreatheCode que el token es válido y que mi sesión está activa. Ayúdame a construirla a través de esta conversación y dime qué endpoint vamos a usar."*

---

### 📝 Descripción

Skill con una única responsabilidad: **verificar si el token de estudiante de BreatheCode (4Geeks Academy) es válido y la sesión está activa**.

---

### 🔗 Endpoint utilizado

| Elemento | Valor |
|---|---|
| **Método HTTP** | `GET` |
| **URL completa** | `https://breathecode.herokuapp.com/v1/admissions/user/me` |
| **Fuente** | [Referencia oficial Student API](https://breathecode.herokuapp.com/asset/internal-link?id=3613&path=content/projects/openclaw-integration/STUDENT_API_CALLS_REFERENCE.es.md) |

---

### 🔐 Autenticación

- **Header:** `Authorization: Token <valor-del-token>`
- **Variable segura:** `BREATHECODE_TOKEN` (almacenada en `/root/.openclaw/.env`, nunca se muestra su valor)
- El token se lee desde la variable de entorno y se usa exclusivamente en el header HTTP; no se imprime, registra ni expone en ningún momento.

---

### 📂 Archivos creados

```
skills/4geeks-auth/SKILL.md
skills/4geeks-auth/scripts/verify_auth.sh
```

---

### ✅ Resultado de la prueba

```
🔐 Verificando autenticación en BreatheCode...

  Token cargado: 41 caracteres

✅ Autenticación válida — sesión activa

Datos del usuario recuperados correctamente.
```

**Conclusión:** el token es válido y la sesión está activa. No se mostró el valor del token en ningún paso de la prueba.

---

### 🧠 Criterios de validación

| Respuesta HTTP | Significado |
|---|---|
| **2xx** | Token válido, sesión activa. Los datos del usuario se recuperan correctamente sin exponer información personal. |
| **401** | Token inválido o inactivo. Se informa del error. |
| Otro código | Respuesta inesperada. Se muestra una advertencia. |

---

## Skill 2 — 4geeks-projects

### 🗓️ Fecha de creación

1 de septiembre de 2026

---

### 💬 Prompt inicial

> *"Quiero construir la Skill 2 — 4geeks-projects. Su única responsabilidad debe ser recuperar mis proyectos asignados en 4Geeks y mostrar su estado actual (por ejemplo: pendiente, entregado o calificado). Usa la referencia oficial de Student API de BreatheCode para identificar el endpoint correcto. Debe usar BREATHECODE_TOKEN desde el entorno, sin mostrar nunca el token. Construye la skill mediante esta conversación, pruébala con mi cuenta y, si funciona, actualiza también SKILL_LOG.md con el prompt, la responsabilidad, el endpoint usado y el resultado de la prueba."*

---

### 📝 Descripción

Skill con una única responsabilidad: **recuperar los proyectos asignados al estudiante en BreatheCode (4Geeks Academy) y mostrar su estado actual**. Los estados se muestran como Pendiente (⏳), Entregado (✅), Aprobado (🌟) o Rechazado (❌).

---

### 🔗 Endpoint utilizado

| Elemento | Valor |
|---|---|
| **Método HTTP** | `GET` |
| **URL completa** | `https://breathecode.herokuapp.com/v1/assignment/user/me/task?task_type=PROJECT` |
| **Fuente** | [Referencia oficial Student API](https://breathecode.herokuapp.com/asset/internal-link?id=3613&path=content/projects/openclaw-integration/STUDENT_API_CALLS_REFERENCE.es.md) — sección *Assignments* / *Listar mis tareas* |

---

### 🔐 Autenticación

- **Header:** `Authorization: Token <valor-del-token>`
- **Variable segura:** `BREATHECODE_TOKEN` (almacenada en `/root/.openclaw/.env`, nunca se muestra su valor)

---

### 📂 Archivos creados

```
skills/4geeks-projects/SKILL.md
skills/4geeks-projects/scripts/list_projects.sh
```

---

### ✅ Resultado de la prueba

Con 58 proyectos recuperados correctamente:

```
📋 Recuperando proyectos asignados en BreatheCode...

  Token cargado: 41 caracteres

✅ Proyectos recuperados

  Total: 58 proyectos

  📦 Proyecto: Todo List CLI with Python
    Estado: ⏳ Pendiente
    Creado: 2026-08-10

  📦 Proyecto: Command Line Challenge
    Estado: ✅ Entregado
    Creado: 2026-04-11
    Actualizado: 2026-04-15
  ...
```

Proyectos con estados variados: ⏳ Pendiente y ✅ Entregado. No se mostró el valor del token en ningún paso.

**Conclusión:** la skill funciona correctamente. Recupera todos los proyectos del estudiante filtrados por `task_type=PROJECT` y muestra su estado actual junto con las fechas relevantes.

---

## Skill 3 — 4geeks-pending-work

### 🗓️ Fecha de creación

1 de septiembre de 2026

---

### 💬 Prompt inicial

> *"Quiero construir la Skill 3 — 4geeks-pending-work. Su única responsabilidad debe ser decirme específicamente qué proyectos o trabajos me faltan por completar en 4Geeks. Usa la referencia oficial de Student API de BreatheCode para identificar el endpoint correcto. Debe usar BREATHECODE_TOKEN desde el entorno, sin mostrar nunca el token. Construye la skill mediante esta conversación, pruébala con mi cuenta y, si funciona, actualiza SKILL_LOG.md con el prompt inicial, la responsabilidad única, el endpoint usado y el resultado real de la prueba."*

---

### 📝 Descripción

Skill con una única responsabilidad: **mostrar específicamente qué proyectos y trabajos le faltan por completar al estudiante en BreatheCode (4Geeks Academy)**. Los resultados se agrupan por tipo (proyectos, ejercicios, lecciones, cuestionarios) y cada elemento incluye su cohorte de origen.

---

### 🔗 Endpoint utilizado

| Elemento | Valor |
|---|---|
| **Método HTTP** | `GET` |
| **URL completa** | `https://breathecode.herokuapp.com/v1/assignment/user/me/task?task_status=PENDING` |
| **Fuente** | [Referencia oficial Student API](https://breathecode.herokuapp.com/asset/internal-link?id=3613&path=content/projects/openclaw-integration/STUDENT_API_CALLS_REFERENCE.es.md) — sección *Assignments* / *Listar mis tareas* |

---

### 🔐 Autenticación

- **Header:** `Authorization: Token <valor-del-token>`
- **Variable segura:** `BREATHECODE_TOKEN` (almacenada en `/root/.openclaw/.env`, nunca se muestra su valor)

---

### 📂 Archivos creados

```
skills/4geeks-pending-work/SKILL.md
skills/4geeks-pending-work/scripts/list_pending.sh
```

---

### ✅ Resultado de la prueba

```
📋 Trabajos pendientes en BreatheCode...

  Token cargado: 41 caracteres

✅ Trabajos pendientes recuperados

  Total pendientes: 237

  📦 Proyecto (40):
    • Todo List CLI with Python [spain-aie-pt-4]
    • Final Project User Stories & Wireframes [Spain FS PT General]
    • Enhacing development with agent skills - Financial dashboard [Working with AI coding agents]
    • Milestone 4 — AI-driven Engineering [Working with AI coding agents]
    • ...

  ✏️ Ejercicio (154):
    • Master Python by practice (interactive) [spain-aie-pt-4]
    • Restructuring OpenClaw's Memory [Advanced personal assistants with Openclaw]
    • AI Engineering Fundamentals: Introduction to AI-Assisted Development [Working with AI coding agents]
    • ...

  📖 Lección (42):
    • Working with Lists in Python [spain-aie-pt-4]
    • Learning to program with Python [spain-aie-pt-4]
    • ...

  🧪 Cuestionario (1):
    • Learn about CSS [Introduction to Software Development]
```

**Conclusión:** 237 trabajos pendientes recuperados y agrupados: 40 proyectos, 154 ejercicios, 42 lecciones y 1 cuestionario. No se mostró el valor del token en ningún paso.

---

## Skill 4 — 4geeks-progress-summary

### 🗓️ Fecha de creación

1 de septiembre de 2026

---

### 💬 Prompt inicial

> *"Quiero construir la Skill 4 — 4geeks-progress-summary. Su única responsabilidad debe ser darme una visión general de cuánto he avanzado en mi formación de 4Geeks: trabajo completado frente a pendiente y cualquier dato de progreso que permita la Student API oficial. Usa la referencia oficial de BreatheCode para elegir el endpoint adecuado. Debe usar BREATHECODE_TOKEN desde el entorno y nunca mostrar el token. Construye la skill mediante esta conversación, pruébala con mi cuenta y, si funciona, actualiza SKILL_LOG.md con el prompt inicial, responsabilidad única, endpoint usado y resultado real de la prueba."*

---

### 📝 Descripción

Skill con una única responsabilidad: **mostrar una visión general del progreso del estudiante en BreatheCode (4Geeks Academy)**, con trabajo completado frente a pendiente y desglose por tipo (proyectos, ejercicios, lecciones, cuestionarios), incluyendo porcentajes y barra visual de progreso.

---

### 🔗 Endpoint utilizado

| Elemento | Valor |
|---|---|
| **Método HTTP** | `GET` |
| **URL completa** | `https://breathecode.herokuapp.com/v1/assignment/user/me/task` |
| **Fuente** | [Referencia oficial Student API](https://breathecode.herokuapp.com/asset/internal-link?id=3613&path=content/projects/openclaw-integration/STUDENT_API_CALLS_REFERENCE.es.md) — sección *Assignments* / *Listar mis tareas* |

---

### 🔐 Autenticación

- **Header:** `Authorization: Token <valor-del-token>`
- **Variable segura:** `BREATHECODE_TOKEN` (almacenada en `/root/.openclaw/.env`, nunca se muestra su valor)

---

### 📂 Archivos creados

```
skills/4geeks-progress-summary/SKILL.md
skills/4geeks-progress-summary/scripts/progress_summary.sh
```

---

### ✅ Resultado de la prueba

```
📊 Resumen de progreso en BreatheCode...

  Token cargado: 41 caracteres

✅ Datos de progreso recuperados

  ========================================
  📊  PROGRESO GENERAL
  ========================================

  Total asignados: 340
  ✅ Completados:   103
  ⏳ Pendientes:    237
  Progreso:        ██████░░░░░░░░░░░░░░ 30%

  ========================================
  📋  DESGLOSE POR TIPO
  ========================================

  📦 Proyectos
    Total: 58 | ✅ 18 | ⏳ 40
    Progreso: ██████░░░░░░░░░░░░░░ 31%

  ✏️ Ejercicios
    Total: 219 | ✅ 65 | ⏳ 154
    Progreso: ██████░░░░░░░░░░░░░░ 30%

  📖 Lecciones
    Total: 61 | ✅ 19 | ⏳ 42
    Progreso: ██████░░░░░░░░░░░░░░ 31%

  🧪 Cuestionarios
    Total: 2 | ✅ 1 | ⏳ 1
    Progreso: ██████████░░░░░░░░░░ 50%
```

**Conclusión:** progreso general del 30% (103 completados de 340). Desglose: proyectos 31%, ejercicios 30%, lecciones 31%, cuestionarios 50%. No se mostró el valor del token en ningún paso.

---

## Skill 5 — 4geeks-cohorts

### 🗓️ Fecha de creación

1 de septiembre de 2026

---

### 💬 Prompt inicial

> *"Elijo 4geeks-cohorts y 4geeks-certificates como las 2 skills extendidas. Empecemos por 4geeks-cohorts. Su única responsabilidad será consultar mis cohortes activas y pasadas usando el endpoint oficial que has identificado. Usa BREATHECODE_TOKEN desde el entorno, nunca muestres el token, construye la skill mediante esta conversación, pruébala con mi cuenta y actualiza SKILL_LOG.md con el prompt, responsabilidad única, endpoint usado y resultado real de la prueba."*

---

### 📝 Descripción

Skill con una única responsabilidad: **consultar los cohortes del estudiante en BreatheCode (4Geeks Academy) y mostrarlos agrupados por estado educativo** (ACTIVO, GRADUADO, SUSPENDIDO, BAJA), con nombre, slug, rol, fechas de inicio y fin.

**Necesidad identificada:** quería poder consultar desde Kai en qué cohortes estoy o he estado sin tener que entrar manualmente en 4Geeks.

---

### 🔗 Endpoint utilizado

| Elemento | Valor |
|---|---|
| **Método HTTP** | `GET` |
| **URL completa** | `https://breathecode.herokuapp.com/v1/admissions/user/me` |
| **Fuente** | [Referencia oficial Student API](https://breathecode.herokuapp.com/asset/internal-link?id=3613&path=content/projects/openclaw-integration/STUDENT_API_CALLS_REFERENCE.es.md) — sección *Admissions* / *Usuario actual*. Los cohortes se obtienen del campo `cohorts` incluido en el perfil del usuario. |

---

### 🔐 Autenticación

- **Header:** `Authorization: Token <valor-del-token>`
- **Variable segura:** `BREATHECODE_TOKEN` (almacenada en `/root/.openclaw/.env`, nunca se muestra su valor)

---

### 📂 Archivos creados

```
skills/4geeks-cohorts/SKILL.md
skills/4geeks-cohorts/scripts/list_cohorts.sh
```

---

### ✅ Resultado de la prueba

```
🎓 Cohortes en BreatheCode...

  Token cargado: 41 caracteres

✅ Cohortes recuperados

  Total de cohortes: 30

  🟢 Activo (27):
    📚 Authentication in web applications
      Slug: autentication-in-web-applications
      Rol: Estudiante
      Inicio: 2026-05-06

    📚 spain-aie-pt-4
      Slug: spain-aie-pt-4
      Rol: Estudiante
      Inicio: 2026-07-13
      Fin: 2027-01-13
    ...

  🎓 Graduado (1):
    📚 Personal assistants with Openclaw
      Rol: Estudiante
      Inicio: 2026-05-15

  ❓ NOT_COMPLETED (1):
    📚 Coding Fundamentals with Typescript

  ❓ POSTPONED (1):
    📚 spain-aie-pt-1
```

**Conclusión:** 30 cohortes recuperados: 27 activos, 1 graduado, 1 no completado, 1 pospuesto. Incluye el cohorte principal `spain-aie-pt-4` con fechas definidas (julio 2026 — enero 2027). No se mostró el valor del token en ningún paso.

---

## Skill 6 — 4geeks-search-content

### 🗓️ Fecha de creación

1 de septiembre de 2026

---

### 💬 Prompt inicial

> *"Elijo la opción A. Sustituye definitivamente 4geeks-activity por una Skill 6 llamada 4geeks-search-content. Su única responsabilidad será buscar contenido educativo de 4Geeks (proyectos, ejercicios o lecciones) usando el endpoint oficial GET /v1/registry/asset, permitiendo buscar por texto y, cuando sea posible, filtrar por tecnología o dificultad. Usa la referencia oficial para los parámetros correctos. Construye la skill mediante esta conversación, pruébala con una búsqueda real, por ejemplo \"Python\", y actualiza SKILL_LOG.md con el prompt inicial, responsabilidad única, endpoint, archivos creados y resultado real. Deja 4geeks-activity y 4geeks-certificates claramente descartadas y no las cuentes entre las 6 skills finales."*

---

### 📝 Descripción

Skill con una única responsabilidad: **buscar contenido educativo en el catálogo de 4Geeks Academy (BreatheCode)**, filtrando por tipo de asset (proyectos, ejercicios, lecciones), texto, tecnología y dificultad. Muestra título, slug, tipo, dificultad, tecnologías y descripción de cada resultado.

**Necesidad identificada:** quería poder buscar desde Kai material de estudio de 4Geeks por tecnología, dificultad o texto.

---

### 🔗 Endpoint utilizado

| Elemento | Valor |
|---|---|
| **Método HTTP** | `GET` |
| **URL completa** | `https://breathecode.herokuapp.com/v1/registry/asset` |
| **Parámetros query** | `asset_type`, `technologies`, `difficulty`, `like`, `limit` |
| **Fuente** | [Referencia oficial Student API](https://breathecode.herokuapp.com/asset/internal-link?id=3613&path=content/projects/openclaw-integration/STUDENT_API_CALLS_REFERENCE.es.md) — sección *Registry* / *Buscar assets* |

---

### 🔐 Autenticación

- **Header:** `Authorization: Token <valor-del-token>`
- **Variable segura:** `BREATHECODE_TOKEN` (almacenada en `/root/.openclaw/.env`, nunca se muestra su valor)

---

### 📂 Archivos creados

```
skills/4geeks-search-content/SKILL.md
skills/4geeks-search-content/scripts/search_content.sh
```

---

### 🎛️ Filtros disponibles

| Flag | Descripción |
|---|---|
| `--text` / `-t` | Búsqueda por texto libre |
| `--type` | Tipo de asset: PROJECT, EXERCISE, LESSON |
| `--tech` / `--technology` | Tecnología (slug, ej. python, react) |
| `--difficulty` / `-d` | Dificultad: BEGINNER, EASY, INTERMEDIATE, HARD |
| `--limit` / `-l` | Resultados máximos (default 15) |

**Sin parámetros:** busca proyectos Python nivel principiante por defecto.

---

### ✅ Resultado de la prueba

Busqueda por defecto (proyectos Python principiante):

```
🔍 Buscando contenido en BreatheCode...

  Token cargado: 41 caracteres

  Filtros:
    Tipo: PROJECT
    Tecnología: python
    Dificultad: BEGINNER
    Límite: 15

  Total encontrados: 58
  Mostrando: 15

  📦 Nombre del Criminal - Búsqueda y Decodificación
      Slug: nombre-del-criminal-busqueda-y-decodificacion
      Tipo: PROJECT | Dificultad: 🌟 Principiante
      Tecnologías: python, blue-team, osint, base64, ...

  📦 Proyecto SQL: Detectives de Datos del Instituto Global de la Vida
      Slug: proyecto-sql-detectives-de-datos-del-instituto-global-de-la-vida
      Tipo: PROJECT | Dificultad: 🌟 Principiante
      Tecnologías: python, machine-learning, databases, ...

  📦 Analizador de Ventas Mensuales
      Slug: analizador-de-ventas-mensuales
      Tipo: PROJECT | Dificultad: 🌟 Principiante
      Tecnologías: python, data-analysis
  ...
```

**Conclusión:** 58 proyectos Python nivel principiante encontrados. La skill permite búsqueda por texto, tipo, tecnología y dificultad. No se mostró el valor del token en ningún paso.

---

## 🗑️ Skills descartadas (no cuentan entre las 6 finales)

### 4geeks-certificates (intentada y descartada)

- **Endpoint:** `GET /v1/certificate/`
- **Motivo:** Endpoint requiere el permiso `read_certificate`, no disponible para el rol de estudiante. Responde con HTTP 403.

### 4geeks-activity (intentada y descartada)

- **Endpoint:** `GET /v1/activity/me`
- **Motivo:** Endpoint requiere el permiso `read_activity`, no disponible para el rol de estudiante. Responde con HTTP 403.
