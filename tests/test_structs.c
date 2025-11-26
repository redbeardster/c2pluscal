// Test structs
struct Point {
    int x;
    int y;
};

int main() {
    struct Point p;
    p.x = 10;
    p.y = 20;
    
    struct Point* ptr = &p;
    ptr->x = 30;
    
    return p.x + p.y;
}
