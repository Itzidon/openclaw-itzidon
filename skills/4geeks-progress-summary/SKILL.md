---
name: "4geeks-progress-summary"
description: "Muestra una visión general del progreso en BreatheCode (4Geeks Academy): completado vs pendiente"
---

# 4geeks-progress-summary

Muestra una visión general del progreso del estudiante en 4Geeks Academy (BreatheCode): trabajo completado frente a pendiente, desglosado por tipo (proyectos, ejercicios, lecciones, cuestionarios).

## Uso

Ejecuta el script `progress_summary.sh` incluido en la skill.

```sh
bash skills/4geeks-progress-summary/progress_summary.sh
```

## Comportamiento

1. Lee `BREATHECODE_TOKEN` del entorno (primero busca en la variable, después en `/root/.openclaw/.env`)
2. Hace un `GET` a `https://breathecode.herokuapp.com/v1/assignment/user/me/task` con `Authorization: Token <token>` (sin filtro, obtiene todas las tareas)
3. Procesa la respuesta y muestra:
   - Total de trabajos asignados
   - Progreso general: completado vs pendiente (con porcentaje y barra visual)
   - Desglose por tipo (proyectos, ejercicios, lecciones, cuestionarios) con su propio progreso
4. Nunca muestra el valor del token.

## Requisitos

- `BREATHECODE_TOKEN` configurada en `.env` o variable de entorno
- `curl` disponible
- `python3` disponible (para parsear JSON de respuesta)

## Seguridad

- El valor del token nunca se imprime ni se registra.
- El token viaja solo en el header `Authorization`, nunca en la URL.
