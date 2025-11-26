// Test pointers and dereferencing
void modify(int* ptr) {
    *ptr = 42;
}

int main() {
    int x = 10;
    int* p = &x;
    *p = 20;
    
    modify(&x);
    
    return x;
}
