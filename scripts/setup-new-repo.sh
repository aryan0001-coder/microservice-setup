#!/bin/bash

# Interactive script to remove original contributor and set up for your GitHub

echo "=========================================="
echo "  Remove Contributor & Setup New Repo"
echo "=========================================="
echo ""

# Get user information
read -p "Enter your name: " YOUR_NAME
read -p "Enter your GitHub username: " YOUR_GITHUB
read -p "Enter your email: " YOUR_EMAIL
read -p "Enter current year (default: $(date +%Y)): " YEAR
YEAR=${YEAR:-$(date +%Y)}

echo ""
echo "Updating files with:"
echo "  Name: $YOUR_NAME"
echo "  GitHub: $YOUR_GITHUB"
echo "  Email: $YOUR_EMAIL"
echo "  Year: $YEAR"
echo ""

read -p "Continue? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "Cancelled."
    exit 1
fi

echo ""
echo "Updating files..."

# Function to update package.json
update_package_json() {
    local file=$1
    echo "  → $file"
    sed -i "s|\"url\": \"git+ssh://git@github.com:benjsicam/nestjs-rest-microservices.git\"|\"url\": \"git+https://github.com/${YOUR_GITHUB}/nestjs-rest-microservices.git\"|g" "$file"
    sed -i "s|\"author\": \"Benj Sicam\"|\"author\": \"${YOUR_NAME}\"|g" "$file"
    sed -i "s|https://github.com/benjsicam/nestjs-rest-microservices|https://github.com/${YOUR_GITHUB}/nestjs-rest-microservices|g" "$file"
}

# Update all package.json files
update_package_json "package.json"
update_package_json "api-gateway/package.json"
update_package_json "microservices/comments-svc/package.json"
update_package_json "microservices/organizations-svc/package.json"
update_package_json "microservices/users-svc/package.json"

# Update LICENSE
echo "  → LICENSE"
sed -i "s|Copyright (c) 2020 Benj Sicam|Copyright (c) ${YEAR} ${YOUR_NAME}|g" LICENSE

# Update README.md
echo "  → README.md"
sed -i "s|https://raw.githubusercontent.com/benjsicam/nestjs-rest-microservices/master/|https://raw.githubusercontent.com/${YOUR_GITHUB}/nestjs-rest-microservices/master/|g" README.md

echo ""
echo "✅ All files updated!"
echo ""
echo "Next steps:"
echo "1. Review changes: git diff"
echo ""
echo "2. Remove git history (optional - starts fresh):"
echo "   rm -rf .git && git init"
echo ""
echo "3. Set up new repository:"
echo "   git add ."
echo "   git commit -m 'Initial commit'"
echo "   git branch -M main"
echo "   git remote add origin https://github.com/${YOUR_GITHUB}/nestjs-rest-microservices.git"
echo "   git push -u origin main"
echo ""
echo "4. Or keep history but change author (see REMOVE_CONTRIBUTOR_GUIDE.md)"
echo ""
