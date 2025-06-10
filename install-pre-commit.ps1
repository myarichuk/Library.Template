$ErrorActionPreference = 'Stop'
if (Get-Command pre-commit -ErrorAction SilentlyContinue) {
    pre-commit --version > $null
} else {
    choco install -y python git
    pip install virtualenv==20.0.33
    pip install pre-commit
}

pre-commit install
pre-commit install --hook-type commit-msg
pre-commit run --all-files

