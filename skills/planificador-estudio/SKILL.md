---
name: planificador-estudio
description: Convierte los objetivos y disponibilidad de Itziar en un plan de estudio práctico y crea los bloques acordados en Google Calendar usando las herramientas ya conectadas.
user-invocable: true
---

# Planificador de estudio

Usa esta skill cuando Itziar quiera organizar sus sesiones de estudio, repartir tareas o reservar tiempo para avanzar en programación e Inteligencia Artificial.

## Objetivo

Transformar objetivos de estudio y disponibilidad en un plan concreto, priorizado y manejable.

Cuando la fecha y la hora estén suficientemente claras, utilizar Google Calendar mediante la conexión existente para crear los bloques de estudio acordados.

## Contexto

Ten en cuenta USER.md, SOUL.md, AGENTS.md y TOOLS.md.

Itziar está estudiando programación e Ingeniería de IA.

Prefiere:

- trabajar paso a paso;
- entender antes de avanzar;
- dividir tareas grandes en partes pequeñas;
- tener claro cuál es el siguiente paso;
- evitar planes excesivamente complicados.

La zona horaria es Europe/Madrid.

## Input esperado

Itziar puede proporcionar en lenguaje natural:

- qué quiere estudiar;
- ejercicios o proyectos que quiere terminar;
- días disponibles;
- horas disponibles;
- prioridades;
- fechas límite.

No exijas un formato rígido.

## Antes de crear eventos

Comprueba que estén claros:

- el día;
- la hora de inicio;
- la duración;
- el objetivo de la sesión.

Si falta un dato importante o existe una ambigüedad que pueda cambiar el evento, pregunta antes de crearlo.

Si Itziar únicamente pide un plan y no pide crear eventos, prepara el plan sin modificar Google Calendar.

## Flujo de trabajo

1. Identifica todos los objetivos de estudio.
2. Ordénalos por prioridad.
3. Divide los objetivos grandes en tareas manejables.
4. Estima una duración razonable para cada sesión.
5. Comprueba la disponibilidad proporcionada.
6. Cuando sea posible, consulta Google Calendar para evitar conflictos.
7. Presenta un plan claro.
8. Si Itziar ha pedido crear los bloques y la información es suficiente, usa Google Calendar mediante la conexión actual.
9. No configures nuevas APIs, OAuth ni servicios externos.
10. Verifica que los eventos se hayan creado correctamente.
11. Informa del resultado real. Si una operación falla, dilo claramente.

## Formato del plan

# Plan de estudio

## Objetivo principal

Una frase clara indicando qué se pretende conseguir.

## Prioridades

1. Prioridad más importante.
2. Segunda prioridad.
3. Otras tareas si son necesarias.

## Sesiones

Para cada sesión indicar:

- Día:
- Hora:
- Duración:
- Objetivo:
- Tarea concreta:
- Resultado esperado:

## Siguiente paso

Indicar la primera acción concreta que Itziar debe realizar.

## Google Calendar

Cuando se creen eventos, utiliza títulos descriptivos como:

Estudio — React: useState y useEffect

o:

Estudio — Proyecto OpenClaw Skills

Evita títulos vagos como "Estudiar".

No crees eventos duplicados si ya existe uno equivalente.

## Estilo

- Claro.
- Directo.
- Práctico.
- Realista.
- Sin sobrecargar el calendario.
- Dividir las tareas complicadas en pasos pequeños.