#!/bin/sh
# verify_auth.sh - Verifica token de estudiante BreatheCode
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

echo "🔐 Verificando autenticación en BreatheCode..."
echo

export TOKEN_LEN=$(echo "$BREATHECODE_TOKEN" | wc -c)
echo "  Token cargado: ${TOKEN_LEN} caracteres"
echo

# Hacer la petición
RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "Authorization: Token ${BREATHECODE_TOKEN}" \
  -H "Accept: application/json" \
  "https://breathecode.herokuapp.com/v1/admissions/user/me" 2>&1)

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

case "$HTTP_CODE" in
  2*)
    echo "✅ Autenticación válida — sesión activa"
    echo
    echo "Datos del usuario:"
    echo "$BODY" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    first = data.get('first_name', '')
    last = data.get('last_name', '')
    email = data.get('email', '')
    print(f'  Nombre: {first} {last}')
    print(f'  Email: {email}')
    profile = data.get('profile_academy', [])
    if profile:
        pa = profile[0]
        acad = pa.get('academy', {})
        print(f'  Academia: {acad.get(\"name\", \"\")} ({acad.get(\"slug\", \"\")})')
except Exception as e:
    print(f'  (no se pudieron extraer datos: {e})')
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
