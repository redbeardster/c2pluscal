#!/bin/bash

# Script to verify TLA+ specifications with TLC model checker
# Usage: ./verify_with_tlc.sh test_simple.tla

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if TLC is available
if ! command -v tlc2 &> /dev/null && ! command -v java &> /dev/null; then
    echo -e "${RED}Error: TLC not found${NC}"
    echo "Please install TLA+ tools or set JAVA_HOME"
    exit 1
fi

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file.tla> [options]"
    echo ""
    echo "Options:"
    echo "  --depth N       Set search depth (default: 100)"
    echo "  --workers N     Set number of worker threads (default: auto)"
    echo "  --deadlock-off  Disable deadlock checking"
    echo "  --verbose       Verbose output"
    exit 1
fi

TLA_FILE=$1
shift

# Default options
DEPTH=100
WORKERS=$(nproc 2>/dev/null || echo 4)
CHECK_DEADLOCK=true
VERBOSE=false

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        --depth)
            DEPTH=$2
            shift 2
            ;;
        --workers)
            WORKERS=$2
            shift 2
            ;;
        --deadlock-off)
            CHECK_DEADLOCK=false
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check if file exists
if [ ! -f "$TLA_FILE" ]; then
    echo -e "${RED}Error: File $TLA_FILE not found${NC}"
    exit 1
fi

# Get base name
BASE_NAME=$(basename "$TLA_FILE" .tla)
CFG_FILE="${BASE_NAME}.cfg"

echo -e "${BLUE}=== TLC Model Checker ===${NC}"
echo "File: $TLA_FILE"
echo "Config: $CFG_FILE"
echo "Depth: $DEPTH"
echo "Workers: $WORKERS"
echo "Deadlock check: $CHECK_DEADLOCK"
echo ""

# Check if PlusCal needs translation
if grep -q "algorithm" "$TLA_FILE" && ! grep -q "BEGIN TRANSLATION" "$TLA_FILE"; then
    echo -e "${YELLOW}Warning: PlusCal algorithm found but not translated${NC}"
    echo "Please translate with TLA+ Toolbox (Ctrl+T) or pcal command"
    echo ""
fi

# Prepare TLC command
TLC_CMD="java -XX:+UseParallelGC -Xmx4G"

# Find TLC jar
if [ -n "$TLA_HOME" ]; then
    TLC_JAR="$TLA_HOME/tla2tools.jar"
elif [ -f "/usr/local/bin/tla2tools.jar" ]; then
    TLC_JAR="/usr/local/bin/tla2tools.jar"
elif [ -f "$HOME/tla2tools.jar" ]; then
    TLC_JAR="$HOME/tla2tools.jar"
else
    echo -e "${YELLOW}Warning: tla2tools.jar not found${NC}"
    echo "Trying to use 'tlc2' command..."
    TLC_CMD="tlc2"
    TLC_JAR=""
fi

# Build command
if [ -n "$TLC_JAR" ]; then
    TLC_CMD="$TLC_CMD -cp $TLC_JAR tlc2.TLC"
fi

TLC_CMD="$TLC_CMD -workers $WORKERS -depth $DEPTH"

if [ "$CHECK_DEADLOCK" = false ]; then
    TLC_CMD="$TLC_CMD -deadlock"
fi

if [ "$VERBOSE" = true ]; then
    TLC_CMD="$TLC_CMD -verbose"
fi

# Add config file if exists
if [ -f "$CFG_FILE" ]; then
    TLC_CMD="$TLC_CMD -config $CFG_FILE"
fi

TLC_CMD="$TLC_CMD $TLA_FILE"

echo -e "${BLUE}Running TLC...${NC}"
echo ""

# Run TLC
if $TLC_CMD 2>&1 | tee /tmp/tlc_output.txt; then
    echo ""
    echo -e "${GREEN}✓ Model checking completed successfully${NC}"
    
    # Extract statistics
    if grep -q "states generated" /tmp/tlc_output.txt; then
        STATES=$(grep "states generated" /tmp/tlc_output.txt | head -1)
        echo -e "${BLUE}Statistics:${NC} $STATES"
    fi
    
    exit 0
else
    echo ""
    echo -e "${RED}✗ Model checking failed${NC}"
    
    # Check for common errors
    if grep -q "Deadlock" /tmp/tlc_output.txt; then
        echo -e "${YELLOW}Deadlock detected${NC}"
    fi
    
    if grep -q "Invariant.*violated" /tmp/tlc_output.txt; then
        echo -e "${YELLOW}Invariant violation detected${NC}"
    fi
    
    exit 1
fi
