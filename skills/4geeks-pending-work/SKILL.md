---
name: "4geeks-pending-work"
description: "Muestra los proyectos y trabajos pendientes de completar en BreatheCode (4Geeks Academy)"
---

# 4geeks-pending-work

Muestra específicamente qué proyectos y trabajos le faltan por completar al estudiante en 4Geeks Academy (BreatheCode).

## Uso

Ejecuta el script `list_pending.sh` incluido en la skill.

```sh
bash skills/4geeks-pending-work/list_pending.sh
```

## Comportamiento

1. Lee `BREATHECODE_TOKEN` del entorno (primero busca en la variable, después en `/root/.openclaw/.env`)
2. Hace un `GET` a `https://breathecode.herokuapp.com/v1/assignment/user/me/task?task_status=PENDING` con `Authorization: Token <token>`
3. Interpreta la respuesta:
   - **HTTP 2xx** → muestra la lista de proyectos y trabajos pendientes, agrupados por tipo (proyectos, ejercicios, lecciones).
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
