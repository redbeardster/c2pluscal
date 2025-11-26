#!/usr/bin/env python3
"""Compare test outputs and track regressions"""

import json
import subprocess
import sys
import tempfile
from pathlib import Path
from datetime import datetime

class TestComparison:
    def __init__(self, baseline_file='test_baseline.json'):
        self.baseline_file = Path(__file__).parent / baseline_file
        self.baseline = self.load_baseline()
        self.current_results = {}
        
    def load_baseline(self):
        """Load baseline test results"""
        if self.baseline_file.exists():
            with open(self.baseline_file, 'r') as f:
                return json.load(f)
        return {}
    
    def save_baseline(self):
        """Save current results as baseline"""
        data = {
            'timestamp': datetime.now().isoformat(),
            'results': self.current_results
        }
        with open(self.baseline_file, 'w') as f:
            json.dump(data, f, indent=2)
        print(f"Baseline saved to {self.baseline_file}")
    
    def run_test(self, test_file):
        """Run a single test and collect metrics"""
        test_name = test_file.stem
        
        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            
            try:
                result = subprocess.run(
                    ['frama-c', '-pluscal', str(test_file)],
                    cwd=temp_path,
                    capture_output=True,
                    text=True,
                    timeout=30
                )
                
                metrics = {
                    'success': result.returncode == 0,
                    'stderr_lines': len(result.stderr.split('\n')),
                }
                
                tla_file = temp_path / f"{test_name}.tla"
                cfg_file = temp_path / f"{test_name}.cfg"
                
                if tla_file.exists():
                    tla_content = tla_file.read_text()
                    metrics['tla_size'] = len(tla_content)
                    metrics['tla_lines'] = len(tla_content.split('\n'))
                    metrics['has_algorithm'] = 'algorithm' in tla_content
                
                if cfg_file.exists():
                    cfg_content = cfg_file.read_text()
                    metrics['cfg_size'] = len(cfg_content)
                    metrics['cfg_lines'] = len(cfg_content.split('\n'))
                
                return metrics
                
            except subprocess.TimeoutExpired:
                return {'success': False, 'error': 'timeout'}
            except Exception as e:
                return {'success': False, 'error': str(e)}
    
    def compare_results(self, test_name, current, baseline):
        """Compare current results with baseline"""
        if not baseline:
            return {'status': 'new', 'changes': []}
        
        changes = []
        
        # Check for regressions
        if baseline.get('success') and not current.get('success'):
            changes.append('REGRESSION: Test now fails')
        elif not baseline.get('success') and current.get('success'):
            changes.append('IMPROVEMENT: Test now passes')
        
        # Check size changes
        if 'tla_size' in current and 'tla_size' in baseline:
            size_diff = current['tla_size'] - baseline['tla_size']
            if abs(size_diff) > 100:  # Significant change
                pct = (size_diff / baseline['tla_size']) * 100
                changes.append(f"TLA size changed: {size_diff:+d} bytes ({pct:+.1f}%)")
        
        status = 'regression' if any('REGRESSION' in c for c in changes) else \
                 'improved' if any('IMPROVEMENT' in c for c in changes) else \
                 'changed' if changes else 'unchanged'
        
        return {'status': status, 'changes': changes}
    
    def run_all_tests(self):
        """Run all tests and compare with baseline"""
        test_dir = Path(__file__).parent
        test_files = sorted(test_dir.glob("*.c"))
        
        print("Running tests and comparing with baseline...")
        print()
        
        regressions = []
        improvements = []
        new_tests = []
        
        for test_file in test_files:
            test_name = test_file.stem
            print(f"Testing {test_name}... ", end='', flush=True)
            
            current = self.run_test(test_file)
            self.current_results[test_name] = current
            
            baseline = self.baseline.get('results', {}).get(test_name, {})
            comparison = self.compare_results(test_name, current, baseline)
            
            # Print status
            if comparison['status'] == 'new':
                print("NEW")
                new_tests.append(test_name)
            elif comparison['status'] == 'regression':
                print("REGRESSION")
                regressions.append((test_name, comparison['changes']))
            elif comparison['status'] == 'improved':
                print("IMPROVED")
                improvements.append((test_name, comparison['changes']))
            elif comparison['status'] == 'changed':
                print("CHANGED")
            else:
                print("OK")
            
            # Print changes
            for change in comparison['changes']:
                print(f"  {change}")
        
        # Summary
        print()
        print("=" * 50)
        print("Summary")
        print("=" * 50)
        print(f"Total tests: {len(test_files)}")
        print(f"New tests: {len(new_tests)}")
        print(f"Improvements: {len(improvements)}")
        print(f"Regressions: {len(regressions)}")
        print()
        
        if regressions:
            print("REGRESSIONS DETECTED:")
            for test_name, changes in regressions:
                print(f"  - {test_name}")
                for change in changes:
                    print(f"    {change}")
            return 1
        
        return 0

def main():
    comparison = TestComparison()
    
    if '--save-baseline' in sys.argv:
        # Run tests and save as baseline
        comparison.run_all_tests()
        comparison.save_baseline()
    else:
        # Run tests and compare
        result = comparison.run_all_tests()
        sys.exit(result)

if __name__ == '__main__':
    main()
