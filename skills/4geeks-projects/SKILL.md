---
name: "4geeks-projects"
description: "Recupera los proyectos asignados al estudiante en BreatheCode y muestra su estado actual"
---

# 4geeks-projects

Recupera los proyectos asignados al estudiante en 4Geeks Academy (BreatheCode) y muestra su estado actual: pendiente, entregado, aprobado o rechazado.

## Uso

Ejecuta el script `list_projects.sh` incluido en la skill.

```sh
bash skills/4geeks-projects/list_projects.sh
```

## Comportamiento

1. Lee `BREATHECODE_TOKEN` del entorno (primero busca en la variable, después en `/root/.openclaw/.env`)
2. Hace un `GET` a `https://breathecode.herokuapp.com/v1/assignment/user/me/task?task_type=PROJECT` con `Authorization: Token <token>`
3. Interpreta la respuesta:
   - **HTTP 2xx** → muestra la lista de proyectos con su estado, tipo, título y fechas.
   - **HTTP 401** → token inválido o inactivo.
   - Otro código → advertencia.
4. Nunca muestra el valor del token.

## Requisitos

- `BREATHECODE_TOKEN` configurada en `.env` o variable de entorno
- `curl` disponible
- `python3` disponible (para parsear JSON de respuesta)

## Seguridad

- El valor del token nunca se imprime ni se registra.
- El token viaja solo en el header `Authorization`, nunca en la URL.
