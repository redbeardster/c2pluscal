#!/usr/bin/env python3
"""Generate test coverage report"""

import re
from pathlib import Path
from collections import defaultdict

class CoverageAnalyzer:
    def __init__(self):
        self.test_dir = Path(__file__).parent
        self.features = defaultdict(list)
        
    def analyze_test_file(self, test_file):
        """Analyze a test file for features"""
        content = test_file.read_text()
        test_name = test_file.stem
        
        features_found = []
        
        # Check for various C features
        if re.search(r'\bif\s*\(', content):
            features_found.append('conditionals')
        if re.search(r'\bwhile\s*\(', content):
            features_found.append('while_loop')
        if re.search(r'\bfor\s*\(', content):
            features_found.append('for_loop')
        if re.search(r'\bdo\s*{', content):
            features_found.append('do_while_loop')
        if re.search(r'\*\w+', content):
            features_found.append('pointers')
        if re.search(r'&\w+', content):
            features_found.append('address_of')
        if re.search(r'\w+\[\d+\]', content):
            features_found.append('arrays')
        if re.search(r'\bstruct\s+\w+', content):
            features_found.append('structs')
        if re.search(r'->', content):
            features_found.append('struct_pointer')
        if re.search(r'\breturn\s+\w+\(', content):
            features_found.append('function_calls')
        if re.search(r'^\s*int\s+\w+\s*=', content, re.MULTILINE):
            features_found.append('global_variables')
        if re.search(r'\+\+|\-\-', content):
            features_found.append('increment_decrement')
        if re.search(r'\+=|\-=|\*=|/=', content):
            features_found.append('compound_assignment')
        
        # Check for recursion
        func_names = re.findall(r'^\s*\w+\s+(\w+)\s*\([^)]*\)\s*{', content, re.MULTILINE)
        for func_name in func_names:
            if func_name in content[content.find(func_name):]:
                if content.count(func_name) > 1:
                    features_found.append('recursion')
                    break
        
        return features_found
    
    def generate_report(self):
        """Generate coverage report"""
        test_files = sorted(self.test_dir.glob("*.c"))
        
        print("=" * 60)
        print("  C2PlusCal Test Coverage Report")
        print("=" * 60)
        print()
        
        # Analyze all tests
        test_features = {}
        all_features = set()
        
        for test_file in test_files:
            features = self.analyze_test_file(test_file)
            test_features[test_file.stem] = features
            all_features.update(features)
            
        # Print feature coverage
        print("Feature Coverage:")
        print("-" * 60)
        
        feature_names = {
            'conditionals': 'If-else statements',
            'while_loop': 'While loops',
            'for_loop': 'For loops',
            'do_while_loop': 'Do-while loops',
            'pointers': 'Pointer dereferencing',
            'address_of': 'Address-of operator (&)',
            'arrays': 'Arrays',
            'structs': 'Structures',
            'struct_pointer': 'Structure pointers (->)',
            'function_calls': 'Function calls',
            'global_variables': 'Global variables',
            'increment_decrement': 'Increment/Decrement (++/--)',
            'compound_assignment': 'Compound assignment (+=, -=, etc)',
            'recursion': 'Recursion',
        }
        
        for feature in sorted(all_features):
            tests_with_feature = [name for name, feats in test_features.items() if feature in feats]
            count = len(tests_with_feature)
            feature_name = feature_names.get(feature, feature)
            print(f"  {feature_name:40} {count:2} tests")
        
        print()
        print("=" * 60)
        print("Test Details:")
        print("-" * 60)
        
        for test_name in sorted(test_features.keys()):
            features = test_features[test_name]
            print(f"\n{test_name}:")
            if features:
                for feature in sorted(features):
                    feature_name = feature_names.get(feature, feature)
                    print(f"  ✓ {feature_name}")
            else:
                print("  (no features detected)")
        
        print()
        print("=" * 60)
        print("Summary:")
        print("-" * 60)
        print(f"Total tests: {len(test_files)}")
        print(f"Features covered: {len(all_features)}")
        print(f"Average features per test: {sum(len(f) for f in test_features.values()) / len(test_files):.1f}")
        print()

def main():
    analyzer = CoverageAnalyzer()
    analyzer.generate_report()

if __name__ == '__main__':
    main()
