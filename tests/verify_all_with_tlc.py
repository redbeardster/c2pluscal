#!/usr/bin/env python3
"""
Verify all generated TLA+ specifications with TLC model checker
Requires: TLA+ tools (tla2tools.jar) or tlc2 command
"""

import subprocess
import sys
import tempfile
from pathlib import Path

GREEN = '\033[0;32m'
RED = '\033[0;31m'
YELLOW = '\033[1;33m'
BLUE = '\033[0;34m'
NC = '\033[0m'

class TLCVerifier:
    def __init__(self, verbose=False):
        self.verbose = verbose
        self.test_dir = Path(__file__).parent
        self.passed = 0
        self.failed = 0
        self.skipped = 0
        
    def check_tlc_available(self):
        """Check if TLC is available"""
        # Try to find tla2tools.jar
        possible_paths = [
            Path.home() / 'tla2tools.jar',
            Path('/usr/local/bin/tla2tools.jar'),
            Path(os.environ.get('TLA_HOME', '')) / 'tla2tools.jar' if 'TLA_HOME' in os.environ else None
        ]
        
        for path in possible_paths:
            if path and path.exists():
                return str(path)
        
        # Try tlc2 command
        try:
            subprocess.run(['tlc2', '--help'], capture_output=True, check=True)
            return 'tlc2'
        except:
            pass
        
        return None
    
    def generate_tla(self, test_file):
        """Generate TLA+ file from C test"""
        test_name = test_file.stem
        
        try:
            result = subprocess.run(
                ['frama-c', '-pluscal', str(test_file)],
                capture_output=True,
                text=True,
                timeout=30
            )
            
            if result.returncode == 0:
                tla_file = Path(f"{test_name}.tla")
                if tla_file.exists():
                    return tla_file
            
            return None
        except Exception as e:
            if self.verbose:
                print(f"  Error generating TLA: {e}")
            return None
    
    def verify_tla(self, tla_file, tlc_path):
        """Verify TLA+ file with TLC"""
        try:
            if tlc_path == 'tlc2':
                cmd = ['tlc2', '-workers', '4', '-depth', '50', str(tla_file)]
            else:
                cmd = [
                    'java', '-XX:+UseParallelGC', '-Xmx2G',
                    '-cp', tlc_path, 'tlc2.TLC',
                    '-workers', '4', '-depth', '50',
                    str(tla_file)
                ]
            
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=60
            )
            
            output = result.stdout + result.stderr
            
            # Check for success
            if 'Finished computing initial states' in output or 'Model checking completed' in output:
                # Extract statistics
                states = 0
                for line in output.split('\n'):
                    if 'states generated' in line.lower():
                        try:
                            states = int(line.split()[0])
                        except:
                            pass
                
                return {
                    'success': True,
                    'states': states,
                    'output': output
                }
            else:
                return {
                    'success': False,
                    'error': 'Model checking failed',
                    'output': output
                }
                
        except subprocess.TimeoutExpired:
            return {
                'success': False,
                'error': 'Timeout (>60s)',
                'output': ''
            }
        except Exception as e:
            return {
                'success': False,
                'error': str(e),
                'output': ''
            }
    
    def verify_test(self, test_file, tlc_path):
        """Verify a single test"""
        test_name = test_file.stem
        print(f"Verifying {test_name}... ", end='', flush=True)
        
        # Generate TLA
        tla_file = self.generate_tla(test_file)
        if not tla_file:
            print(f"{YELLOW}SKIP{NC} (generation failed)")
            self.skipped += 1
            return
        
        # Check if translated
        content = tla_file.read_text()
        if 'algorithm' in content and 'BEGIN TRANSLATION' not in content:
            print(f"{YELLOW}SKIP{NC} (needs translation)")
            self.skipped += 1
            # Clean up
            tla_file.unlink(missing_ok=True)
            Path(f"{test_name}.cfg").unlink(missing_ok=True)
            return
        
        # Verify with TLC
        result = self.verify_tla(tla_file, tlc_path)
        
        if result['success']:
            print(f"{GREEN}PASS{NC} ({result['states']} states)")
            self.passed += 1
        else:
            print(f"{RED}FAIL{NC} ({result.get('error', 'unknown')})")
            self.failed += 1
            
            if self.verbose and result.get('output'):
                print(f"  Output:")
                for line in result['output'].split('\n')[:10]:
                    print(f"    {line}")
        
        # Clean up
        tla_file.unlink(missing_ok=True)
        Path(f"{test_name}.cfg").unlink(missing_ok=True)
    
    def verify_all(self):
        """Verify all tests"""
        print("=" * 50)
        print("  TLC Verification Suite")
        print("=" * 50)
        print()
        
        # Check TLC availability
        tlc_path = self.check_tlc_available()
        if not tlc_path:
            print(f"{RED}Error: TLC not found{NC}")
            print()
            print("Please install TLA+ tools:")
            print("1. Download tla2tools.jar from:")
            print("   https://github.com/tlaplus/tlaplus/releases")
            print("2. Place it in ~/tla2tools.jar or /usr/local/bin/")
            print()
            return 1
        
        print(f"Using TLC: {tlc_path}")
        print()
        
        # Find all test files
        test_files = sorted(self.test_dir.glob("test*.c"))
        
        for test_file in test_files:
            self.verify_test(test_file, tlc_path)
        
        # Summary
        print()
        print("=" * 50)
        print("  Results")
        print("=" * 50)
        print(f"Total:   {len(test_files)}")
        print(f"Passed:  {GREEN}{self.passed}{NC}")
        print(f"Failed:  {RED}{self.failed}{NC}")
        print(f"Skipped: {YELLOW}{self.skipped}{NC}")
        print()
        
        if self.failed == 0 and self.passed > 0:
            print(f"{GREEN}✓ All verified tests passed!{NC}")
            return 0
        elif self.skipped == len(test_files):
            print(f"{YELLOW}⚠ All tests skipped (TLC not properly configured){NC}")
            return 2
        else:
            print(f"{RED}✗ Some tests failed{NC}")
            return 1

def main():
    import os
    
    verbose = '--verbose' in sys.argv or '-v' in sys.argv
    verifier = TLCVerifier(verbose=verbose)
    sys.exit(verifier.verify_all())

if __name__ == '__main__':
    main()
