#!/bin/sh
# list_projects.sh - Lista proyectos asignados en BreatheCode
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

echo "📋 Recuperando proyectos asignados en BreatheCode..."
echo

export TOKEN_LEN=$(echo "$BREATHECODE_TOKEN" | wc -c)
echo "  Token cargado: ${TOKEN_LEN} caracteres"
echo

# Hacer la petición
RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "Authorization: Token ${BREATHECODE_TOKEN}" \
  -H "Accept: application/json" \
  "https://breathecode.herokuapp.com/v1/assignment/user/me/task?task_type=PROJECT" 2>&1)

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

case "$HTTP_CODE" in
  2*)
    echo "✅ Proyectos recuperados"
    echo
    echo "$BODY" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if not data:
        print('  No hay proyectos asignados.')
        sys.exit(0)
    
    # Estado según task_status
    status_map = {
        'PENDING': '⏳ Pendiente',
        'DONE': '✅ Entregado',
        'APPROVED': '🌟 Aprobado',
        'REJECTED': '❌ Rechazado',
    }
    
    # Tipo según task_type
    type_map = {
        'PROJECT': '📦 Proyecto',
        'EXERCISE': '✏️ Ejercicio',
        'LESSON': '📖 Lección',
        'QUIZ': '🧪 Cuestionario',
    }
    
    print(f'  Total: {len(data)} proyectos')
    print()
    
    for task in data:
        title = task.get('title', task.get('name', 'Sin título'))
        task_type = task.get('task_type', '')
        status = task.get('task_status', 'UNKNOWN')
        status_str = status_map.get(status, f'❓ {status}')
        type_str = type_map.get(task_type, f'📋 {task_type}')
        
        created = task.get('created_at', '')[:10]
        updated = task.get('updated_at', '')[:10]
        
        print(f'  {type_str}: {title}')
        print(f'    Estado: {status_str}')
        if created:
            print(f'    Creado: {created}')
        if updated and updated != created:
            print(f'    Actualizado: {updated}')
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
