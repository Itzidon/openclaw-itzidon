# 4geeks-search-content

Busca contenido educativo en el catálogo de 4Geeks Academy (BreatheCode): proyectos, ejercicios o lecciones, filtrando por texto, tecnología o dificultad.

## Uso

```sh
# Búsqueda básica por texto
bash skills/4geeks-search-content/search_content.sh

# Búsqueda con filtros
bash skills/4geeks-search-content/search_content.sh --type PROJECT --tech python --difficulty BEGINNER --limit 10
```

## Parámetros

| Flag | Descripción | Valores |
|---|---|---|
| `--text` o `-t` | Texto de búsqueda | cualquier texto |
| `--type` | Tipo de asset | `PROJECT`, `EXERCISE`, `LESSON` |
| `--tech` o `--technology` | Tecnología (slug) | `python`, `react`, `javascript`, etc. |
| `--difficulty` o `-d` | Dificultad | `BEGINNER`, `EASY`, `INTERMEDIATE`, `HARD` |
| `--limit` o `-l` | Resultados máximos | número (default 15) |
| `--help` | Muestra ayuda | |

**Sin parámetros:** busca proyectos Python nivel BEGINNER como ejemplo por defecto.

## Endpoint

- **Método:** `GET`
- **URL:** `https://breathecode.herokuapp.com/v1/registry/asset`
- **Autenticación:** `Authorization: Token <token>`

## Seguridad

- El valor del token nunca se imprime ni se registra.
