---
name: "4geeks-auth"
description: "Verifica si el token BREATHECODE_TOKEN es válido y la sesión está activa en BreatheCode (4Geeks Academy)"
---

# 4geeks-auth

Verifica que el token de estudiante de BreatheCode (4Geeks Academy) es válido y que la sesión está activa.

## Uso

Ejecuta el script `verify_auth.sh` incluido en la skill.

```sh
bash skills/4geeks-auth/verify_auth.sh
```

## Comportamiento

1. Lee `BREATHECODE_TOKEN` del entorno (primero busca en la variable, después en `/root/.openclaw/.env`)
2. Hace un `GET` a `https://breathecode.herokuapp.com/v1/admissions/user/me` con `Authorization: Token <token>`
3. Interpreta la respuesta:
   - **HTTP 2xx** → token válido, sesión activa. Muestra nombre, email y academia (datos no sensibles).
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
