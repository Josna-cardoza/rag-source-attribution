#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-/workspace}"
NOTEBOOK_PATH="${NOTEBOOK_PATH:-${PROJECT_ROOT}/main.ipynb}"
PORT="${JUPYTER_PORT:-8888}"

cd "$PROJECT_ROOT"

python -m ipykernel install --user --name thesis-repro --display-name "Python (thesis-repro)" >/dev/null 2>&1 || true

printf "\n[INFO] Project root: %s\n" "$PROJECT_ROOT"
printf "[INFO] Notebook path: %s\n" "$NOTEBOOK_PATH"
printf "[INFO] Starting Jupyter Lab on port %s\n\n" "$PORT"

exec jupyter lab \
  --ip=0.0.0.0 \
  --port="$PORT" \
  --no-browser \
  --allow-root \
  --NotebookApp.token='' \
  --NotebookApp.password='' \
  "$NOTEBOOK_PATH"
