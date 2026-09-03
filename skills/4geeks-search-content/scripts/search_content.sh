#!/bin/sh
# search_content.sh - Busca contenido educativo en 4Geeks (BreatheCode)
# No muestra nunca el valor del token

# Valores por defecto
TEXT=""
ASSET_TYPE=""
TECH=""
DIFFICULTY=""
LIMIT=15

# Procesar argumentos
while [ $# -gt 0 ]; do
  case "$1" in
    --text|-t) TEXT="$2"; shift 2 ;;
    --type) ASSET_TYPE="$2"; shift 2 ;;
    --tech|--technology) TECH="$2"; shift 2 ;;
    --difficulty|-d) DIFFICULTY="$2"; shift 2 ;;
    --limit|-l) LIMIT="$2"; shift 2 ;;
    --help|-h)
      echo "Uso: bash search_content.sh [opciones]"
      echo ""
      echo "Opciones:"
      echo "  --text <texto>       Texto de búsqueda"
      echo "  --type <tipo>        Tipo: PROJECT, EXERCISE, LESSON"
      echo "  --tech <slug>        Tecnología: python, react, javascript, etc."
      echo "  --difficulty <nivel>  Dificultad: BEGINNER, EASY, INTERMEDIATE, HARD"
      echo "  --limit <n>          Resultados máximos (default 15)"
      echo "  --help               Esta ayuda"
      echo ""
      echo "Ejemplos:"
      echo "  bash search_content.sh                              # Proyectos Python BEGINNER"
      echo "  bash search_content.sh --text react --limit 5       # Busca react"
      echo "  bash search_content.sh --type EXERCISE --tech python --difficulty INTERMEDIATE"
      exit 0
      ;;
    *) echo "Opción desconocida: $1 (usa --help)"; exit 1 ;;
  esac
done

# Cargar token
if [ -z "$BREATHECODE_TOKEN" ]; then
  if [ -f /root/.openclaw/.env ]; then
    . /root/.openclaw/.env
  fi
fi

if [ -z "$BREATHECODE_TOKEN" ]; then
  echo "❌ BREATHECODE_TOKEN no está configurada"
  exit 1
fi

echo "🔍 Buscando contenido en BreatheCode..."
echo

TOKEN_LEN=$(echo "$BREATHECODE_TOKEN" | wc -c)
echo "  Token cargado: ${TOKEN_LEN} caracteres"
echo

# Construir URL con parámetros
BASE_URL="https://breathecode.herokuapp.com/v1/registry/asset"
PARAMS="limit=${LIMIT}"

if [ -n "$ASSET_TYPE" ]; then
  PARAMS="${PARAMS}&asset_type=${ASSET_TYPE}"
fi
if [ -n "$TECH" ]; then
  PARAMS="${PARAMS}&technologies=${TECH}"
fi
if [ -n "$DIFFICULTY" ]; then
  PARAMS="${PARAMS}&difficulty=${DIFFICULTY}"
fi
if [ -n "$TEXT" ]; then
  PARAMS="${PARAMS}&like=${TEXT}"
fi

# Sin filtros → búsqueda por defecto: proyectos Python BEGINNER
if [ -z "$ASSET_TYPE" ] && [ -z "$TECH" ] && [ -z "$DIFFICULTY" ] && [ -z "$TEXT" ]; then
  ASSET_TYPE="PROJECT"
  TECH="python"
  DIFFICULTY="BEGINNER"
  PARAMS="asset_type=PROJECT&technologies=python&difficulty=BEGINNER&limit=${LIMIT}"
fi

URL="${BASE_URL}?${PARAMS}"

# Mostrar filtros aplicados
echo "  Filtros:"
[ -n "$TEXT" ] && echo "    Texto: $TEXT"
[ -n "$ASSET_TYPE" ] && echo "    Tipo: $ASSET_TYPE"
[ -n "$TECH" ] && echo "    Tecnología: $TECH"
[ -n "$DIFFICULTY" ] && echo "    Dificultad: $DIFFICULTY"
echo "    Límite: $LIMIT"
echo

# Hacer la petición
TMPFILE=$(mktemp /tmp/breathecode_search_XXXXXX.json)
trap "rm -f $TMPFILE" EXIT

curl -s -o "$TMPFILE" -w "%{http_code}" \
  -H "Authorization: Token ${BREATHECODE_TOKEN}" \
  -H "Accept: application/json" \
  "$URL" > /tmp/breathecode_search_code.txt 2>&1

HTTP_CODE=$(cat /tmp/breathecode_search_code.txt)

case "$HTTP_CODE" in
  2*)
    python3 -c "
import json

with open('$TMPFILE') as f:
    data = json.load(f)

results = data.get('results', data) if isinstance(data, dict) else data
if isinstance(results, list):
    pass
else:
    results = []

count = data.get('count', len(results)) if isinstance(data, dict) else len(results)

if not results:
    print('  No se encontraron resultados.')
    exit(0)

type_icons = {'PROJECT': '📦', 'EXERCISE': '✏️', 'LESSON': '📖', 'QUIZ': '🧪'}
diff_labels = {'BEGINNER': '🌟 Principiante', 'EASY': '👍 Fácil', 'INTERMEDIATE': '🔥 Intermedio', 'HARD': '💀 Difícil'}

print('  Total encontrados: ' + str(count))
print('  Mostrando: ' + str(len(results)))
print()

for asset in results:
    title = asset.get('title', 'Sin título')
    slug = asset.get('slug', '')
    atype = asset.get('asset_type', '')
    icon = type_icons.get(atype, '📋')
    diff = asset.get('difficulty', '')
    diff_str = diff_labels.get(diff, diff)
    techs = asset.get('technologies', [])
    tech_names = []
    if isinstance(techs, list):
        tech_names = [t.get('title', t.get('slug', str(t))) if isinstance(t, dict) else str(t) for t in techs]
    desc = asset.get('description', '') or ''
    lang = asset.get('lang', '')

    print('  ' + icon + ' ' + title)
    print('      Slug: ' + slug)
    print('      Tipo: ' + atype + ' | Dificultad: ' + diff_str)
    if tech_names:
        print('      Tecnologías: ' + ', '.join(tech_names))
    if desc:
        print('      ' + desc[:120])
    print()
"
    exit 0
    ;;
  401)
    echo "❌ Token inválido o inactivo"
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