---
name: diario-aprendizaje
description: Convierte lo aprendido por Itziar en una entrada estructurada de diario y la guarda en Google Docs usando las herramientas conectadas.
user-invocable: true
---

name: diario-aprendizaje
description: Convierte lo aprendido por Itziar en una entrada estructurada de diario y la guarda en Google Docs usando las herramientas conectadas.
user-invocable: true
---

# Diario de aprendizaje

Usa esta skill cuando Itziar quiera registrar lo que ha aprendido durante una sesión de estudio.

## Objetivo

Transformar apuntes breves o ideas sueltas sobre programación, Inteligencia Artificial u otros temas de estudio en una entrada clara, útil y fácil de revisar posteriormente.

## Contexto

Ten en cuenta USER.md, SOUL.md, AGENTS.md y TOOLS.md.

Itziar está aprendiendo programación e Ingeniería de IA y prefiere explicaciones claras, prácticas y paso a paso.

No inventes conceptos que Itziar no haya mencionado.

## Input esperado

Itziar puede proporcionar información en lenguaje natural, por ejemplo:

- conceptos que ha aprendido;
- ejercicios realizados;
- errores que ha entendido;
- dudas que todavía tiene;
- tecnologías utilizadas.

No exijas un formato rígido.

Si falta información secundaria, organiza únicamente lo disponible.

## Flujo de trabajo

1. Lee el input de Itziar.
2. Identifica los temas principales.
3. Convierte las notas en explicaciones breves y claras.
4. Separa lo aprendido de las dudas pendientes.
5. Propón un siguiente paso práctico relacionado con lo aprendido.
6. Usa Google Docs mediante la conexión actual de Composio para guardar la entrada.
7. No configures nuevas APIs, conexiones OAuth ni servicios externos.
8. Después de crear o actualizar el documento, verifica que la operación haya tenido éxito.
9. Informa a Itziar del resultado real.
10. Si la herramienta falla, dilo claramente y no simules que el documento fue creado.

## Formato del contenido

La entrada debe seguir esta estructura:

# Diario de aprendizaje — [fecha]

## Qué he aprendido

- Tema o concepto.
- Explicación sencilla.
- Ejemplo cuando ayude a entenderlo.

## Qué he practicado

Lista breve de ejercicios, proyectos o acciones realizadas.

## Dudas pendientes

Lista de dudas reales proporcionadas por Itziar o detectadas claramente a partir de su input.

No inventes dudas.

## Siguiente paso recomendado

Una acción concreta y manejable para continuar aprendiendo.

## Destino

Guardar el resultado en Google Docs utilizando únicamente las herramientas que ya están conectadas.

Si ya existe un documento de diario claramente identificado y accesible, actualízalo.

Si no existe un documento claramente identificable, crea uno con este nombre:

Diario de aprendizaje de Itziar

## Estilo

- Claro.
- Práctico.
- Directo.
- Fácil de revisar.
- Explicar los conceptos técnicos en lenguaje sencillo.
- Sin lenguaje técnico innecesario.
- Sin relleno ni elogios genéricos.
- Dividir conceptos complicados en pasos pequeños.