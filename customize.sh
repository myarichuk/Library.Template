#!/bin/bash

# Exit on error
set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: ./customize.sh <CompanyName> <ProjectName>"
    echo "Example: ./customize.sh MyCompany MyAwesomeLib"
    exit 1
fi

COMPANY_NAME=$1
PROJECT_NAME=$2

echo "Customizing repository for $COMPANY_NAME / $PROJECT_NAME..."

# 1. Rename files and directories
echo "Renaming directories and files..."

# Rename the solution file
if [ -f "Library.sln" ]; then
    mv "Library.sln" "${PROJECT_NAME}.sln"
fi

# Rename the tests directory and project file
if [ -d "tests/Library.Tests" ]; then
    mv "tests/Library.Tests/Library.Tests.csproj" "tests/Library.Tests/${PROJECT_NAME}.Tests.csproj"
    mv "tests/Library.Tests" "tests/${PROJECT_NAME}.Tests"
fi

# Rename the src directory and project file
if [ -d "src/Library" ]; then
    mv "src/Library/Library.csproj" "src/Library/${PROJECT_NAME}.csproj"
    mv "src/Library" "src/${PROJECT_NAME}"
fi

# 2. Replace placeholders in files
echo "Replacing placeholders in files..."

# Helper function to replace text in files (macOS compatible)
replace_in_files() {
    local search=$1
    local replace=$2
    # Find all files except in .git, bin, obj, and node_modules directories, and replace
    find . -type f -not -path "*/\.git/*" -not -path "*/bin/*" -not -path "*/obj/*" -not -path "*/node_modules/*" -not -name "customize.sh" -not -name "customize.ps1" -print0 | while IFS= read -r -d '' file; do
        if grep -ql "$search" "$file"; then
            # macOS and Linux compatible sed replacement using an intermediate backup file that we immediately delete
            sed -i.bak "s/$search/$replace/g" "$file"
            rm "${file}.bak"
        fi
    done
}

# Replace COMPANY-PLACEHOLDER
replace_in_files "COMPANY-PLACEHOLDER" "$COMPANY_NAME"

# Replace PROJECT-PLACEHOLDER
replace_in_files "PROJECT-PLACEHOLDER" "$PROJECT_NAME"

# Replace Library strings (case-sensitive to avoid breaking other things, but targeting specific known files if needed)
# In solution file
if [ -f "${PROJECT_NAME}.sln" ]; then
    sed -i.bak "s/\"Library\"/\"$PROJECT_NAME\"/g" "${PROJECT_NAME}.sln"
    sed -i.bak "s/\"Library.Tests\"/\"$PROJECT_NAME.Tests\"/g" "${PROJECT_NAME}.sln"
    sed -i.bak "s/src\\\\Library\\\\Library.csproj/src\\\\$PROJECT_NAME\\\\$PROJECT_NAME.csproj/g" "${PROJECT_NAME}.sln"
    sed -i.bak "s/tests\\\\Library.Tests\\\\Library.Tests.csproj/tests\\\\$PROJECT_NAME.Tests\\\\$PROJECT_NAME.Tests.csproj/g" "${PROJECT_NAME}.sln"
    rm "${PROJECT_NAME}.sln.bak"
fi

# In test project
if [ -f "tests/${PROJECT_NAME}.Tests/${PROJECT_NAME}.Tests.csproj" ]; then
    sed -i.bak "s/..\/..\/src\/Library\/Library.csproj/..\/..\/src\/$PROJECT_NAME\/$PROJECT_NAME.csproj/g" "tests/${PROJECT_NAME}.Tests/${PROJECT_NAME}.Tests.csproj"
    rm "tests/${PROJECT_NAME}.Tests/${PROJECT_NAME}.Tests.csproj.bak"
fi

echo "Customization complete! You can now delete customize.sh and customize.ps1 if you wish."
