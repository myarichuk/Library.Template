$ErrorActionPreference = 'Stop'
& "$PSScriptRoot/tools/dotnet-install.ps1" -channel 6.0
dotnet tool install -g dotnet-format
& "$PSScriptRoot/install-pre-commit.ps1"

