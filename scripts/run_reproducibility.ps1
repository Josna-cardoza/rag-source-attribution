param(
    [string]$ProjectRoot = (Resolve-Path ".").Path,
    [string]$VenvName = ".venv",
    [string]$PythonExe = "python",
    [switch]$LaunchJupyter,
    [string]$NotebookPath = "main.ipynb"
)

$ErrorActionPreference = "Stop"

function Write-Step($Message) {
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

$VenvPath = Join-Path $ProjectRoot $VenvName
$RequirementsPath = Join-Path $ProjectRoot "scripts\requirements.txt"
$EnvExamplePath = Join-Path $ProjectRoot "scripts\.env.example"
$EnvPath = Join-Path $ProjectRoot ".env"

Write-Step "Checking project root"
if (-not (Test-Path $RequirementsPath)) {
    throw "Cannot find $RequirementsPath. Store the scripts folder inside the project root first."
}

Write-Step "Creating virtual environment"
& $PythonExe -m venv $VenvPath

$ActivateScript = Join-Path $VenvPath "Scripts\Activate.ps1"
if (-not (Test-Path $ActivateScript)) {
    throw "Virtual environment activation script not found at $ActivateScript"
}

. $ActivateScript

Write-Step "Upgrading pip tooling"
python -m pip install --upgrade pip setuptools wheel

Write-Step "Installing reproducibility dependencies"
pip install -r $RequirementsPath

Write-Step "Preparing .env file"
if (-not (Test-Path $EnvPath)) {
    Copy-Item $EnvExamplePath $EnvPath
    Write-Host "Created .env from example. Update it before running Vertex AI calls." -ForegroundColor Yellow
} else {
    Write-Host ".env already exists. Leaving it unchanged." -ForegroundColor Green
}

Write-Step "Verifying core imports"
python -c "import torch, pandas, pyserini, sentence_transformers, vertexai; print('Environment verification passed.')"

if ($LaunchJupyter) {
    Write-Step "Launching Jupyter Lab"
    $NotebookFullPath = Join-Path $ProjectRoot $NotebookPath
    jupyter lab $NotebookFullPath
} else {
    Write-Step "Completed"
    Write-Host "Environment is ready. Activate with: $ActivateScript" -ForegroundColor Green
    Write-Host "Then run: jupyter lab $NotebookPath" -ForegroundColor Green
}
