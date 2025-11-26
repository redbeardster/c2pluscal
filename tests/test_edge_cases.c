// Test edge cases and boundary conditions
int main() {
    // Zero values
    int zero = 0;
    
    // Negative numbers
    int negative = -42;
    
    // Multiple assignments
    int a, b, c;
    a = b = c = 5;
    
    // Nested conditionals
    if (zero == 0) {
        if (negative < 0) {
            a = 10;
        }
    }
    
    // Empty loop
    int i = 0;
    while (i < 0) {
        i++;
    }
    
    return a;
}
