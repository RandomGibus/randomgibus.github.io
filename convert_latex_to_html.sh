#!/bin/bash

# Script to convert LaTeX files to HTML
# Usage: ./convert_latex_to_html.sh [input.tex] [output.html]

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if pandoc is installed
check_pandoc() {
    if command -v pandoc &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to install pandoc (macOS)
install_pandoc() {
    echo -e "${YELLOW}Pandoc is not installed.${NC}"
    echo -e "${YELLOW}Attempting to install via Homebrew...${NC}"
    
    if command -v brew &> /dev/null; then
        brew install pandoc
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Pandoc installed successfully!${NC}"
            return 0
        else
            echo -e "${RED}Failed to install pandoc via Homebrew.${NC}"
            return 1
        fi
    else
        echo -e "${RED}Homebrew not found. Please install pandoc manually:${NC}"
        echo "  macOS: brew install pandoc"
        echo "  Linux: sudo apt-get install pandoc (Ubuntu/Debian) or sudo yum install pandoc (RHEL/CentOS)"
        echo "  Or visit: https://pandoc.org/installing.html"
        return 1
    fi
}

# Check for pandoc
if ! check_pandoc; then
    read -p "Pandoc is required but not installed. Install it now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_pandoc
        if [ $? -ne 0 ]; then
            exit 1
        fi
    else
        echo -e "${RED}Please install pandoc to continue.${NC}"
        exit 1
    fi
fi

# Get input and output files
INPUT_FILE="${1:-Final.tex}"
OUTPUT_FILE="${2:-index.html}"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}Error: Input file '$INPUT_FILE' not found.${NC}"
    exit 1
fi

# Convert LaTeX to HTML
echo -e "${GREEN}Converting $INPUT_FILE to $OUTPUT_FILE...${NC}"

pandoc "$INPUT_FILE" \
    --from=latex \
    --to=html5 \
    --standalone \
    --mathjax \
    --css=https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css \
    --output="$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully converted to $OUTPUT_FILE${NC}"
    echo -e "${GREEN}You can open it in your browser!${NC}"
else
    echo -e "${RED}Conversion failed.${NC}"
    exit 1
fi

