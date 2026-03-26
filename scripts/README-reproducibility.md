# Reproducibility Setup for the Thesis RAG Project

This bundle gives you two reproducibility paths:

1. **Docker** — best for thesis submission and long-term reproducibility.
2. **PowerShell** — best for your current Windows development workflow.

## Recommended project layout

Store the files like this in the project root:

```text
project-root/
  main.ipynb
  evaluation_queries.json
  final_evaluation_report.csv
  data/
    arxiv/
    processed/
  models/
    aar_trained_model/
  scripts/
    Dockerfile
    requirements-repro.txt
    .env.example
    run_in_docker.sh
    run_reproducibility.ps1
    README-reproducibility.md
```

If you already have `data/`, `models/`, and `results/`, keep those in the project root and only add the new `scripts/` folder.

## Why I recommend Docker first

Your notebook combines Python packages, Java-backed retrieval tooling, and Vertex AI access. Pyserini depends on Java and currently documents Java 21, while Google recommends isolated environments and Application Default Credentials for Vertex AI authentication. Docker gives you the cleanest way to lock all of that down across machines.

## Option A — Docker

### 1) Put credentials in a safe local folder

Do **not** commit credentials to Git.
Create a local folder outside Git tracking, for example:

```text
project-root/
  creds/
    service-account.json
```

### 2) Copy the environment template

Create a `.env` file in the project root by copying `scripts/.env.example`, then update these values:

- `PROJECT_ROOT`
- `GCP_PROJECT_ID`
- `GCP_LOCATION`
- `GOOGLE_APPLICATION_CREDENTIALS`

For Docker, a practical value is:

```text
GOOGLE_APPLICATION_CREDENTIALS=/workspace/creds/service-account.json
```

### 3) Build the image from the project root

```powershell
docker build -f scripts/Dockerfile -t thesis-rag-repro .
```

### 4) Run the container

```powershell
docker run --rm -it `
  -p 8888:8888 `
  --env-file .env `
  -v "${PWD}:/workspace" `
  thesis-rag-repro
```

This mounts your whole project into `/workspace` and starts Jupyter Lab.

### 5) Open Jupyter

Open:

```text
http://localhost:8888/lab
```

## Option B — PowerShell on Windows

This is the best option when you want a local reproducible setup without containers.

### 1) Open PowerShell in the project root

### 2) Allow local script execution for the current session if needed

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

### 3) Run the setup script

```powershell
.\scripts\run_reproducibility.ps1
```

### 4) Or run it and immediately open the notebook

```powershell
.\scripts\run_reproducibility.ps1 -LaunchJupyter
```

This script will:
- create `.venv`
- install the pinned dependencies
- create `.env` from the template if it does not exist
- verify critical imports
- optionally launch Jupyter Lab

## Notes you should apply in your notebook

For stronger reproducibility, make these small notebook changes:

1. Replace hard-coded paths like `D:\dev_repo` with an environment-based root.
2. Load the project id and location from `.env`.
3. Avoid interactive `gcloud auth application-default login` inside the notebook; use ADC from the service account instead.

A clean pattern is:

```python
import os
from dotenv import load_dotenv

load_dotenv()
base_dir = os.getenv("PROJECT_ROOT", os.getcwd())
project_id = os.getenv("GCP_PROJECT_ID")
location = os.getenv("GCP_LOCATION", "us-central1")
```

## Suggested Git ignore entries

Add these to `.gitignore` if they are not already there:

```text
.venv/
.env
creds/
__pycache__/
.ipynb_checkpoints/
results/
```

## Best practice for thesis submission

For the dissertation appendix and repository, include:
- the `scripts/` folder
- a short setup section in the repository README
- a sample `.env.example`
- exact commands for both Docker and PowerShell

That is enough for a reviewer to recreate the environment with much less ambiguity.
