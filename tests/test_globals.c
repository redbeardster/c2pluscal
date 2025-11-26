// Test global variables
int global_x = 100;
int global_y = 200;

void modify_globals() {
    global_x = 50;
    global_y = 75;
}

int main() {
    int local = global_x + global_y;
    
    modify_globals();
    
    int result = global_x + global_y;
    
    return result;
}
