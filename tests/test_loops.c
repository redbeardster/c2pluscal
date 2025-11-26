// Test loops: while, for, do-while
int main() {
    int i = 0;
    int sum = 0;
    
    // While loop
    while (i < 5) {
        sum += i;
        i++;
    }
    
    // For loop
    for (int j = 0; j < 3; j++) {
        sum += j;
    }
    
    // Do-while loop
    int k = 0;
    do {
        k++;
    } while (k < 2);
    
    return sum;
}
