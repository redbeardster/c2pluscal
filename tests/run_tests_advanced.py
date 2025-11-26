#!/usr/bin/env python3
"""Advanced test runner for C2PlusCal transpiler with content validation"""

import os
import subprocess
import sys
import tempfile
import re
from pathlib import Path

GREEN = '\033[0;32m'
RED = '\033[0;31m'
YELLOW = '\033[1;33m'
BLUE = '\033[0;34m'
NC = '\033[0m'

class TestValidator:
    """Validates generated TLA+ files"""
    
    @staticmethod
    def validate_tla_structure(content):
        """Check if TLA file has proper structure"""
        checks = {
            'has_module': bool(re.search(r'MODULE\s+\w+', content)),
            'has_algorithm': 'algorithm' in content,
            'has_extends': 'EXTENDS' in content,
            'has_variables': 'variables' in content,
            'has_end_module': content.strip().endswith('=' * 80),
        }
        return checks
    
    @staticmethod
    def validate_cfg_structure(content):
        """Check if CFG file has proper structure"""
        checks = {
            'has_constants': 'CONSTANTS' in content or 'CONSTANT' in content,
            'has_init': 'INIT' in content,
            'has_next': 'NEXT' in content,
        }
        return checks
    
    @staticmethod
    def check_pluscal_syntax(content):
        """Check for common PlusCal syntax elements"""
        elements = {
            'has_process_or_procedure': bool(re.search(r'(process|procedure)', content)),
            'has_begin': 'begin' in content.lower(),
            'has_end': 'end' in content.lower(),
        }
        return elements

class AdvancedTestRunner:
    def __init__(self, verbose=False, validate=True):
        self.verbose = verbose
        self.validate = validate
        self.passed = 0
        self.failed = 0
        self.warnings = 0
        self.total = 0
        self.test_dir = Path(__file__).parent
        self.validator = TestValidator()
        self.results = []
        
    def run_test(self, test_file):
        test_name = test_file.stem
        self.total += 1
        
        print(f"Testing {test_name}... ", end='', flush=True)
        
        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            
            try:
                # Get opam environment
                opam_env = subprocess.run(
                    ['opam', 'env', '--shell=bash'],
                    capture_output=True, text=True, check=True
                )
                
                env = os.environ.copy()
                for line in opam_env.stdout.split('\n'):
                    if line.startswith('export '):
                        line = line[7:]
                        if '=' in line:
                            key, value = line.split('=', 1)
                            value = value.strip().strip("'").strip('"').rstrip(';')
                            env[key] = value
                
                # Run transpiler
                result = subprocess.run(
                    ['frama-c', '-pluscal', str(test_file)],
                    cwd=temp_path, capture_output=True, text=True, env=env
                )
                
                test_result = {
                    'name': test_name,
                    'passed': False,
                    'warnings': [],
                    'errors': []
                }
                
                if result.returncode == 0:
                    tla_file = temp_path / f"{test_name}.tla"
                    cfg_file = temp_path / f"{test_name}.cfg"
                    
                    if tla_file.exists() and cfg_file.exists():
                        tla_content = tla_file.read_text()
                        cfg_content = cfg_file.read_text()
                        
                        # Basic check
                        if 'algorithm' in tla_content:
                            test_result['passed'] = True
                            
                            # Advanced validation
                            if self.validate:
                                tla_checks = self.validator.validate_tla_structure(tla_content)
                                cfg_checks = self.validator.validate_cfg_structure(cfg_content)
                                syntax_checks = self.validator.check_pluscal_syntax(tla_content)
                                
                                # Check for issues
                                if not all(tla_checks.values()):
                                    for check, passed in tla_checks.items():
                                        if not passed:
                                            test_result['warnings'].append(f"TLA: {check} failed")
                                
                                if not all(cfg_checks.values()):
                                    for check, passed in cfg_checks.items():
                                        if not passed:
                                            test_result['warnings'].append(f"CFG: {check} failed")
                                
                                test_result['tla_size'] = len(tla_content)
                                test_result['cfg_size'] = len(cfg_content)
                            
                            if test_result['warnings']:
                                print(f"{YELLOW}PASS*{NC}")
                                self.warnings += 1
                                self.passed += 1
                            else:
                                print(f"{GREEN}PASS{NC}")
                                self.passed += 1
                        else:
                            print(f"{RED}FAIL{NC} (invalid .tla)")
                            test_result['errors'].append("No algorithm found in TLA file")
                            self.failed += 1
                    else:
                        print(f"{RED}FAIL{NC} (no output)")
                        test_result['errors'].append("Output files not generated")
                        self.failed += 1
                else:
                    print(f"{RED}FAIL{NC} (error)")
                    test_result['errors'].append(f"Transpiler error: {result.stderr[:100]}")
                    self.failed += 1
                
                self.results.append(test_result)
                
                # Verbose output
                if self.verbose and (test_result['warnings'] or test_result['errors']):
                    for warning in test_result['warnings']:
                        print(f"  {YELLOW}⚠{NC} {warning}")
                    for error in test_result['errors']:
                        print(f"  {RED}✗{NC} {error}")
                    if 'tla_size' in test_result:
                        print(f"  {BLUE}ℹ{NC} TLA size: {test_result['tla_size']} bytes")
                        print(f"  {BLUE}ℹ{NC} CFG size: {test_result['cfg_size']} bytes")
                        
            except Exception as e:
                print(f"{RED}FAIL{NC} (exception)")
                self.failed += 1
                if self.verbose:
                    print(f"  {RED}✗{NC} {e}")
    
    def print_summary(self):
        print()
        print("=" * 41)
        print("  Test Results")
        print("=" * 41)
        print(f"Total:    {self.total}")
        print(f"Passed:   {GREEN}{self.passed}{NC}")
        print(f"Failed:   {RED}{self.failed}{NC}")
        if self.warnings > 0:
            print(f"Warnings: {YELLOW}{self.warnings}{NC}")
        print()
        
        if self.failed == 0:
            if self.warnings == 0:
                print(f"{GREEN}✓ All tests passed!{NC}")
            else:
                print(f"{YELLOW}✓ All tests passed with warnings{NC}")
            return 0
        else:
            print(f"{RED}✗ Some tests failed.{NC}")
            return 1
    
    def print_detailed_report(self):
        """Print detailed test report"""
        if not self.verbose:
            return
        
        print()
        print("=" * 41)
        print("  Detailed Report")
        print("=" * 41)
        
        for result in self.results:
            status = f"{GREEN}✓{NC}" if result['passed'] else f"{RED}✗{NC}"
            print(f"{status} {result['name']}")
            
            if 'tla_size' in result:
                print(f"    TLA: {result['tla_size']} bytes")
                print(f"    CFG: {result['cfg_size']} bytes")
    
    def run_all_tests(self):
        print("=" * 41)
        print("  C2PlusCal Advanced Test Suite")
        print("=" * 41)
        if self.validate:
            print("  (with content validation)")
        print()
        
        test_files = sorted(self.test_dir.glob("*.c"))
        
        for test_file in test_files:
            self.run_test(test_file)
        
        result = self.print_summary()
        self.print_detailed_report()
        
        return result

def main():
    verbose = '--verbose' in sys.argv or '-v' in sys.argv
    no_validate = '--no-validate' in sys.argv
    
    runner = AdvancedTestRunner(verbose=verbose, validate=not no_validate)
    sys.exit(runner.run_all_tests())

if __name__ == '__main__':
    main()
