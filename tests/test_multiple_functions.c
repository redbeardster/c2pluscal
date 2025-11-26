// Test multiple function calls
int add(int a, int b) {
    return a + b;
}

int multiply(int a, int b) {
    return a * b;
}

int compute(int x) {
    int temp = add(x, 5);
    return multiply(temp, 2);
}

int main() {
    int result = compute(10);
    return result;
}
