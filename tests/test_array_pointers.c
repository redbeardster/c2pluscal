// Test arrays with pointers
int main() {
    int arr[3] = {10, 20, 30};
    int* ptr = arr;
    
    // Access via pointer
    int first = *ptr;
    
    // Pointer arithmetic
    ptr++;
    int second = *ptr;
    
    // Modify via pointer
    *ptr = 25;
    
    return arr[1];
}
