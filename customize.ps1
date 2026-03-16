param (
    [Parameter(Mandatory=$true)]
    [string]$CompanyName,

    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

$ErrorActionPreference = "Stop"

Write-Host "Customizing repository for $CompanyName / $ProjectName..."

# 1. Rename files and directories
Write-Host "Renaming directories and files..."

# Rename the solution file
if (Test-Path "Library.sln") {
    Rename-Item "Library.sln" "$ProjectName.sln"
}

# Rename the tests directory and project file
if (Test-Path "tests\Library.Tests") {
    Rename-Item "tests\Library.Tests\Library.Tests.csproj" "$ProjectName.Tests.csproj"
    Rename-Item "tests\Library.Tests" "$ProjectName.Tests"
}

# Rename the src directory and project file
if (Test-Path "src\Library") {
    Rename-Item "src\Library\Library.csproj" "$ProjectName.csproj"
    Rename-Item "src\Library" "$ProjectName"
}

# 2. Replace placeholders in files
Write-Host "Replacing placeholders in files..."

# Define files to exclude from replacement
$excludeDirs = @(".git", "bin", "obj", "node_modules")

function Replace-In-Files($SearchText, $ReplaceText) {
    Get-ChildItem -Path . -Recurse -File |
        Where-Object {
            $file = $_
            $include = $true
            foreach ($dir in $excludeDirs) {
                if ($file.FullName -match "\\$dir\\") {
                    $include = $false
                    break
                }
            }
            if ($file.Name -eq "customize.sh" -or $file.Name -eq "customize.ps1") {
                $include = $false
            }
            $include
        } |
        ForEach-Object {
            $content = Get-Content $_.FullName -Raw
            if ($content -match [regex]::Escape($SearchText)) {
                $content = $content -replace [regex]::Escape($SearchText), $ReplaceText
                Set-Content -Path $_.FullName -Value $content -NoNewline
            }
        }
}

# Replace COMPANY-PLACEHOLDER
Replace-In-Files "COMPANY-PLACEHOLDER" $CompanyName

# Replace PROJECT-PLACEHOLDER
Replace-In-Files "PROJECT-PLACEHOLDER" $ProjectName

# Replace Library strings in Solution and Test files manually to avoid unwanted replacements
if (Test-Path "$ProjectName.sln") {
    $slnContent = Get-Content "$ProjectName.sln" -Raw
    $slnContent = $slnContent -replace '"Library"', "`"$ProjectName`""
    $slnContent = $slnContent -replace '"Library.Tests"', "`"$ProjectName.Tests`""
    $slnContent = $slnContent -replace 'src\\Library\\Library.csproj', "src\$ProjectName\$ProjectName.csproj"
    $slnContent = $slnContent -replace 'tests\\Library.Tests\\Library.Tests.csproj', "tests\$ProjectName.Tests\$ProjectName.Tests.csproj"
    Set-Content -Path "$ProjectName.sln" -Value $slnContent -NoNewline
}

if (Test-Path "tests\$ProjectName.Tests\$ProjectName.Tests.csproj") {
    $testProjContent = Get-Content "tests\$ProjectName.Tests\$ProjectName.Tests.csproj" -Raw
    $testProjContent = $testProjContent -replace '../../src/Library/Library.csproj', "../../src/$ProjectName/$ProjectName.csproj"
    Set-Content -Path "tests\$ProjectName.Tests\$ProjectName.Tests.csproj" -Value $testProjContent -NoNewline
}

Write-Host "Customization complete! You can now delete customize.sh and customize.ps1 if you wish."
