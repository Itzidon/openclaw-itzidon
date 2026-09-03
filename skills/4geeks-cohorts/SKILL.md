---
name: "4geeks-cohorts"
description: "Muestra los cohortes del estudiante en BreatheCode (4Geeks Academy): activos, graduados, etc."
---

# 4geeks-cohorts

Muestra los cohortes en los que el estudiante está o ha estado inscrito en 4Geeks Academy (BreatheCode): activos, graduados, suspendidos o dados de baja, con su rol, horario y fechas.

## Uso

Ejecuta el script `list_cohorts.sh` incluido en la skill.

```sh
bash skills/4geeks-cohorts/list_cohorts.sh
```

## Comportamiento

1. Lee `BREATHECODE_TOKEN` del entorno (primero busca en la variable, después en `/root/.openclaw/.env`)
2. Hace un `GET` a `https://breathecode.herokuapp.com/v1/admissions/academy/cohort/me` con `Authorization: Token <token>`
3. Interpreta la respuesta:
   - **HTTP 2xx** → muestra la lista de cohortes agrupados por estado educativo (ACTIVE, GRADUATED, SUSPENDED, DROPPED), con nombre, slug, rol, horario y fechas.
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
