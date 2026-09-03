#!/bin/sh
# progress_summary.sh - Visión general del progreso en BreatheCode
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

echo "📊 Resumen de progreso en BreatheCode..."
echo

TOKEN_LEN=$(echo "$BREATHECODE_TOKEN" | wc -c)
echo "  Token cargado: ${TOKEN_LEN} caracteres"
echo

# Guardar respuesta en archivo temporal
TMPFILE=$(mktemp /tmp/breathecode_progress_XXXXXX.json)
trap "rm -f $TMPFILE" EXIT

curl -s -o "$TMPFILE" -w "%{http_code}" \
  -H "Authorization: Token ${BREATHECODE_TOKEN}" \
  -H "Accept: application/json" \
  "https://breathecode.herokuapp.com/v1/assignment/user/me/task" > /tmp/breathecode_progress_code.txt 2>&1

HTTP_CODE=$(cat /tmp/breathecode_progress_code.txt)

case "$HTTP_CODE" in
  2*)
    echo "✅ Datos de progreso recuperados"
    echo
    python3 -c "
import json
from collections import defaultdict

with open('$TMPFILE') as f:
    data = json.load(f)

if not data:
    print('  No hay trabajos asignados.')
    exit(0)

type_map = {
    'PROJECT': 'Proyectos',
    'EXERCISE': 'Ejercicios',
    'LESSON': 'Lecciones',
    'QUIZ': 'Cuestionarios',
}
emoji_map = {
    'PROJECT': '📦',
    'EXERCISE': '✏️',
    'LESSON': '📖',
    'QUIZ': '🧪',
}
order = ['PROJECT', 'EXERCISE', 'LESSON', 'QUIZ']
done_statuses = {'DONE', 'APPROVED'}
sep = '=' * 40

total = len(data)
done = sum(1 for t in data if t.get('task_status') in done_statuses)
pending = total - done
pct = round(done / total * 100) if total > 0 else 0
bar_len = 20
filled = round(pct / 100 * bar_len)
bar = chr(9608) * filled + chr(9617) * (bar_len - filled)

print('  ' + sep)
print('  \U0001f4ca  PROGRESO GENERAL')
print('  ' + sep)
print()
print('  Total asignados: ' + str(total))
print('  \u2705 Completados:   ' + str(done))
print('  \u23f3 Pendientes:    ' + str(pending))
print('  Progreso:        ' + bar + ' ' + str(pct) + '%')
print()

print('  ' + sep)
print('  \U0001f4cb  DESGLOSE POR TIPO')
print('  ' + sep)
print()

by_type_status = defaultdict(lambda: {'total': 0, 'done': 0})

for task in data:
    ttype = task.get('task_type', 'OTROS')
    by_type_status[ttype]['total'] += 1
    if task.get('task_status') in done_statuses:
        by_type_status[ttype]['done'] += 1

for ttype in order:
    if ttype not in by_type_status:
        continue
    info = by_type_status[ttype]
    t = info['total']
    d = info['done']
    p = t - d
    pct_t = round(d / t * 100) if t > 0 else 0
    filled_t = round(pct_t / 100 * bar_len)
    bar_t = chr(9608) * filled_t + chr(9617) * (bar_len - filled_t)
    emoji = emoji_map.get(ttype, '\U0001f4cb')
    label = type_map.get(ttype, ttype)
    print('  ' + emoji + ' ' + label)
    print('    Total: ' + str(t) + ' | \u2705 ' + str(d) + ' | \u23f3 ' + str(p))
    print('    Progreso: ' + bar_t + ' ' + str(pct_t) + '%')
    print()
"
    exit 0
    ;;
  401)
    echo "❌ Token inválido o inactivo"
    echo "  La sesión ha expirado o el token no es válido."
    echo
    echo "Respuesta del servidor:"
    head -5 "$TMPFILE"
    exit 1
    ;;
  *)
    echo "⚠️ Respuesta inesperada (HTTP $HTTP_CODE)"
    echo
    echo "Respuesta:"
    head -10 "$TMPFILE"
    exit 2
    ;;
esac