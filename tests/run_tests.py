#!/usr/bin/env python3
"""Test runner for C2PlusCal transpiler"""

import os
import subprocess
import sys
import tempfile
from pathlib import Path

GREEN = '\033[0;32m'
RED = '\033[0;31m'
NC = '\033[0m'

class TestRunner:
    def __init__(self, verbose=False):
        self.verbose = verbose
        self.passed = 0
        self.failed = 0
        self.total = 0
        self.test_dir = Path(__file__).parent
        
    def run_test(self, test_file):
        test_name = test_file.stem
        self.total += 1
        
        print(f"Testing {test_name}... ", end='', flush=True)
        
        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            
            try:
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
                
                result = subprocess.run(
                    ['frama-c', '-pluscal', str(test_file)],
                    cwd=temp_path, capture_output=True, text=True, env=env
                )
                
                if result.returncode == 0:
                    tla_file = temp_path / f"{test_name}.tla"
                    cfg_file = temp_path / f"{test_name}.cfg"
                    
                    if tla_file.exists() and cfg_file.exists():
                        tla_content = tla_file.read_text()
                        if 'algorithm' in tla_content:
                            print(f"{GREEN}PASS{NC}")
                            self.passed += 1
                        else:
                            print(f"{RED}FAIL{NC} (invalid .tla)")
                            self.failed += 1
                    else:
                        print(f"{RED}FAIL{NC} (no output)")
                        self.failed += 1
                else:
                    print(f"{RED}FAIL{NC} (error)")
                    self.failed += 1
                    if self.verbose:
                        print(f"  {result.stderr}")
                        
            except Exception as e:
                print(f"{RED}FAIL{NC} (exception)")
                self.failed += 1
                if self.verbose:
                    print(f"  {e}")
    
    def run_all_tests(self):
        print("=" * 41)
        print("  C2PlusCal Test Suite")
        print("=" * 41)
        print()
        
        test_files = sorted(self.test_dir.glob("*.c"))
        
        for test_file in test_files:
            self.run_test(test_file)
        
        print()
        print("=" * 41)
        print("  Test Results")
        print("=" * 41)
        print(f"Total:  {self.total}")
        print(f"Passed: {GREEN}{self.passed}{NC}")
        print(f"Failed: {RED}{self.failed}{NC}")
        print()
        
        if self.failed == 0:
            print(f"{GREEN}✓ All tests passed!{NC}")
            return 0
        else:
            print(f"{RED}✗ Some tests failed.{NC}")
            return 1

def main():
    verbose = '--verbose' in sys.argv or '-v' in sys.argv
    runner = TestRunner(verbose=verbose)
    sys.exit(runner.run_all_tests())

if __name__ == '__main__':
    main()
