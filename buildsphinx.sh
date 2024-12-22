#!/usr/bin/env bash

set -euo pipefail

project_root=$(realpath "$(dirname "$0")")
temp_folder="$project_root/.ignore-me-fabric-tmp"
dest_folder="$project_root/src/content/docs/api/"
# fabric_repo_url="https://github.com/Fabric-Development/fabric"

# temporary until it's merged
fabric_repo_url="https://github.com/its-darsh/fabric"
default_branch="sphinx"

log() {
    echo -e "\033[1;32m[INFO]\033[0m $1"
}

error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1" >&2
}

clean_up() {
    log "Cleaning up temporary files..."
    rm -rf "$temp_folder"
}

cd "$project_root"

if [ -d "$temp_folder" ] && [ "${1:-}" != "clean" ]; then
    log "Fabric source found, updating it..."
    cd "$temp_folder"
    git reset --hard HEAD
    git pull origin $default_branch --rebase
    log "Updated Fabric source."
else
    log "Cloning a fresh copy of Fabric's source..."
    clean_up
    git clone $fabric_repo_url -b $default_branch "$temp_folder"
fi

log "Setting up Python virtual environment..."
cd "$temp_folder"
python -m venv venv
source venv/bin/activate

log "Installing required Python packages..."
pip install -e .
pip install sphinx recommonmark sphinx-markdown-builder sphinxawesome-theme sphinx-toolbox

log "Building Sphinx documentation..."
cd docs
make clean markdown

log "Sphinx build complete. Verifying output..."
if [ ! -d "build/markdown" ]; then
    error "Markdown output not found in 'build/markdown'. Exiting."
    exit 1
fi

log "Produced output..."
ls build/markdown

log "Cleaning up destination folder: $dest_folder"
rm -rf "$dest_folder"/*

log "Copying built documentation to destination: $dest_folder"
mkdir -p "$dest_folder"
cp -r build/markdown/[!\.]* $dest_folder

log "Copy complete. Build finished successfully."
