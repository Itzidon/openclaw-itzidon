#!/bin/sh
# list_pending.sh - Muestra proyectos y trabajos pendientes en BreatheCode
# No muestra nunca el valor del token

# Cargar variable de entorno si no está definida
if [ -z "$BREATHECODE_TOKEN" ]; then
  if [ -f /root/.openclaw/.env ]; then
    . /root/.openclaw/.env
  fi
fi

if [ -z "$BREATHECODE_TOKEN" ]; then
  echo "❌ BREATHECODE_TOKEN no está configurada"
  exit 1
fi

echo "📋 Trabajos pendientes en BreatheCode..."
echo

TOKEN_LEN=$(echo "$BREATHECODE_TOKEN" | wc -c)
echo "  Token cargado: ${TOKEN_LEN} caracteres"
echo

# Hacer la petición
RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "Authorization: Token ${BREATHECODE_TOKEN}" \
  -H "Accept: application/json" \
  "https://breathecode.herokuapp.com/v1/assignment/user/me/task?task_status=PENDING" 2>&1)

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

case "$HTTP_CODE" in
  2*)
    echo "✅ Trabajos pendientes recuperados"
    echo
    echo "$BODY" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if not data:
        print('  🎉 No tienes trabajos pendientes. ¡Todo completado!')
        sys.exit(0)

    type_map = {
        'PROJECT': '📦 Proyecto',
        'EXERCISE': '✏️ Ejercicio',
        'LESSON': '📖 Lección',
        'QUIZ': '🧪 Cuestionario',
    }

    # Agrupar por tipo
    groups = {}
    for task in data:
        ttype = task.get('task_type', 'OTROS')
        if ttype not in groups:
            groups[ttype] = []
        groups[ttype].append(task)

    total = len(data)
    print(f'  Total pendientes: {total}')
    print()

    # Ordenar grupos: PROJECT primero, luego EXERCISE, LESSON, QUIZ
    order = ['PROJECT', 'EXERCISE', 'LESSON', 'QUIZ']
    for ttype in order:
        if ttype not in groups:
            continue
        tasks = groups[ttype]
        label = type_map.get(ttype, f'📋 {ttype}')
        print(f'  {label} ({len(tasks)}):')
        for task in tasks:
            title = task.get('title', task.get('name', 'Sin título'))
            created = task.get('created_at', '')[:10]
            cohort_info = task.get('cohort', {})
            cohort_name = cohort_info.get('name', '') if isinstance(cohort_info, dict) else ''
            cohort_str = f' [{cohort_name}]' if cohort_name else ''
            print(f'    • {title}{cohort_str}')
            if created:
                print(f'      Creado: {created}')
        print()

    # Grupos no esperados
    for ttype in groups:
        if ttype not in order:
            tasks = groups[ttype]
            print(f'  📋 {ttype} ({len(tasks)}):')
            for task in tasks:
                title = task.get('title', task.get('name', 'Sin título'))
                print(f'    • {title}')
            print()

except Exception as e:
    print(f'  Error al procesar datos: {e}')
"
    exit 0
    ;;
  401)
    echo "❌ Token inválido o inactivo"
    echo "  La sesión ha expirado o el token no es válido."
    echo
    echo "Respuesta del servidor:"
    echo "$BODY" | head -5
    exit 1
    ;;
  *)
    echo "⚠️ Respuesta inesperada (HTTP $HTTP_CODE)"
    echo
    echo "Respuesta:"
    echo "$BODY" | head -10
    exit 2
    ;;
esac
