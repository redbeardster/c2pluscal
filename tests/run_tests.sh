#!/bin/bash

if command -v opam &> /dev/null; then
    eval $(opam env)
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$SCRIPT_DIR"
PASSED=0
FAILED=0
TOTAL=0
VERBOSE=${VERBOSE:-0}

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "  C2PlusCal Test Suite"
echo "========================================="
echo ""

run_test() {
    local test_file=$1
    local test_name=$(basename "$test_file" .c)
    
    TOTAL=$((TOTAL + 1))
    
    echo -n "Testing $test_name... "
    
    local temp_dir=$(mktemp -d)
    local error_log="$temp_dir/error.log"
    
    cd "$temp_dir"
    if frama-c -pluscal "$test_file" > "$error_log" 2>&1; then
        if [ -f "${test_name}.tla" ] && [ -f "${test_name}.cfg" ]; then
            if grep -q "algorithm" "${test_name}.tla" 2>/dev/null; then
                echo -e "${GREEN}PASS${NC}"
                PASSED=$((PASSED + 1))
            else
                echo -e "${YELLOW}WARN${NC} (invalid .tla)"
                FAILED=$((FAILED + 1))
            fi
        else
            echo -e "${RED}FAIL${NC} (no output)"
            FAILED=$((FAILED + 1))
        fi
    else
        echo -e "${RED}FAIL${NC} (error)"
        FAILED=$((FAILED + 1))
        if [ $VERBOSE -eq 1 ]; then
            cat "$error_log"
        fi
    fi
    
    cd - > /dev/null
    rm -rf "$temp_dir"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        *)
            shift
            ;;
    esac
done

for test_file in "$TEST_DIR"/*.c; do
    if [ -f "$test_file" ]; then
        run_test "$test_file"
    fi
done

echo ""
echo "========================================="
echo "  Test Results"
echo "========================================="
echo -e "Total:  $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed.${NC}"
    exit 1
fi
