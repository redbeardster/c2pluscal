# Changelog

## [Unreleased] - 2024-11-27

### Added
- Comprehensive test suite with 8 test cases
- Python test runner (`tests/run_tests.py`) with colored output
- Bash test runner (`tests/run_tests.sh`) as alternative
- GitHub Actions CI/CD workflow
- Makefile for convenient building and testing
- Test documentation (`tests/README.md`, `TESTING.md`)

### Test Coverage
- `test_simple.c` - Basic arithmetic and variables
- `test_conditionals.c` - If-else statements
- `test_loops.c` - While, for, and do-while loops
- `test_pointers.c` - Pointer operations and dereferencing
- `test_arrays.c` - Array operations and indexing
- `test_structs.c` - Structure definitions and field access
- `test_recursion.c` - Recursive function calls
- `test.c` - Comprehensive test with all features

### Changed
- Updated README.md with testing section and version requirements
- Removed note about missing test infrastructure

### Technical
- Compatible with OCaml 5.1.1
- Compatible with Frama-C 30.0 (Zinc)
- All 8 tests passing successfully
