// Test if-else conditionals
int max(int a, int b) {
    if (a > b) {
        return a;
    } else {
        return b;
    }
}

int main() {
    int x = 5;
    int y = 10;
    int result = max(x, y);
    
    if (result > 8) {
        result = result * 2;
    }
    
    return result;
}
