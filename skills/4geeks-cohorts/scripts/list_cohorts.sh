#!/bin/sh
# list_cohorts.sh - Muestra cohortes del estudiante en BreatheCode
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

echo "🎓 Cohortes en BreatheCode..."
echo

TOKEN_LEN=$(echo "$BREATHECODE_TOKEN" | wc -c)
echo "  Token cargado: ${TOKEN_LEN} caracteres"
echo

# Guardar respuesta en archivo temporal
TMPFILE=$(mktemp /tmp/breathecode_cohorts_XXXXXX.json)
trap "rm -f $TMPFILE" EXIT

curl -s -o "$TMPFILE" -w "%{http_code}" \
  -H "Authorization: Token ${BREATHECODE_TOKEN}" \
  -H "Accept: application/json" \
  "https://breathecode.herokuapp.com/v1/admissions/user/me" > /tmp/breathecode_cohorts_code.txt 2>&1

HTTP_CODE=$(cat /tmp/breathecode_cohorts_code.txt)

case "$HTTP_CODE" in
  2*)
    echo "✅ Cohortes recuperados"
    echo
    python3 -c "
import json
from collections import defaultdict

with open('$TMPFILE') as f:
    data = json.load(f)

cohorts = data.get('cohorts', [])

if not cohorts:
    print('  No hay cohortes registrados.')
    exit(0)

status_map = {
    'ACTIVE': '🟢 Activo',
    'GRADUATED': '🎓 Graduado',
    'SUSPENDED': '⏸️ Suspendido',
    'DROPPED': '🚫 Baja',
}

role_map = {
    'STUDENT': 'Estudiante',
    'TEACHER': 'Profesor',
    'ASSISTANT': 'Asistente',
    'ADMIN': 'Admin',
}

# Agrupar por educational_status
groups = defaultdict(list)
for entry in cohorts:
    status = entry.get('educational_status', 'UNKNOWN')
    groups[status].append(entry)

order = ['ACTIVE', 'GRADUATED', 'SUSPENDED', 'DROPPED']

total = len(cohorts)
print('  Total de cohortes: ' + str(total))
print()

for status in order:
    if status not in groups:
        continue
    entries = groups[status]
    label = status_map.get(status, '❓ ' + status)
    print('  ' + label + ' (' + str(len(entries)) + '):')
    print()
    for entry in entries:
        cohort = entry.get('cohort', {})
        if not isinstance(cohort, dict):
            cohort = {}
        name = cohort.get('name', 'Sin nombre')
        slug = cohort.get('slug', '')
        kickoff = (cohort.get('kickoff_date') or '')[:10]
        ending = (cohort.get('ending_date') or '')[:10]
        role = role_map.get(entry.get('role', ''), entry.get('role', ''))
        created = entry.get('created_at', '')[:10]

        print('    📚 ' + name)
        if slug:
            print('      Slug: ' + slug)
        if role:
            print('      Rol: ' + role)
        if kickoff:
            print('      Inicio: ' + kickoff)
        if ending:
            print('      Fin: ' + ending)
        print()

# Estados no esperados
for status in groups:
    if status not in order:
        entries = groups[status]
        print('  ❓ ' + status + ' (' + str(len(entries)) + '):')
        for entry in entries:
            cohort = entry.get('cohort', {})
            if not isinstance(cohort, dict):
                cohort = {}
            print('    📚 ' + cohort.get('name', 'Sin nombre'))
        print()
"
    exit 0
    ;;
  401)
    echo "❌ Token inválido o inactivo"
    echo "  La sesión ha expirado o el token no es válido."
    echo
    head -5 "$TMPFILE"
    exit 1
    ;;
  *)
    echo "⚠️ Respuesta inesperada (HTTP $HTTP_CODE)"
    echo
    head -10 "$TMPFILE"
    exit 2
    ;;
esac