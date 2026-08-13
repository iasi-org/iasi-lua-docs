#!/usr/bin/env bash

set -euo pipefail

# Keep the standard Git Bash tools available when invoked from Windows hosts.
export PATH="/usr/bin:/bin:$PATH"

repository_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
pages_root="$repository_root/_pages"

rm -rf -- "$pages_root"
mkdir -p -- "$pages_root"

publications=()

while IFS= read -r -d '' index_file; do
  publish_dir="$(dirname -- "$index_file")"
  project_dir="$(dirname -- "$publish_dir")"
  relative_project="${project_dir#"$repository_root"/}"

  case "/$relative_project/" in
    */tests/*) continue ;;
  esac

  destination="$pages_root/$relative_project"
  mkdir -p -- "$destination"
  cp -a -- "$publish_dir/." "$destination/"
  publications+=("$relative_project")
done < <(
  find "$repository_root" \
    -path "$repository_root/.git" -prune -o \
    -path "$pages_root" -prune -o \
    -type f -path '*/publish/index.html' -print0 \
    | sort -z
)

if [ "${#publications[@]}" -eq 0 ]; then
  printf 'No se encontraron publicaciones */publish/index.html.\n' >&2
  exit 1
fi

{
  cat <<'EOF'
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>IASI Lua Documentation</title>
</head>
<body>
  <main>
    <h1>IASI Lua Documentation</h1>
    <ul>
EOF

  for publication in "${publications[@]}"; do
    label="$(basename -- "$publication")"
    printf '      <li><a href="%s/">%s</a></li>\n' "$publication" "$label"
  done

  cat <<'EOF'
    </ul>
  </main>
</body>
</html>
EOF
} > "$pages_root/index.html"

touch "$pages_root/.nojekyll"

printf 'Publicaciones ensambladas: %d\n' "${#publications[@]}"
